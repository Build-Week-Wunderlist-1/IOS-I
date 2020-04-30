//
//  CoreDataStack.swift
//  LambdaList
//
//  Created by Shawn James on 4/27/20.
//  Copyright © 2020 iOS BW. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
        
    // create singleton
    static let shared = CoreDataStack()
    
    // create container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Task")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
        // This is required for the viewContext (ie. the main context) to be updated with changes saved in a background context. In this case, the viewContext's parent is the persistent store coordinator, not another context. This will ensure that the viewContext gets the changes you made on a background context so the fetched results controller can see those changes and update the table view automatically.
        container.viewContext.automaticallyMergesChangesFromParent = true

        return container
    }()
    
    // create context -> everything done in the app uses the context
    var mainContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
}
