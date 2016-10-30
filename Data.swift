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

// Global cookies variable needed for each HTTP request and generated in loadingView.
var cookies: [HTTPCookie] = [HTTPCookie]()

// Set global variable for HTTP request parameters
let globalParameters = [
    "category" : "summary",
    "subcategory" : "all",
    "statsAccumulationType" : "0",
    "isCurrent" : "true",
    "playerId" : "",
    "teamIds" : "",
    "matchId" : "",
    "stageId" : "",
    "tournamentOptions" : "2,3,4,5,22",
    "sortBy": "",
    "sortAscending" : "",
    "age" : "",
    "ageComparisonType" : "",
    "appearances" : "",
    "appearancesComparisonType" : "",
    "field" : "Overall",
    "nationality" : "",
    "positionOptions" : "",
    "timeOfTheGameEnd" : "",
    "timeOfTheGameStart" : "",
    "isMinApp" : "",
    "page" : "",
    "includeZeroValues" : "",
    "numberOfPlayersToPick" : "" ]

// Gets data from Whoscored.com, for the type specified, which can be for Player, Team, or Player/Team
// Rankings. The parameters are the ones used in the HTTP request, and the Model-Last-Mode key is
// Not needed unless it is the first time the data is being called for a player. It returns the data,
// The Model-Last-Mode key, and some data which is taken from the HTML and not available from the API.

