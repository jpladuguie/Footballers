import Foundation
import NVActivityIndicatorView

/* Global variable declarations */

// Global colour variables.
let lightGrey: UIColor = UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 70.0/255.0, alpha: 1.0)
let darkGrey: UIColor = UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)

let green: UIColor = UIColor(red: 79.0/255.0, green: 216.0/255.0, blue: 196.0/255.0, alpha: 1.0)
let yellow: UIColor = UIColor(red: 248.0/255.0, green: 200.0/255.0, blue: 95.0/255.0, alpha: 1.0)
let red: UIColor = UIColor(red: 247.0/255.0, green: 126.0/255.0, blue: 131.0/255.0, alpha: 1.0)

// Set the host url depending on whether the device is on the same network as the server.
//let hostUrl = "http://192.168.1.13:5000"
let hostUrl = "http://91.134.242.17:5000"

// Keeps track of the text inputed into the search bar to pass between seperate view controllers.
var currentSearchText: String = ""
var currentSearchedPlayers: [[String: String]] = [[String: String]]()

// Global View Controller variable to keep track of current View Controller.
enum viewType {
    case Home
    case Rankings
    case Favourites
    case Player
}

// The different types of menu.
enum menuType {
    case Search
    case Options
}

// Different image types which are fetched from the API.
enum imageType {
    case Player
    case Team
}
