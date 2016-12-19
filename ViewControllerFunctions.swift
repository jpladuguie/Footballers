//
//  ViewControllerFunctions.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 23/10/2016.
//  Copyright © 2016 Jean-Pierre Laduguie. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

/* Global variable declarations */

// Global colour variables.
let lightGrey: UIColor = UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 70.0/255.0, alpha: 1.0)
let darkGrey: UIColor = UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)

let green: UIColor = UIColor(red: 79.0/255.0, green: 216.0/255.0, blue: 196.0/255.0, alpha: 1.0)
let yellow: UIColor = UIColor(red: 248.0/255.0, green: 200.0/255.0, blue: 95.0/255.0, alpha: 1.0)
let red: UIColor = UIColor(red: 247.0/255.0, green: 126.0/255.0, blue: 131.0/255.0, alpha: 1.0)

// Global View Controller variable to keep track of current View Controller.
enum viewType {
    case Home
    case Rankings
    case Favourites
}

var currentView = viewType.Home

// Set the host url depending on whether the device is on the same network as the server.
let hostUrl = "http://192.168.1.13:5000"

// Keeps track of the text inputed into the search bar to pass between seperate view controllers.
var currentSearchText: String = ""
var currentSearchedPlayers: [[String: String]] = [[String: String]]()

/* Other helper global functions */

// Create ActivityIndicator centred in the middle of the view and return it.
func configureActivityIndicator(viewController: UIViewController) -> NVActivityIndicatorView {
    let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: (viewController.view.frame.size.width/2 - 25), y: (viewController.view.frame.size.height/2 - 25), width: 50, height: 50), type: NVActivityIndicatorType.ballClipRotate, color: UIColor.white)
    activityIndicator.startAnimating()
    
    return activityIndicator
}

// Display an error message in the view, such as if connection to the server failed or there are no players to show.
func createErrorMessage(viewController: UIViewController, message: String) {
    
    // Create the error label.
    let errorLabel = UILabel(frame: CGRect(x: (viewController.view.frame.width / 2) - 150, y: (viewController.view.frame.height / 2) - 15, width: 300, height: 30))
    // Set the colour to white, add the text and add to view.
    errorLabel.font = UIFont.systemFont(ofSize: 22.0)
    errorLabel.text = message
    errorLabel.textColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
    errorLabel.textAlignment = .center
    errorLabel.alpha = 0.0
    viewController.view.addSubview(errorLabel)
    
    UIView.animate(withDuration: 0.5, animations: {
        errorLabel.alpha = 1.0
    })
}

// Return the colour red, yellow or green depending on a variable.
func getRatingColour(value: Int) -> UIColor {
    if value < 35 {
        return red
    }
    else if value >= 35 && value <= 65 {
        return yellow
    }
    else {
        return green
    }
}




