//
//  Favourites.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 30/10/2016.
//  Copyright © 2016 Jean-Pierre Laduguie. All rights reserved.
//

import Foundation
import CoreData

/* Helper functions */

// Sets up the data container for playerFavouritesDataModel and returns it.
func setUpDataContainer() -> NSPersistentContainer {
    let container = NSPersistentContainer(name: "playerFavouritesDataModel")
    container.loadPersistentStores { storeDescription, error in
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        if let error = error {
            print("Unable to load playerFavouritesDataModel. Error: \(error)")
        }
    }
    
    return container
}

// Save the player to playerFavouritesDataModel.
func saveChanges(container: NSPersistentContainer) {
    do {
        try container.viewContext.save()
    } catch {
        print("An error occurred while saving to playerFavouritesDataModel: \(error)")
    }
}

/* Favourites functions */

// Checks whether player with given id is saved in favourites.
func isPlayerInFavourites(_ playerId: String) -> Bool {
    // Set up data container.
    let container = setUpDataContainer()
    
    // Create a fetch request.
    var player = [PlayerFavouritesData]()
    let request = PlayerFavouritesData.createFetchRequest()
    
    // Set the predicate to look for players with a matching playerId.
    request.predicate = NSPredicate(format: String("playerId == '" + playerId + "'"))
    
    // Get all players with matching id.
    do {
        player = try container.viewContext.fetch(request)
        
        // If there are no matches, return false, else return true.
        if player.count == 0 {
            return false
        }
        else {
            return true
        }
    } catch {
        print("Unable to access playerFavouritesDataModel.")
    }
    
    // Return false if an error occured.
    return false
}

// Adds a player to favourites.
func savePlayerToFavourites(_ playerData: [String: String]) {
    // Set up data container.
    let container = setUpDataContainer()
    
    // Creates a player model to save the data as.
    let player = PlayerFavouritesData(context: container.viewContext)
    
    // Add the attributes to the player data.
    player.playerId = playerData["PlayerId"]
    player.name = playerData["Name"]
    player.regionCode = playerData["RegionCode"]
    
    // Save changes to playerFavouritesDataModel.
    saveChanges(container: container)
}

// Removes a player from favourites.
func removePlayerFromFavourites(_ playerId: String) {
    // Set up data container.
    let container = setUpDataContainer()
    
    // Get the player to delete from the model.
    var player = [PlayerFavouritesData]()
    let request = PlayerFavouritesData.createFetchRequest()
    
    // Set up a predicate to look for a player with a matching playerId.
    request.predicate = NSPredicate(format: String("playerId == '" + playerId + "'"))
    
    // Find all players with a matching id.
    do {
        player = try container.viewContext.fetch(request)
        // If no players found.
        if player.count == 0 {
            print("Unable to delete player as not found in playerFavouritesDataModel.")
        }
        else {
            // Delete player.
            let player = player[0]
            container.viewContext.delete(player)
        }
    } catch {
        print("Unable to access playerFavouritesDataModel.")
    }
    
    // Save changes to playerFavouritesDataModel.
    saveChanges(container: container)
}

// Returns all the player saved in favourites.
func getPlayersFromFavourites() -> [[String]] {
    // Set up data container.
    let container = setUpDataContainer()
    
    // Set up players variable to store the data.
    var playerData = [[String]]()
    
    // Create the request.
    var players = [PlayerFavouritesData]()
    let request = PlayerFavouritesData.createFetchRequest()
    
    // Get the players.
    do {
        players = try container.viewContext.fetch(request)
    } catch {
        print("Unable to access playerFavouritesDataModel.")
    }
    
    // Add each player to the array and return it.
    for player in players {
        playerData.append([player.playerId!, player.name!, player.regionCode!])
    }
    
    return playerData
}
