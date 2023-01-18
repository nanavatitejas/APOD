//
//  LastSeenFav+CoreDataProperties.swift
//  APOD
//
//  Created by Tejas Nanavati on 17/01/23.
//
//

import Foundation
import CoreData


extension LastSeenFav {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LastSeenFav> {
        return NSFetchRequest<LastSeenFav>(entityName: "LastSeenFav")
    }

    @NSManaged public var date: String?
    @NSManaged public var explanation: String?
    @NSManaged public var hdurl: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?

}

extension LastSeenFav : Identifiable {

}
