//
//  PlayerFavouritesData+CoreDataProperties.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 21/10/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import Foundation
import CoreData


extension PlayerFavouritesData {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<PlayerFavouritesData> {
        return NSFetchRequest<PlayerFavouritesData>(entityName: "PlayerFavouritesData");
    }

    @NSManaged public var playerId: String?
    @NSManaged public var name: String?
    @NSManaged public var regionCode: String?
    @NSManaged public var team: String?
    @NSManaged public var photoUrl: String?

}
