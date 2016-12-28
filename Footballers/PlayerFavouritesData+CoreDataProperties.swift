import Foundation
import CoreData


extension PlayerFavouritesData {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<PlayerFavouritesData> {
        return NSFetchRequest<PlayerFavouritesData>(entityName: "PlayerFavouritesData");
    }
    
    // Declare the attributes for each player in Favourites.
    @NSManaged public var playerId: String?
    @NSManaged public var name: String?
    @NSManaged public var regionCode: String?
    @NSManaged public var team: String?
    @NSManaged public var photoUrl: String?

}
