//
//  AppManager.swift
//  pokeberries
//
//  Created by syahRiza on 5/20/16.
//  Copyright © 2016 reza. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import PokemonKit
import ARSLineProgress


let NEXT_BERRY_URL_KEY = "CURRENT_BERRY_URL_KEY"
let ALL_DOWNLOADED = "ALL_DOWNLOADED"
class Manager {
    static let sharedInstance = Manager()
    private var maxFetch = 20
    private var currentLoaded = 0
    var completionBlock: (() -> Void)?
    
    private init(){
        setDefaultRealmForUser("default")
    }
    private func setDefaultRealmForUser(username: String) {
        var config = Realm.Configuration()


        // Use the default directory, but replace the filename with the username
        config.fileURL = config.fileURL?
            .URLByDeletingLastPathComponent?
            .URLByAppendingPathComponent("\(username).realm")


        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
    func saveBerry(bID : String){
        guard let realm = try? Realm() else{
            return
        }

        fetchBerry(bID).then { (pBerry) -> Void in

            let itemId = (pBerry.item!.url! as NSString).lastPathComponent
            PokemonKit.fetchItem(itemId)
                .then { item  -> Void in
                    let berry = Berry()
                    berry.growthTime = pBerry.growthTime!
                    berry.id = Int(bID)!
                    berry.maxHarvest = pBerry.maxHarvest!
                    berry.soilDryness = pBerry.soilDryness!
                    berry.name = pBerry.name!
                    berry.naturalGiftPower = pBerry.naturalGiftPower!
                    berry.growthTime = pBerry.growthTime!
                    berry.size = pBerry.size!
                    berry.smoothness = pBerry.smoothness!
                    try! realm.write({

                        realm.add(berry)
                        dispatch_async(dispatch_get_main_queue(), { 
                            self.currentLoaded += 1
                            if self.currentLoaded == 2 {
                                ARSLineProgress.showSuccess()
                                self.completionBlock?()
                            }

                        })

                    })
            }

        }
    }
    func fetchData(){

        let defaults = NSUserDefaults.standardUserDefaults()
        if let nextPageUrl = defaults.valueForKey(NEXT_BERRY_URL_KEY) as? String {
            if nextPageUrl != "ALL_DOWNLOADED" {
                ARSLineProgress.showWithProgress(initialValue: 0)
                fetchBerryList(nextPageUrl).then({ (page) -> Void in
                    if page.next == nil {
                        defaults.setObject(ALL_DOWNLOADED, forKey: NEXT_BERRY_URL_KEY)
                    }else {
                        defaults.setObject(page.next!, forKey: NEXT_BERRY_URL_KEY)
                    }
                    defaults.synchronize()
                    self.completionBlock?()
                    self.maxFetch = page.results!.count

                    for result in page.results! {
                        let bID = (result.url! as NSString).lastPathComponent
                        self.saveBerry(bID)
                    }

                })
            }
        }else{
            fetchBerryList().then({ (page) -> Void in
                ARSLineProgress.showWithProgress(initialValue: 0)
                defaults.setObject(page.next, forKey: NEXT_BERRY_URL_KEY)
                defaults.synchronize()
                self.maxFetch = page.results!.count
                for result in page.results! {
                    let bID = (result.url! as NSString).lastPathComponent
                    self.saveBerry(bID)
                }
            })
        }
    }
}