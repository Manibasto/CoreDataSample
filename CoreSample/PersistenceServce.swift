//
//  PersistenceServce.swift
//  CoreSample
//
//  Created by Anil Kumar on 17/08/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation
import CoreData

final class PersistenceServce  {
  
  init() {}
  
  static let shared = PersistenceServce()
  
  lazy var context = persistentContainer.viewContext
  
  // MARK: - Core Data stack
  var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "CoreSample")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  // MARK: - Core Data Saving support
  func saveContext () {
    if context.hasChanges {
      do {
        try context.save()
        print("CoreData Saved")
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  // MARK: - Core Data Fetch support
  func fetch<T: NSManagedObject>(_ ObjectType: T.Type)-> [T] {
    let entityName = String(describing: ObjectType)
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    do {
      let fetchObject = try context.fetch(fetchRequest) as? [T]
      return fetchObject ?? [T]()
    }catch {
      return [T]()
    }
  }
}
