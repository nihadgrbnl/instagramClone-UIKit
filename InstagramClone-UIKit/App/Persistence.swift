//
//  Persistence.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 11.03.26.
//

import Foundation
import CoreData

class Persistence {
    static let shared = Persistence()
    
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "InstagramClone-UIKit")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("CoreData yüklenemedi: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
}
