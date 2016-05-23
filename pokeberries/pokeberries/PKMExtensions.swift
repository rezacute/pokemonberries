//
//  PKMExtensions.swift
//  pokeberries
//
//  Created by syahRiza on 5/20/16.
//  Copyright © 2016 reza. All rights reserved.
//
import PokemonKit
import PromiseKit
import Alamofire
import AlamofireImage
import Foundation

extension PKMItemSprites{
    public func fetchImage() -> Promise<UIImage>{
        return Promise { fulfill, reject in
            let URL = self.defaultDepiction
            Alamofire.request(.GET, URL!)
                .responseImage { response in
                    if let image = response.result.value {
                        fulfill(image)
                    }else{
                        reject(response.result.error!)
                    }
            }
        }
    }
}
/**
 Fetch Berry list

 - returns: A promise with PKMPagedObject
 */
public func fetchBerryList(URL : String) -> Promise<PKMPagedObject>{
    return Promise { fulfill, reject in
        Alamofire.request(.GET, URL).responseObject() { (response: Response<PKMPagedObject, NSError>) in
            if (response.result.isSuccess) {
                fulfill(response.result.value!)
            }else{
                reject(response.result.error!)
            }
        }
    };
}