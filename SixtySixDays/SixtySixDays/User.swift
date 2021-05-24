//
//  User.swift
//  SixtySixDays
//
//  Created by Matheus Godinho on 7/21/15.
//  Copyright (c) 2015 SixtySixDays. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var id: Int?
    var name: String = ""
    var photoName: String = ""
    var friends = Array<NSDictionary>()
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, photoName: String) {
        self.name = name
        self.photoName = photoName
    }
}
