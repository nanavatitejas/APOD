//
//  Favorite+CoreDataProperties.swift
//  APOD
//
//  Created by Tejas Nanavati on 17/01/23.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var date: String?
    @NSManaged public var explanation: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var hdurl: String?

}

extension Favorite : Identifiable {

}
