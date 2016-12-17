//
//  ViewControllerFunctions.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 23/10/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import Foundation
import Kanna
import SwiftyJSON
import CoreData
import NVActivityIndicatorView

// Global colour variables.
let lightGrey: UIColor = UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 70.0/255.0, alpha: 1.0)
let darkGrey: UIColor = UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)

let green: UIColor = UIColor(red: 79.0/255.0, green: 216.0/255.0, blue: 196.0/255.0, alpha: 1.0)
let yellow: UIColor = UIColor(red: 248.0/255.0, green: 200.0/255.0, blue: 95.0/255.0, alpha: 1.0)
let red: UIColor = UIColor(red: 247.0/255.0, green: 126.0/255.0, blue: 131.0/255.0, alpha: 1.0)

// Global View Controller variable to keep track of current View Controller.
var currentPage: String = String()

// Sets up the View Controller by setting the background colour, adding a menu button and
// Setting the navigation bar colour.
func setUpView(viewController: UIViewController) {
    
    // Set background.
    viewController.view.backgroundColor = lightGrey
 
    // Set the navigation bar colour
    viewController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    viewController.navigationController?.navigationBar.shadowImage = UIImage()
    
    let navBar = navigationBar(frame: CGRect(x: -1, y: 0, width: viewController.view.frame.width + 1, height: 64))
    viewController.view.addSubview(navBar)
}

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
    
    UIView.animate(withDuration: 1.0, animations: {
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




