import Foundation
import Kanna
import SwiftyJSON

// Gets data from Whoscored.com, for the type specified, which can be for Player, Team, or Player/Team
// Rankings. The parameters are the ones used in the HTTP request, and the Model-Last-Mode key is
// Not needed unless it is the first time the data is being called for a player. It returns the data,
// The Model-Last-Mode key, and some data which is taken from the HTML and not available from the API.

func getDataFromUrl(_ Type: String, Parameters: [String: String], modelLastMode : String) -> NSString {
    
    // Initialise variables.
    var key: String = ""
    var htmlUrl: String = ""
    var apiUrl: String = ""
    var htmlData: String = ""
    var data: String = ""
    
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
        print("Error in data type.")
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
                
                var imageUrl: String!
                for img in doc.css("img") {
                    if img["class"] == "team-emblem" {
                        imageUrl = img["src"]
                    }
                }
                
                htmlData = (htmlData as String) + ", \"htmlData\" : {\"teamImageUrl\" : \"" + imageUrl + "\""
                
                // Positions have their own JSON object as they are an array.
                var positions : String = "\"positions\" : ["
                for dl in doc.css("dl") {
                    if dl["class"] == "player-info-block" {
                        for dt in dl.css("dt") {
                            if dt.text == "Current Team:" {
                                for a in dl.css("a") {
                                    htmlData = (htmlData as String) + ", \"teamName\" : \"" + a.text! + "\""
                                }
                            }
                            else if dt.text == "Shirt Number:" {
                                for dd in dl.css("dd") {
                                    htmlData = (htmlData as String) + ", \"shirtNumber\" : \"" + dd.text! + "\""
                                }
                            }
                            else if dt.text == "Nationality:" {
                                for span in dl.css("span") {
                                    if span.text != "" {
                                        
                                        let nationality = span.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                                        
                                        htmlData = (htmlData as String) + ", \"nationality\" : \"" + nationality + "\"}, "
                                    }
                                }
                            }
                                
                            else if dt.text == "Positions:" {         
                                for li in dl.css("li") {
                                    positions = positions + "\"" + li.text! + "\", "
                                }
                                
                                // Remove last two characters of string to parse it correctly into JSON.
                                positions = positions.substring(to: positions.index(before: positions.endIndex))
                                positions = positions.substring(to: positions.index(before: positions.endIndex))
                                positions = positions + "]"
                            }
                        }
                    }
                }
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
        
    // Add the Model-Last-Mode key to the data.
    data = data.substring(to: data.characters.index(before: data.endIndex))
    data = data.substring(to: data.characters.index(before: data.endIndex))
    data = data + ", \"Model-Last-Mode\": [\"" + key + "\"]"
    
    // Add htmlData to the data.
    data = data + (htmlData as String) + "}"
    
    // Return the data and Model-Last-Mode key back to the caller of the function.
    //print(data)
    
    /*dispatch_async(dispatch_get_main_queue()){
        /*let window = UIApplication.sharedApplication().delegate?.window
        let rootViewController = window!!.rootViewController
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let setViewController = mainStoryboard.instantiateViewControllerWithIdentifier("loadingViewId")
        rootViewController?.presentViewController(setViewController, animated: true, completion: nil)*/
        
        
        let window = UIApplication.sharedApplication().delegate?.window
        let rootViewController = window!!.rootViewController
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let setViewController = mainStoryboard.instantiateViewControllerWithIdentifier("loadingViewId")
        
       // let navController = UINavigationController(rootViewController: setViewController)
        
        rootViewController?.navigationController?.presentViewController(setViewController, animated: true, completion: nil)
    }*/
    
    return data as NSString
    
}


// Checks whether player with given id is saved in favourites.
func isPlayerInFavourites(_ playerId: String) -> Bool {
    var json: JSON?
    
    // Get favourites data from file.
    let path = Bundle.main.path(forResource: "favourites", ofType: "txt")
    let text = try? NSString(contentsOfFile: path! as String, encoding: String.Encoding.utf8.rawValue)
    if let dataFromString = text!.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
        json = JSON(data: dataFromString)
    }
    
    
    for (_, player) in json!["players"] {
        if String(describing: player["playerId"]) == playerId {
            return true
        }
    }
    
    return false
}

// Adds a player to favourites.
func savePlayerToFavourites(_ playerData: [String: String]) {
    
}

// Adds a player to favourites.
func removePlayerFromFavourites(_ playerData: [String: String]) {
    
}


