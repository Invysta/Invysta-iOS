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
