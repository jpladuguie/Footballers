//
//  PlayerData+CoreDataProperties.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 21/10/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import Foundation
import CoreData


extension PlayerData {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<PlayerData> {
        return NSFetchRequest<PlayerData>(entityName: "PlayerData");
    }

    @NSManaged public var playerId: String?
    @NSManaged public var name: String?
    @NSManaged public var regionCode: String?
    @NSManaged public var historicRating: String?
    @NSManaged public var currentRating: String?
    @NSManaged public var overallRating: String?

}