func getDataFromUrl(_ Type: String, Parameters: [String: String], modelLastMode : String) -> JSON {
    
    // Initialise variables.
    // modelLastMode if it hasn't been already passed to the function.
    var key: String = ""
    // Url to load the webpage from.
    var htmlUrl: String = ""
    // Url to load the json data from the API.
    var apiUrl: String = ""
    // Data which is obtained through the webpage.
    var htmlData: String = ""
    // Data to be returned at the end of the function.
    var data: String = ""
    
    // Switch type depending on what type of data is desired.
    switch Type {
    case "Player":
        htmlUrl = "https://www.whoscored.com/Players/" + Parameters["playerId"]!
        apiUrl = "https://www.whoscored.com/StatisticsFeed/1/GetPlayerStatistics?"
    case "Team":
        htmlUrl = "https://www.whoscored.com/Teams/" + Parameters["teamIds"]!
        apiUrl = "https://www.whoscored.com/StatisticsFeed/1/GetTeamStatistics?"
    case "Player Ranking":
        htmlUrl = "https://www.whoscored.com/Statistics"
        apiUrl = "https://www.whoscored.com/StatisticsFeed/1/GetPlayerStatistics?"
    case "Team Ranking":
        htmlUrl = "https://www.whoscored.com/Statistics"
        apiUrl = "https://www.whoscored.com/StatisticsFeed/1/GetTeamStatistics?"
    default:
        print("Incorrect value passed to Data function for statistics type.")
    }
    
    // If the Model-Last-Mode key is empty, get it by loading the page.
    if modelLastMode == "" {
        
        // Get the cookies for the url, and create an HTTP request.
        let url = URL(string: htmlUrl)
        let jar = HTTPCookieStorage.shared
        jar.setCookies(cookies, for: url, mainDocumentURL: url)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        
        // Add header values as if it was being accessed from the browser.
        request.addValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField: "Accept")
        request.addValue("Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13E230", forHTTPHeaderField: "User-Agent")
        
        let response: AutoreleasingUnsafeMutablePointer<URLResponse?>?=nil
        do {
            let dataResponse = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: response)
            // Save the data as an NSString object, which will be converted to JSON by the process
            // which is calling this function.
            let html = NSString(data: dataResponse, encoding:String.Encoding.utf8.rawValue)!
            
            // Parses the Model-Last-Mode key from the original html source code.
            var splitHtml = html.components(separatedBy: "Model-Last-Mode")
            splitHtml[1] = splitHtml[1].replacingOccurrences(of: "': '", with: "", range: nil)
            let list = splitHtml[1].components(separatedBy: "'")
            key = list[0]
            
            // Get the HTML data, which includes current team, shirt number, nationality and positions. This data isn't 
            // Available from the API so must be taken from the HTML.
            if let doc = Kanna.HTML(html: html as String, encoding: String.Encoding.utf8) {
                
                // Get the club crest image url.
                var imageUrl: String!
                for img in doc.css("img") {
                    if img["class"] == "team-emblem" {
                        imageUrl = img["src"]
                    }
                }
                
                // Create the first part of htmlData.
                htmlData = (htmlData as String) + ", \"htmlData\" : {\"teamImageUrl\" : \"" + imageUrl + "\""
                
                // Positions have their own JSON object as they are an array.
                var positions : String = "}, \"positions\" : ["
                for dl in doc.css("dl") {
                    if dl["class"] == "player-info-block" {
                        for dt in dl.css("dt") {
                            // Get the player's current team.
                            if dt.text == "Current Team:" {
                                for a in dl.css("a") {
                                    htmlData = (htmlData as String) + ", \"teamName\" : \"" + a.text! + "\""
                                }
                            }
                                // Get the player's shirt number.
                            else if dt.text == "Shirt Number:" {
                                for dd in dl.css("dd") {
                                    htmlData = (htmlData as String) + ", \"shirtNumber\" : \"" + dd.text! + "\""
                                }
                            }
                                // Get the player's nationality; the actual country name and not the region code.
                            else if dt.text == "Nationality:" {
                                for span in dl.css("span") {
                                    if span.text != "" {
                                    
                                        // Remove any whitespace surrounding the text.
                                        let nationality = span.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                                        htmlData = (htmlData as String) + ", \"nationality\" : \"" + nationality + "\""
                                    }
                                }
                            }
                                // Get a list of all the player's positions.
                            else if dt.text == "Positions:" {
                                for li in dl.css("li") {
                                    positions = positions + "\"" + li.text! + "\", "
                                }
                                
                                // Remove last two characters of string to parse it correctly into json.
                                positions = positions.substring(to: positions.index(before: positions.endIndex))
                                positions = positions.substring(to: positions.index(before: positions.endIndex))
                            }
                        }
                    }
                }
                // Add all the html data together.
                positions = positions + "]"
                htmlData = (htmlData as String) + positions
            }
        }
            // Catch any errors in getting the data.
        catch let error as NSError {
            print(error)
        }
    }
    // The Model-Last-Mode has been passed to the function already.
    else {
        key = modelLastMode
    }
    
    // Create the API url with the correct parameters.
    for (key, value) in Parameters {
        apiUrl = apiUrl + key + "=" + value + "&"
    }
    apiUrl = String(apiUrl.characters.dropLast())
    
    // Get the cookies for the url, and create a HTTP request.
    let url = URL(string: apiUrl)
    let jar = HTTPCookieStorage.shared
    jar.setCookies(cookies, for: url, mainDocumentURL: url)
    let request = NSMutableURLRequest(url: url!)
    
    // Add header values as if it was being accessed from the browser.
    request.addValue("application/json, text/javascript, */*; q=0.01", forHTTPHeaderField: "accept")
    request.addValue("gzip, deflate, sdch, br", forHTTPHeaderField: "accept-encoding")
    request.addValue("en-US,en;q=0.8", forHTTPHeaderField: "accept-language")
    request.addValue("no-cache", forHTTPHeaderField: "cache-control")
    request.addValue(key, forHTTPHeaderField: "model-last-mode")
    request.addValue("no-cache", forHTTPHeaderField: "pragma")
    request.addValue(htmlUrl, forHTTPHeaderField: "referer")
    request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.106 Safari/537.36", forHTTPHeaderField: "user-agent")
    request.addValue("XMLHttpRequest", forHTTPHeaderField: "x-requested-with")
    request.httpMethod = "GET"
    
    let response: AutoreleasingUnsafeMutablePointer<URLResponse?>?=nil
    do {
        let dataResponse = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: response)
        // Save the data as an NSString object, which will be converted to JSON by the process
        // which is calling this function.
        data = NSString(data: dataResponse, encoding:String.Encoding.utf8.rawValue)! as String}
        // Catch any errors in getting the data.
    catch let error as NSError {
        print(error)
    }
    
    if Type == "Player" {
        // Add the Model-Last-Mode key to the data.
        data = data.substring(to: data.characters.index(before: data.endIndex))
        data = data.substring(to: data.characters.index(before: data.endIndex))
        data = data + ", \"Model-Last-Mode\": [\"" + key + "\"]"
    
        // Add htmlData to the data.
        data = data + (htmlData as String) + "}"
    }
    
    // Return the data and Model-Last-Mode key back to the caller of the function.
    var json: JSON!
    
    if let dataFromString = data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
        json = JSON(data: dataFromString)
    }
    
    return json
}



