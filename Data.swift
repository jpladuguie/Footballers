//
//  Data.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 18/08/2016.
//  Copyright © 2016 Jean-Pierre Laduguie. All rights reserved.
//

// Everything to do with managing data. Functions are:

import Foundation
import SwiftyJSON

// Gets the data from the API. There are three possible calls to be made: getPlayer, which returns data on a single player;
// getPlayers, which returns a list of players sorted by the variable SortValue; and searchForPlayer, which searches for 
// Players based on a string.
func getDataFromAPI(PlayerId: String? = nil, SortValue: String? = nil, StartPosition: String? = nil, EndPosition: String? = nil, SearchString: String? = nil) -> JSON {
    // Initialise url to empty string and create data variable.
    var url = ""
    var data: JSON = [:]
    
    // If PlayerId passed to function, call getPlayer.
    if PlayerId != nil {
        url = hostUrl + "/getPlayer?PlayerId=" + PlayerId!
    }
    // If SortValue passed to function, call getPlayers.
    else if SortValue != nil {
        url = hostUrl + "/getPlayers?SortValue=" + SortValue! + "&StartPosition=" + StartPosition! + "&EndPosition=" + EndPosition!
    }
    // If SearchString passed to function, call searchForPlayers.
    else if SearchString != nil {
        url = hostUrl + "/searchForPlayers?SearchString=" + SearchString!
    }
    // Otherwise, invalid combination of parameters given to function. Return an empty json object.
    else {
        print("Invalid arguments passed to getDataFromAPI.")
        return data
    }
    
    // Try to get the data.
    do {
        let response = try NSData(contentsOf: NSURL(string: url) as! URL, options: NSData.ReadingOptions())
        // Parse it as json.
        data = JSON(data: response as Data)
        // Return the data.
        return data
    // If the data cannot be received, print the error and return an empty json object.
    } catch {
        print(error)
        return data
    }
}

// Returns player rankings as an array of dictionaries.
// Each player is represented as a dictionary containing their PlayerId, Name, RegionCode, Team and statistic value.
// A SortValue is needed, which is what the players are being sorted by, as well as a StartPosition and an EndPosition, which are
// The positions in the rankings between which the players will be returned.
func getPlayerRankings(SortValue: String, StartPosition: Int, EndPosition: Int) -> [[String: String]] {
    
    // Create an empty array to return the data.
    var returnData: [[String: String]] = [[String: String]]()
    
    // Get the data from the API.
    let players = getDataFromAPI(SortValue: SortValue, StartPosition: String(StartPosition), EndPosition: String(EndPosition))
    
    // Loop through each player in the data, and append it as a dictionary to the returnData.
    for (_,player):(String, JSON) in players {
        returnData.append(["PlayerId": player["PlayerId"].rawString()!, "Name": player["Name"].rawString()!, "RegionCode": player["RegionCode"].rawString()!, SortValue: player[SortValue].rawString()!, "Team": player["Team"].rawString()!])
    }
    
    // Return the data.
    return returnData
}

// Search for player.
func searchForPlayer(SearchString: String) -> [[String: String]] {
    var returnData: [[String: String]] = [[String: String]]()
    
    // Replace spaces with %20.
    let string = SearchString.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
    let players = getDataFromAPI(SearchString: string)
    
    for (_,player):(String, JSON) in players {
        returnData.append(["PlayerId": player["PlayerId"].rawString()!,"Name": player["Name"].rawString()!, "RegionCode": player["RegionCode"].rawString()!])
    }
    
    return returnData
}




