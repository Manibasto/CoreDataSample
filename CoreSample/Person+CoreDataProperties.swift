//
//  Person+CoreDataProperties.swift
//  CoreSample
//
//  Created by Anil Kumar on 17/08/19.
//  Copyright © 2019 AIT. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var values: [NSNumber]  //[Double] also works
    @NSManaged public var imagedata: Data

  

}