func updatePlayerDatabase() {
    
    let container = NSPersistentContainer(name: "playerDataModel")
    container.loadPersistentStores { storeDescription, error in
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        if let error = error {
            print("Unable to load playerDataModel. \(error)")
        }
    }
    
    var parameters = globalParameters
    parameters["sortBy"] = "Rating"
    parameters["numberOfPlayersToPick"] = "2177"
    parameters["isMinApp"] = "false"
    
    let data = getDataFromUrl("Player Ranking", Parameters: parameters, modelLastMode: "")
    parameters["numberOfPlayersToPick"] = String(describing: data["paging"]["totalResults"])
    
    parameters["subcategory"] = "all"
    let overallData = getDataFromUrl("Player Ranking", Parameters: parameters, modelLastMode: "")
    
    parameters["subcategory"] = "offensive"
    let attackingData = getDataFromUrl("Player Ranking", Parameters: parameters, modelLastMode: "")
    
    parameters["subcategory"] = "defensive"
    let defendingData = getDataFromUrl("Player Ranking", Parameters: parameters, modelLastMode: "")
    
    parameters["subcategory"] = "passing"
    let passingData = getDataFromUrl("Player Ranking", Parameters: parameters, modelLastMode: "")
    
    let overall = overallData["playerTableStats"].array
    let attacking = attackingData["playerTableStats"].array
    let defending = defendingData["playerTableStats"].array
    let passing = passingData["playerTableStats"].array
    
    for (playerOverall, (playerAttacking, (playerDefending, playerPassing))) in zip(overall!, zip(attacking!, zip(defending!, passing!))) {
        let player = PlayerData(context: container.viewContext)
        
        player.aerialWonPerGame = Float(String(describing: playerOverall["aerialWonPerGame"])) as NSNumber?
        player.apps = Int(String(describing: playerOverall["apps"])) as NSNumber?
        player.assistTotal = Int(String(describing: playerOverall["assistTotal"])) as NSNumber?
        player.crossesPerGame = Float(String(describing: playerPassing["accurateCrossesPerGame"])) as NSNumber?
        player.clearancePerGame = Float(String(describing: playerDefending["clearancePerGame"])) as NSNumber?
        player.dribbleWonPerGame = Float(String(describing: playerAttacking["dribbleWonPerGame"])) as NSNumber?
        player.foulsPerGame = Float(String(describing: playerDefending["foulsPerGame"])) as NSNumber?
        player.goal = Int(String(describing: playerOverall["goal"])) as NSNumber?
        player.interceptionPerGame = Float(String(describing: playerDefending["interceptionPerGame"])) as NSNumber?
        player.keyPassPerGame = Float(String(describing: playerPassing["keyPassPerGame"])) as NSNumber?
        player.name = String(describing: playerOverall["name"])
        player.outfielderBlockPerGame = Float(String(describing: playerDefending["outfielderBlockPerGame"])) as NSNumber?
        player.passSuccess = Float(String(describing: playerOverall["passSuccess"])) as NSNumber?
        player.playerId = String(describing: playerOverall["playerId"])
        player.positions = String(describing: playerOverall["playedPositionsShort"])
        player.rating = Float(String(describing: playerOverall["rating"])) as NSNumber?
        player.redCard = Int(String(describing: playerOverall["redCard"])) as NSNumber?
        player.regionCode = String(describing: playerOverall["regionCode"])
        player.shotsPerGame = Float(String(describing: playerAttacking["shotsPerGame"])) as NSNumber?
        player.tacklePerGame = Float(String(describing: playerDefending["tacklePerGame"])) as NSNumber?
        player.teamId = String(describing: playerOverall["teamId"]) as String?
        player.teamName = String(describing: playerOverall["teamName"]) as String?
        player.totalPassesPerGame = Float(String(describing: playerPassing["totalPassesPerGame"])) as NSNumber?
        player.yellowCard = Int(String(describing: playerOverall["yellowCard"])) as NSNumber?
        
        player.attackingRating = generateAttackingRating(goals: player.goal as! Int, assists: player.assistTotal as! Int, dribbles: player.dribbleWonPerGame as! Float, shotsPerGame: player.shotsPerGame as! Float, keyPasses: player.keyPassPerGame as! Float, apps: player.apps as! Int, rating: player.rating as! Float) as NSNumber?
        player.defendingRating = generateDefendingRating(tackles: player.tacklePerGame as! Float, interceptions: player.interceptionPerGame as! Float, clearances: player.clearancePerGame as! Float, blocks: player.outfielderBlockPerGame as! Float, passesPerGame: player.totalPassesPerGame as! Float, passSuccess: player.passSuccess as Float!, rating: player.rating as! Float, positions: player.positions! as String) as NSNumber?
        player.passingRating = generatePassingRating(assists: player.assistTotal as! Int, keyPasses: player.keyPassPerGame as! Float, passesPerGame: player.totalPassesPerGame as! Float, passSuccess: player.passSuccess as! Float, crosses: player.crossesPerGame as! Float, apps: player.apps as! Int, rating: player.rating as! Float) as NSNumber?
        player.disciplineRating = generateDisciplineRating(fouls: player.foulsPerGame as! Float, yellowCards: player.yellowCard as! Int, redCards: player.redCard as! Int, apps: player.apps as! Int, rating: player.rating as! Float) as NSNumber?
    }
    
    // Save changes to playerDataModel.
    do {
        try container.viewContext.save()
    } catch {
        print("An error occurred while saving to playerDataModel: \(error)")
    }
}

