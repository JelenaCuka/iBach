//
//  UserSessionDefaults.swift
//  iBach
//
//  Created by Petar Jedek on 07.11.18.
//  Copyright © 2018 Petar Jadek. All rights reserved.
//

import Foundation

class UserSessionDefaults: User {
    
    let defaults = UserDefaults.standard
    
    public func setUserDefaults(user: User) {
        defaults.set(id, forKey: "userId")
        defaults.set(firstName, forKey: "firstName")
        defaults.set(lastName, forKey: "lastName")
        defaults.set(email, forKey: "email")
        defaults.set(username, forKey: "username")
        defaults.set(true, forKey: "logged")
    }
    
    public func getUserDefaults(type: String, key: String) -> String {
        if (type == "string") {
            let value = defaults.string(forKey: key) ?? ""
            return value
        }
        
        else if (type == "integer") {
            let value = defaults.integer(forKey: key)
            return "\(value)"
        }
            
        else if (type == "bool") {
            let value = defaults.bool(forKey: key)
            return "\(value)"
        }
        
        else {
            return "not found, wrong key"
        }
    }
    
    public func clearUserDefaults() {
        defaults.removeObject(forKey: "userID")
        defaults.removeObject(forKey: "firstName")
        defaults.removeObject(forKey: "lastName")
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "username")
        defaults.removeObject(forKey: "set")
    }
    
}
