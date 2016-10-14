import Foundation
import SwiftyJSON

// A class which contains player data for when a player screen or compare screen is loaded.
// It needs the player ID to initialise, and will automatically get the summary and personal
// Details by HTTP request. Further details can be obtained by calling the other methods, and
// Once details have been received, they will be stored until the app terminates.
class Player {
    
    // Initialise variables.
    let id: String
    let imageUrl: String
    let teamImageUrl: String
    var positions = [String]()
    var personalDetails = [[String]]()
    var summaryStats = [[String]]()
    var offensiveStats = [[String]]()
    var defensiveStats = [[String]]()
    var passingStats = [[String]]()
    var parameters = [String: String]()
    var modelLastMode: String
    
    init(id: String) {
        // Set ID as well as the url for the player's image.
        self.id = id
        self.imageUrl = "https://d2zywfiolv4f83.cloudfront.net/img/players/" + id + ".jpg"
        
        // Set parameters for the data request of summary statistics.
        self.parameters = [
            "category" : "summary",
            "subcategory" : "all",
            "statsAccumulationType" : "0",
            "isCurrent" : "true",
            "playerId" : self.id,
            "teamIds" : "",
            "matchId" : "",
            "stageId" : "",
            "tournamentOptions" : "",
            "sortBy": "Rating",
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
        
        // Get the data from the url, and create a JSON object to parse it.
        let data = getDataFromUrl("Player", Parameters: self.parameters, modelLastMode: "") as String
        var json : JSON?
        
        if let dataFromString = data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                json = JSON(data: dataFromString)
            }
        
        // Set Model-Last-Mode Key
        self.modelLastMode = String(describing: json!["Model-Last-Mode"][0])
        
        // Parse the data to get the personal details. Personal details never need to be loaded
        // From url again after the player has been initialised.
        self.personalDetails.append(["Name", json!["playerTableStats"][0]["name"].rawString()!])
        self.personalDetails.append(["Team", json!["htmlData"]["teamName"].rawString()!])
        self.personalDetails.append(["Age", json!["playerTableStats"][0]["age"].rawString()!])
        self.personalDetails.append(["Height", json!["playerTableStats"][0]["height"].rawString()!])
        self.personalDetails.append(["Weight", json!["playerTableStats"][0]["weight"].rawString()!])
        self.personalDetails.append(["Region Code", json!["playerTableStats"][0]["regionCode"].rawString()!])
        self.personalDetails.append(["Nationality", json!["htmlData"]["nationality"].rawString()!])
        self.personalDetails.append(["Shirt Number", json!["htmlData"]["shirtNumber"].rawString()!])
        
        // Parse the data to get the player positions. Like personal details, positions never need to be loaded
        // From url again after the player has been initialised.
        for (_, subJson) in json!["positions"] {
            self.positions.append(subJson.rawString()!)
        }
        
        // Set team image url.
        self.teamImageUrl = json!["htmlData"]["teamImageUrl"].rawString()!
        
        // Set up summary statistic values. Like personal details, summary statistics never need to be loaded from url 
        // Again after the player has been initialised.
        self.summaryStats = getStatistics("all", titles: ["Appearances", "Minutes Played", "Goals", "Assists", "Yellow Cards", "Red Cards", "Shots per Game", "Pass Success %", "Ariels Won per Game", "Man of the Match"], valueNames: ["apps", "minsPlayed", "goal", "assistTotal", "yellowCard", "redCard", "shotsPerGame", "passSuccess", "aerialWonPerGame", "manOfTheMatch"], integerValues: [0, 1, 2, 3, 4, 5, 9], doubleValues: [6, 7, 8])
        
    }
    
    func getPersonalDetails() -> [[String]] {
        return personalDetails
    }
    
    func getSummaryStats() -> [[String]] {
        return summaryStats
    }
    
