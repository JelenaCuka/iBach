//
//  User.swift
//  iBach
//
//  Created by Petar Jedek on 06.11.18.
//  Copyright © 2018 Petar Jedek. All rights reserved.
//

import Foundation

class User {
    
    var id: Int
    var firstName: String
    var lastName: String
    var email: String
    var modifiedAt: String
    var deletedAt: String
    var username: String
    var password: String
    
    init(id: Int, firstName: String, lastName: String, email: String,
         modifiedAt: String, deletedAt: String, username: String, password: String) {
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.modifiedAt = modifiedAt
        self.deletedAt = deletedAt
        self.username = username
        self.password = password
        
    }
    
    
}
