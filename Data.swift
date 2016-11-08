//
//  Data.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 18/08/2016.
//  Copyright © 2016 jp. All rights reserved.
//

// Everything to do with managing data. Functions are:
//
// getDataFromUrl - gets the data from the API depending on the type (i.e. player, player
//                  ranking, team) and returns it as a string with JSON encoding.
// getPlayerRankings - gets a 2d array of ranked players, depending on what statistic wanted
//                     (such as goals, assists etc) and the number needed. Returns the data
//                     as a 2d array, giving the player name, id, regionCode, statistic and team
//                     name.
// isPlayerInFavourites - returns a boolean value depending on whether the player with the given
//                        id is stored in favourites in CoreData memory.
// savePlayerToFavourites - given a player id, regionCode and name, saves it to favourites in
//                          CoreData memory.
// removePlayerFromFavourites - given a plauyer id, removes the player from favourites in 
//                              CoreData memory.
// getPlayersFromFavourites - returns all the players saved in favourites in CoreData memoory as
//                            a 2d array, with each player having an id, name and regionCode.
// reloadPlayerData - gets the entire list of player from the API sorted by current rating,
//                    and stores each one in CoreData memory.
// getPlayerData - returns a 2d array of every player stored in CoreData memory. 
//

import Foundation
import Kanna
import SwiftyJSON
import CoreData
import Alamofire

let hostUrl = "http://192.168.1.3:5000"
//let hostUrl = "http://2.98.100.175"

func getDataFromAPI(PlayerId: String? = nil, SortValue: String? = nil, NumberToGet: String? = nil) -> JSON {
    var url = ""
    if PlayerId != nil {
        url = hostUrl + "/getPlayer?PlayerId=" + PlayerId!
    }
    else {
        url = hostUrl + "/getPlayers?SortValue=" + SortValue! + "&NumberToGet=" + NumberToGet!
    }
    
    do {
        let response = try NSData(contentsOf: NSURL(string: url) as! URL, options: NSData.ReadingOptions())
        let data = JSON(data: response as Data)
        return data
    } catch {
        print(error)
        let data: JSON = [:]
        return data
    }
}

func getPlayerRankings(SortValue: String, NumberToGet: String) -> [[String]] {
    var returnData: [[String]] = [[String]]()
    
    let players = getDataFromAPI(SortValue: SortValue, NumberToGet: NumberToGet)
    
    for (key,player):(String, JSON) in players {
        returnData.append([player["PlayerId"].rawString()!, player["Name"].rawString()!, player["RegionCode"].rawString()!, player[SortValue].rawString()!, player["Team"].rawString()!])
    }
    
    return returnData
}






