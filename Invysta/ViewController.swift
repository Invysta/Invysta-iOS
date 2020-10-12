//
//  ViewController.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit
import AdSupport

class ViewController: UIViewController {

    private var identifierManager: IdentifierManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        identifierManager = IdentifierManager([VendorIdentifier(), AdvertiserIdentifier()])
        print(identifierManager!.identifiers)
    }

}
