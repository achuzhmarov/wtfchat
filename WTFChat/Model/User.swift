//
//  User.swift
//  wttc
//
//  Created by Artem Chuzhmarov on 05/09/15.
//  Copyright (c) 2015 Artem Chuzhmarov. All rights reserved.
//

import Foundation

class User : BaseEntity {
    
    let timestamp: NSDate
    
    var login: String
    var password: String
    var email: String
    var suggestions: Int
    var rating: Int
    var talk: Talk?
    
    var friends: [String]?
    
    init(id: String, login: String, password: String, email: String,
        suggestions: Int, rating: Int, timestamp: NSDate, talk: Talk?) {
            
        self.timestamp = timestamp
        self.login = login
        self.password = password
        self.email = email
        self.suggestions = suggestions
        self.rating = rating
        self.suggestions = suggestions
        self.talk = talk
            
        super.init(id: id);
    }
}
