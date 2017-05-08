//
//  Store.swift
//  Metro
//
//  Created by Eduardo Valencia on 5/7/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

final class Store {
    static let shared = Store()
    var needsUpdate = false
    var station: Station?
    var direction: PickerButton.Direction?
    
    private init () {
        
    }

}