    func getOffensiveStats() -> [[String]] {
        // Check whether the data has already been loaded. If the array is empty, load the data
        // From the url. If not, just return the array as it is.
        if offensiveStats.count == 0 {
            self.offensiveStats = getStatistics("offensive", titles: ["Appearances", "Minutes Played", "Goals", "Assists", "Shots per Game", "Key Passes per Game", "Dribbles per Game", "Fouled per Game", "Offsides per Game", "Dispossessed per Game"], valueNames: ["apps", "minsPlayed", "goal", "assistTotal", "shotsPerGame", "keyPassPerGame", "dribbleWonPerGame", "foulGivenPerGame", "offsideGivenPerGame", "dispossessedPerGame"], integerValues: [0, 1, 2, 3], doubleValues: [4, 5, 6, 7, 8, 9])
            
            return offensiveStats
        }
        else {
            return offensiveStats
        }
    }
    
    func getDefensiveStats() -> [[String]] {
        // Check whether the data has already been loaded. If the array is empty, load the data
        // From the url. If not, just return the array as it is.
        if defensiveStats.count == 0 {
            self.defensiveStats = getStatistics("defensive", titles: ["Appearances", "Minutes Played", "Tackles per Game", "Interceptions per Game", "Fouls per Game", "Offsides Won per Game", "Clearances per Game", "Dribbled Past per Game", "Blocks per Game", "Own Goals"], valueNames: ["apps", "minsPlayed", "tacklePerGame", "interceptionPerGame", "foulsPerGame", "offsideWonPerGame", "clearancePerGame", "wasDribbledPerGame", "outfielderBlockPerGame", "goalOwn"], integerValues: [0, 1, 9], doubleValues: [2, 3, 4, 5, 6, 7, 8])
            return defensiveStats
        }
        else {
            return defensiveStats
        }
    }
    
    func getPassingStats() -> [[String]] {
        // Check whether the data has already been loaded. If the array is empty, load the data
        // From the url. If not, just return the array as it is.
        if passingStats.count == 0 {
            self.passingStats = getStatistics("passing", titles: ["Appearances", "Minutes Played", "Assists", "Key Passes per Game", "Passes per Game", "Pass Success %", "Crosses per Game", "Long Balls per Game", "Through Balls per Game"], valueNames: ["apps", "minsPlayed", "assistTotal", "keyPassPerGame", "totalPassesPerGame", "passSuccess", "accurateCrossesPerGame", "accurateLongPassPerGame", "accurateThroughBallPerGame"], integerValues: [0, 1, 2], doubleValues: [3, 4, 5, 6, 7, 8])
            return passingStats
        }
        else {
            return passingStats
        }
    }
    
    func getPositions() -> [String] {
        return self.positions
    }
    
    // Get statistics from url given the category (such as offensive or passing), the titles of the statistics, the
    // Values of the statistics in the JSON, and which values are integers and which are doubles.
    func getStatistics(_ subCatergory: String, titles: [String], valueNames: [String], integerValues: [Int], doubleValues: [Int]) -> [[String]] {
        
        // Set the correct category for the request.
        self.parameters["subcategory"] = subCatergory
        
        // Get the data from the url, and create a JSON object to parse it.
        let data = getDataFromUrl("Player", Parameters: self.parameters, modelLastMode: self.modelLastMode) as String
        var json : JSON?
        
        if let dataFromString = data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            json = JSON(data: dataFromString)
        }
        
        // Create the statistics variable to be returned and fill it with empty variables.
        var statistics = [[String]]()
        for title in titles {
            statistics.append([title, "0"])
        }
        
        // Parse the data to get the statistics.
        for (_, stat) in json!["playerTableStats"] {
            // Stats which have integer values and are totals.
            for int in integerValues {
                statistics[int][1] = String(Int(statistics[int][1])! + stat[valueNames[int]].int!)
            }
        }
        
        for (_, stat) in json!["playerTableStats"] {
            // Stats which are weighted averages and have double values.
            for double in doubleValues {
                //statistics[double][1] = String(round((Double(statistics[double][1])! + (stat[valueNames[double]].double! * (stat["minsPlayed"].double! / Double(statistics[1][1])!)))*10)/10)
                
                let temp = round((Double(statistics[double][1])! + (stat[valueNames[double]].double! * (stat["minsPlayed"].double! / Double(statistics[1][1])!)))*10)/10
                statistics[double][1] = String(temp)
            }
        }
        
        // Check if any incorrect values.
        for i in 0 ..< statistics.count {
            if statistics[i][1] == "nan" {
                statistics[i][1] = "0"
            }
        }
        
        return statistics
    }

}