// Gets player rankings from the API depending on what type of ranking and number of players.
func getPlayerRankings(type: String, numberToGet: Int) -> [[String]] {
    
    // Set up a variable to store the players in.
    var players: [[String]] = [[String]]()
    
    // Set up data container.
    let container = NSPersistentContainer(name: "playerDataModel")
    container.loadPersistentStores { storeDescription, error in
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        if let error = error {
            print("Unable to load playerDataModel. \(error)")
        }
    }
    
    // Set up players array.
    var playerData = [PlayerData]()
    let request = PlayerData.createFetchRequest()
    let sort = NSSortDescriptor(key: type, ascending: false)
    request.sortDescriptors = [sort]
    
    // Set minimum amount of appearances.
    request.predicate = NSPredicate(format: String("apps > '5'"))
    
    do {
        playerData = try container.viewContext.fetch(request)
    } catch {
        print("Unable to access playerFavouritesDataModel.")
    }
    
    // Add each player to the array and return it.
    for i in 0..<numberToGet {
        players.append([playerData[i].playerId!, playerData[i].name!, playerData[i].regionCode!, String(describing: playerData[i].value(forKey: type)!), playerData[i].teamName!])
    }
    
    return players
}



func generateAttackingRating(goals: Int, assists: Int, dribbles: Float, shotsPerGame: Float, keyPasses: Float, apps: Int, rating: Float) -> Float {
    let goalsPerGame = Float(goals/apps)
    let assistsPerGame = Float(assists/apps)
    
    return ((goalsPerGame*3 + dribbles*2 + assistsPerGame + keyPasses + shotsPerGame*3) * rating)
}

func generateDefendingRating(tackles: Float, interceptions: Float, clearances: Float, blocks: Float, passesPerGame: Float, passSuccess: Float, rating: Float, positions: String) -> Float {
    var multiplier: Float = 1.0
    if String(positions.characters.prefix(2)) == "D(" {
        multiplier = 2.0
    }
    
    let passing = passSuccess*3 + passesPerGame*2
    let defending = tackles*3 + blocks*2 + clearances*3 + interceptions
    
    return ((defending + passing) * rating * multiplier)
}

func generatePassingRating(assists: Int, keyPasses: Float, passesPerGame: Float, passSuccess: Float, crosses: Float, apps: Int,  rating: Float) -> Float {
    let assistsPerGame = Float(assists/apps)
    return ((assistsPerGame*15 + keyPasses + crosses*1.5 + (passesPerGame + passSuccess)/25) * rating)
}

func generateDisciplineRating(fouls: Float, yellowCards: Int, redCards: Int, apps: Int, rating: Float) -> Float {
    let yellowCardsPerGame = Float(yellowCards/apps)
    let redCardsPerGame = Float(redCards/apps)
    return (rating/(redCardsPerGame*5 + yellowCardsPerGame + fouls + 1))
}

func returnPlayerRatings(id: String) -> [Float] {
    let topAttacking = getPlayerRankings(type: "attackingRating", numberToGet: 1)
    let topDefending = getPlayerRankings(type: "defendingRating", numberToGet: 1)
    let topPassing = getPlayerRankings(type: "passingRating", numberToGet: 1)
    let topDiscipline = getPlayerRankings(type: "disciplineRating", numberToGet: 1)
    
    // Set up a variable to store the players in.
    //var player: [String] = [String]()
    
    // Set up data container.
    let container = NSPersistentContainer(name: "playerDataModel")
    container.loadPersistentStores { storeDescription, error in
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        if let error = error {
            print("Unable to load playerDataModel. \(error)")
        }
    }
    
    // Set up players array.
    var playerData = [PlayerData]()
    let request = PlayerData.createFetchRequest()
    
    // Set minimum amount of appearances.
    request.predicate = NSPredicate(format: String("playerId == '" + id + "'"))
    
    do {
        playerData = try container.viewContext.fetch(request)
    } catch {
        print("Unable to access playerFavouritesDataModel.")
    }
    
    let player = playerData[0]
    
    let attackingRating = Float((Float(player.attackingRating!)/Float(topAttacking[0][3])!)*100)
    let defendingRating = Float((Float(player.defendingRating!)/Float(topDefending[0][3])!)*100)
    let passingRating = Float((Float(player.passingRating!)/Float(topPassing[0][3])!)*100)
    let disciplineRating = Float((Float(player.disciplineRating!)/Float(topDiscipline[0][3])!)*100)
    
    return([attackingRating, defendingRating, passingRating, disciplineRating])
}






