import Foundation
import Kanna
import SwiftyJSON
import CoreData

// Gets data from Whoscored.com, for the type specified, which can be for Player, Team, or Player/Team
// Rankings. The parameters are the ones used in the HTTP request, and the Model-Last-Mode key is
// Not needed unless it is the first time the data is being called for a player. It returns the data,
// The Model-Last-Mode key, and some data which is taken from the HTML and not available from the API.

func getDataFromUrl(_ Type: String, Parameters: [String: String], modelLastMode : String) -> NSString {
    
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
        
        // Get the cookies for the url, and create a HTTP request.
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
                var positions : String = "\"positions\" : ["
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
                                        htmlData = (htmlData as String) + ", \"nationality\" : \"" + nationality + "\"}, "
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
                                positions = positions + "]"
                            }
                        }
                    }
                }
                // Add all the html data together.
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
    return data as NSString
    
}

// Checks whether player with given id is saved in favourites.
func isPlayerInFavourites(_ playerId: String) -> Bool {
    // Set up data container.
    let container = NSPersistentContainer(name: "playerFavouritesDataModel")
    container.loadPersistentStores { storeDescription, error in
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        if let error = error {
            print("Unable to load playerFavouritesDataModel. Error: \(error)")
        }
    }
    
    // Create a fetch request.
    var players = [PlayerFavouritesData]()
    let request = PlayerFavouritesData.createFetchRequest()
    request.predicate = NSPredicate(format: String("playerId == '" + playerId + "'"))
    
    // Get all players with matching id.
    do {
        players = try container.viewContext.fetch(request)
        // If there are no matches, return false, else return true.
        if players.count == 0 {
            return false
        }
        else {
            return true
        }
    } catch {
        print("Unable to access playerFavouritesDataModel.")
    }
    
    return false
}

// Adds a player to favourites.
func savePlayerToFavourites(_ playerData: [String: String]) {
    // Set up data container.
    let container = NSPersistentContainer(name: "playerFavouritesDataModel")
    container.loadPersistentStores { storeDescription, error in
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        if let error = error {
            print("Unable to load playerFavouritesDataModel. Error: \(error)")
        }
    }
    
    // Creates a player model with the correct data.
    let player = PlayerFavouritesData(context: container.viewContext)
    player.playerId = playerData["playerId"]
    player.name = playerData["name"]
    player.regionCode = playerData["regionCode"]
    
    // Saves the player to playerFavouritesDataModel.
    do {
        try container.viewContext.save()
    } catch {
        print("An error occurred while saving to playerFavouritesDataModel: \(error)")
    }
}

// Removes a player from favourites.
func removePlayerFromFavourites(_ playerData: [String: String]) {
    // Set up data container.
    let container = NSPersistentContainer(name: "playerFavouritesDataModel")
    container.loadPersistentStores { storeDescription, error in
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        if let error = error {
            print("Unable to load playerFavouritesDataModel. Error: \(error)")
        }
    }
    
    // Get the player to delete from the model.
    var players = [PlayerFavouritesData]()
    let request = PlayerFavouritesData.createFetchRequest()
    request.predicate = NSPredicate(format: String("playerId == '" + playerData["playerId"]! + "'"))
    
    do {
        players = try container.viewContext.fetch(request)
        if players.count == 0 {
            print("Unable to delete player as not found in playerFavouritesDataModel.")
        }
        else {
            // Delete player.
            let player = players[0]
            container.viewContext.delete(player)
        }
    } catch {
        print("Unable to access playerFavouritesDataModel.")
    }
    
    // Save changes to playerFavouritesDataModel.
    do {
        try container.viewContext.save()
    } catch {
        print("An error occurred while saving to playerFavouritesDataModel: \(error)")
    }
}

// Returns all the player saved in favourites.
func getPlayersFromFavourites() -> [[String]] {
    // Set up data container.
    let container = NSPersistentContainer(name: "playerFavouritesDataModel")
    container.loadPersistentStores { storeDescription, error in
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        if let error = error {
            print("Unable to load playerFavouritesDataModel. \(error)")
        }
    }
    
    // Set up players array.
    var playerData = [[String]]()
    var players = [PlayerFavouritesData]()
    let request = PlayerFavouritesData.createFetchRequest()
    
    do {
        players = try container.viewContext.fetch(request)
        print(players.count)
    } catch {
        print("Unable to access playerFavouritesDataModel.")
    }
    
    // Add each player to the array and return it.
    for player in players {
        playerData.append([player.playerId!, player.name!, player.regionCode!])
    }
    
    return playerData
}

