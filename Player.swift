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
    // Player ratings.
    var ratings = [[String]]()
    // Statistics dictionaries.
    var statistics = [[String]]()
    
    init(id: String) {
        // Set ID.
        self.id = id
        
        // Get the player data from the API.
        let data = getDataFromAPI(PlayerId: self.id)
        
        // Set the profile image and team image urls.
        self.imageUrl = data["PhotoUrl"].rawString()!
        self.teamImageUrl = hostUrl + "/TeamImages/" + data["TeamId"].rawString()! + ".png"
        
        // Parse the data to get the personal details. Personal details never need to be loaded
        // From url again after the player has been initialised.
        let personalDetailValues = ["Name", "Team", "Height", "Weight", "Nationality", "RegionCode", "Jersey", "Age"]
        for value in personalDetailValues {
            self.personalDetails[value] = data[value].rawString()!
        }
        
        // Set the values for the ratings.
        self.ratings.append(["Attacking", data["AttackingRating"].rawString()!])
        self.ratings.append(["Defending", data["DefendingRating"].rawString()!])
        self.ratings.append(["Passing", data["PassingRating"].rawString()!])
        self.ratings.append(["Discipline", data["DisciplineRating"].rawString()!])
        
        // Add statistics from json.
        let statisticValues = ["Games", "Minutes", "Goals", "Assists"]
        for value in statisticValues {
            self.statistics.append([value, data[value].rawString()!])
        }
        
        // Add statistics which have a different name to their json value.
        self.statistics.append(["Yellow Cards", data["YellowCards"].rawString()!])
        self.statistics.append(["Red Cards", data["RedCards"].rawString()!])
        
        // Get the float statistics to 1 decimal place. Add percentage symbols to statistics which need one.
        self.statistics.append(["Shots on Target Percentage", String(format: "%.1f%%", Float(data["ShotSuccess"].rawString()!)!)])
        self.statistics.append(["Pass Success Percentage", String(format: "%.1f%%", Float(data["PassSuccess"].rawString()!)!)])
        self.statistics.append(["Tackles Won per Game", String(format: "%.1f", Float(data["TacklesWon"].rawString()!)!)])

    }
    
    func getPersonalDetails() -> [String: String] {
        return personalDetails
    }
    
    func getSummaryStats() -> [[String]] {
        return statistics
    }
}
