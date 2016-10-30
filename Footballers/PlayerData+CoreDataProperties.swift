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
    
    @NSManaged public var aerialWonPerGame: NSNumber?
    @NSManaged public var apps: NSNumber?
    @NSManaged public var assistTotal: NSNumber?
    @NSManaged public var attackingRating: NSNumber?
    @NSManaged public var clearancePerGame: NSNumber?
    @NSManaged public var crossesPerGame: NSNumber?
    @NSManaged public var defendingRating: NSNumber?
    @NSManaged public var disciplineRating: NSNumber?
    @NSManaged public var dribbleWonPerGame: NSNumber?
    @NSManaged public var foulsPerGame: NSNumber?
    @NSManaged public var goal: NSNumber?
    @NSManaged public var interceptionPerGame: NSNumber?
    @NSManaged public var keyPassPerGame: NSNumber?
    @NSManaged public var name: String?
    @NSManaged public var outfielderBlockPerGame: NSNumber?
    @NSManaged public var passingRating: NSNumber?
    @NSManaged public var passSuccess: NSNumber?
    @NSManaged public var playerId: String?
    @NSManaged public var positions: String?
    @NSManaged public var rating: NSNumber?
    @NSManaged public var redCard: NSNumber?
    @NSManaged public var regionCode: String?
    @NSManaged public var shotsPerGame: NSNumber?
    @NSManaged public var tacklePerGame: NSNumber?
    @NSManaged public var teamId: String?
    @NSManaged public var teamName: String?
    @NSManaged public var totalPassesPerGame: NSNumber?
    @NSManaged public var yellowCard: NSNumber?
    

}