// Get all player statistics.
func reloadPlayerData() {
    
    let container = NSPersistentContainer(name: "playerDataModel")
    
    container.loadPersistentStores { storeDescription, error in
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        if let error = error {
            print("Unable to load playerDataModel. \(error)")
        }
    }

    // Get data.
    let parameters = [
        "category" : "summary",
        "subcategory" : "all",
        "statsAccumulationType" : "0",
        "isCurrent" : "true",
        "playerId" : "",
        "teamIds" : "",
        "matchId" : "",
        "stageId" : "",
        "tournamentOptions" : "2,3,4,5,22",
        "sortBy": "rating",
        "sortAscending" : "false",
        "age" : "",
        "ageComparisonType" : "",
        "appearances" : "",
        "appearancesComparisonType" : "",
        "field" : "Overall",
        "nationality" : "",
        "positionOptions" : "",
        "timeOfTheGameEnd" : "",
        "timeOfTheGameStart" : "",
        "isMinApp" : "false",
        "page" : "",
        "includeZeroValues" : "",
        "numberOfPlayersToPick" : "2127" ]
    
    // Get the data from the url, and create a JSON object to parse it. No modelLastMode is needed as
    // This is the first time the data is being called.
    let data = getDataFromUrl("Player Ranking", Parameters: parameters, modelLastMode: "") as String
    var json : JSON!
    
    if let dataFromString = data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
        json = JSON(data: dataFromString)
    }
    
    for (_, playerJson):(String, JSON) in json["playerTableStats"] {
            let player = PlayerData(context: container.viewContext)
            player.playerId = String(describing: playerJson["playerId"])
            player.name = String(describing: playerJson["name"])
            player.regionCode = String(describing: playerJson["regionCode"])
            player.currentRating = String(describing: playerJson["rating"])
        }
    
    // Save changes to playerDataModel.
    do {
        try container.viewContext.save()
    } catch {
        print("An error occurred while saving to playerDataModel: \(error)")
    }
}

func getPlayerData() -> [[String]] {
    
    // Set up data container.
    let container = NSPersistentContainer(name: "playerDataModel")
    container.loadPersistentStores { storeDescription, error in
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        if let error = error {
            print("Unable to load playerDataModel. \(error)")
        }
    }
    
    // Set up players array.
    var playerData = [[String]]()
    var players = [PlayerData]()
    let request = PlayerData.createFetchRequest()
    
    do {
        players = try container.viewContext.fetch(request)
        print(players.count)
    } catch {
        print("Unable to access playerFavouritesDataModel.")
    }
    
    // Add each player to the array and return it.
    for player in players {
        playerData.append([player.playerId!, player.name!, player.regionCode!])
    }
    
    return playerData
    
}

func getHistoricRating(playerId: String) -> String {
    
    // Get data.
    let parameters = [
        "category" : "summary",
        "subcategory" : "all",
        "statsAccumulationType" : "0",
        "isCurrent" : "false",
        "playerId" : playerId,
        "teamIds" : "",
        "matchId" : "",
        "stageId" : "",
        "tournamentOptions" : "2,3,4,5,22",
        "sortBy": "seasonId",
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
        "isMinApp" : "false",
        "page" : "",
        "includeZeroValues" : "true",
        "numberOfPlayersToPick" : "" ]
    
    // Get the data from the url, and create a JSON object to parse it. No modelLastMode is needed as
    // This is the first time the data is being called.
    let data = getDataFromUrl("Player", Parameters: parameters, modelLastMode: "") as String
    var json : JSON!
    
    if let dataFromString = data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
        json = JSON(data: dataFromString)
    }
    
    var totalMatchesPlayed: Float = 0.0
    var currentTotal: Float = 0.0
    
    for (_, season):(String, JSON) in json["playerTableStats"] {
        currentTotal += (Float(String(describing: season["rating"]))! * Float(String(describing: season["apps"]))!)
        totalMatchesPlayed += Float(String(describing: season["apps"]))!
    }
    
    return String(Float(currentTotal / totalMatchesPlayed))
}

func getHistoricPlayerData() {
    
    // Set up data container.
    let container = NSPersistentContainer(name: "playerDataModel")
    container.loadPersistentStores { storeDescription, error in
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        if let error = error {
            print("Unable to load playerDataModel. \(error)")
        }
    }
    
    // Set up players array.
    var playerData = [[String]]()
    var players = [PlayerData]()
    let request = PlayerData.createFetchRequest()
    let sort = NSSortDescriptor(key: "currentRating", ascending: false)
    request.sortDescriptors = [sort]
    
    do {
        players = try container.viewContext.fetch(request)
        print(players.count)
    } catch {
        print("Unable to access playerFavouritesDataModel.")
    }
    
    // Add each player to the array and return it.
    for player in players {
        print(player.name)
        print(getHistoricRating(playerId: player.playerId!))
    }

    
    
    
}


