//
//  IdentifierSourceManager.swift
//  Invysta
//
//  Created by Cyril Garcia on 5/21/21.
//

import Foundation
import CoreData

final class IdentifierSourceManager {
    
    private let coreDataManager: PersistenceManager = PersistenceManager.shared
    
    func save(identifier: String, with key: String) {
        let id = Identifiers(context: coreDataManager.context)
        id.key = key
        id.value = identifier
        coreDataManager.save()
    }
    
}
