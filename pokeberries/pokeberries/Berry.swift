//
//  Berry.swift
//  pokeberries
//
//  Created by syahRiza on 5/20/16.
//  Copyright © 2016 reza. All rights reserved.
//
/*
 name	The name for this berry resource	string
 growth_time	Time it takes the tree to grow one stage, in hours. Berry trees go through four of these growth stages before they can be picked.	integer
 max_harvest	The maximum number of these berries that can grow on one tree in Generation IV	integer
 natural_gift_power	The power of the move "Natural Gift" when used with this Berry	integer
 size	The size of this Berry, in millimeters	integer
 smoothness	The smoothness of this Berry, used in making Pokéblocks or Poffins	integer
 soil_dryness	The speed at which this Berry dries out the soil as it grows. A higher rate means the soil dries more quickly.	integer
 */
import Foundation
import RealmSwift

class Berry : Object {
    dynamic var name = ""
    dynamic var growthTime : Int = -1
    dynamic var maxHarvest : Int = -1
    dynamic var naturalGiftPower : Int = -1
    dynamic var size : Int = -1
    dynamic var smoothness : Int = -1
    dynamic var soilDryness : Int = -1
    dynamic var spriteLocalUrl : String? = nil

    dynamic var id : Int = 0

    override class func primaryKey() -> String? {
        return "id"
    }

}