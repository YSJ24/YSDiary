//
//  Item+CoreDataProperties.swift
//  Diary
//
//  Created by Yeseul Jang on 2023/09/13.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var itemTitle: String?
    @NSManaged public var itemCreatedDate: Date?
    @NSManaged public var itemBody: String?

}

extension Item : Identifiable {

}
