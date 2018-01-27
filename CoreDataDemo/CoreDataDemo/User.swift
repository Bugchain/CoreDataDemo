//
//  User.swift
//  CoreDataDemo
//
//  Created by Chainarong Chaiyaphat on 1/22/18.
//  Copyright © 2018 Chainarong Chaiyaphat. All rights reserved.
//

import Foundation

class User{
    var userName:String
    var email:String
    var profile:String
    var age:String
    
    init(userName:String, email:String, profile:String, age:String) {
        self.userName = userName
        self.email = email
        self.profile = profile
        self.age = age
    }
    
}
