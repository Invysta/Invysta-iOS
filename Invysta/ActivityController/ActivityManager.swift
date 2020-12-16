//
//  ActivityManager.swift
//  Invysta
//
//  Created by Cyril Garcia on 12/15/20.
//

import Foundation
import CoreData

final class ActivityManager {
    let persistenceManager: PersistenceManager
    
    init(_ persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
    }
    
    func saveResults(activity: Activity) {
        persistenceManager.save()
    }
    
}

//public class Activity: NSManagedObject {
//
//}
//
//extension Activity {
//
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
//        return NSFetchRequest<Activity>(entityName: "Activity")
//    }
//
//    @NSManaged public var date: Date
//    @NSManaged public var success: Bool
//    @NSManaged public var website: URL
//
//}
