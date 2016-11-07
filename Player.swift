//
//  Player.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 17/08/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import Foundation
import SwiftyJSON

// A class which contains player data for when a player screen or compare screen is loaded.
// It needs the player ID to initialise, and will automatically get the summary and personal
// Details by HTTP request. Further details can be obtained by calling the other methods, and
// Once details have been received, they will be stored until the app terminates.
class Player {
    
    // Initialise variables.
    // Player id.
    let id: String
    // Url for player profile image and team crest image.
    let imageUrl: String
    let teamImageUrl: String
    // Player personal details, e.g. age, nationality and height.
    var personalDetails = [String: String]()
    // Statistics dictionaries.
    var statistics = [[String]]()
    // Player ratings.
    var ratings = [[String]]()
    
    init(id: String) {
        // Set ID and player profile image url.
        self.id = id
        
        let data = getDataFromAPI(PlayerId: self.id)
        
        self.imageUrl = data["PhotoUrl"].rawString()!
        self.teamImageUrl = ""
        
        
        
        // Parse the data to get the personal details. Personal details never need to be loaded
        // From url again after the player has been initialised.
        let personalDetailValues = ["Name", "Team", "Height", "Weight", "Nationality", "RegionCode", "Jersey"]
        for value in personalDetailValues {
            self.personalDetails[value] = data[value].rawString()!
        }
        
        print(data["BirthDate"].rawString()!)
        self.personalDetails["Age"] = data["BirthDate"].rawString()!
        
        
        self.ratings.append(["Attacking", data["AttackingRating"].rawString()!])
        self.ratings.append(["Defending", data["DefendingRating"].rawString()!])
        self.ratings.append(["Passing", data["PassingRating"].rawString()!])
        self.ratings.append(["Discipline", data["DisciplineRating"].rawString()!])
        
        
        let statisticValues = ["Games", "Minutes", "Goals", "Assists", "YellowCards", "RedCards", "ShotSuccess", "PassSuccess", "TacklesWon"]
        for value in statisticValues {
            self.statistics.append([value, data[value].rawString()!])
        }
        
        
    }
    
    func getPersonalDetails() -> [String: String] {
        return personalDetails
    }
    
    func getSummaryStats() -> [[String]] {
        return statistics
    }
}
