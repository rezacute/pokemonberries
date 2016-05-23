//
//  pokeberriesTests.swift
//  pokeberriesTests
//
//  Created by syahRiza on 5/15/16.
//  Copyright © 2016 reza. All rights reserved.
//

import XCTest
import PokemonKit
import PromiseKit
import Alamofire
import AlamofireImage

@testable import pokeberries


class pokeberriesTests: XCTestCase {
    
    override func setUp() {

        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFectingBerryInfo() {
        let asyncExpectation = expectationWithDescription("Fetch berries")
        PokemonKit.fetchBerry("1")
            .then { response  -> Void in
                XCTAssertNotNil(response);
                let itemId = (response.item!.url! as NSString).lastPathComponent
                PokemonKit.fetchItem(itemId)
                    .then { item  -> Void in
                        XCTAssertNotNil(item);
                        item.sprites!.fetchImage()
                            .then { image  -> Void in
                                XCTAssertNotNil(image);

                                asyncExpectation.fulfill();
                            }
                            .error{ err in
                                XCTFail("Should not failed with \(err)")
                                asyncExpectation.fulfill();
                        }

                    }
                    .error{ err in
                        XCTFail("Should not failed with \(err)")
                        asyncExpectation.fulfill();
                }
            }
            .error{ err in
                XCTFail("Should not failed with \(err)")
                asyncExpectation.fulfill();
        }

        self.waitForExpectationsWithTimeout(30) { (err) -> Void in
            XCTAssertNil(err, "Something went wrong")
        }
    }
    func testFectingBerries() {
        let asyncExpectation = expectationWithDescription("Fetch berries")
        PokemonKit.fetchBerryList().then { (page) -> Void in

            asyncExpectation.fulfill();
            }.error{ err in
                XCTFail("Should not failed with \(err)")
                asyncExpectation.fulfill();
        }
        self.waitForExpectationsWithTimeout(30) { (err) -> Void in
            XCTAssertNil(err, "Something went wrong")
        }
    }

}
