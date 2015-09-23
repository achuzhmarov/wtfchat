//
//  UserDao.swift
//  wttc
//
//  Created by Artem Chuzhmarov on 05/09/15.
//  Copyright (c) 2015 Artem Chuzhmarov. All rights reserved.
//

import Foundation

let userService : UserService = getUserServiceInstance()

func getUserServiceInstance() -> UserService {
    let service = UserService();
    
    let currentUser = User(id: "1", login: "tigra", password: "tigra", email: "email",
        suggestions: 3, rating: 10, timestamp: NSDate(), talk: nil)
    
    service.currentUser = currentUser
    
    service.users = [
        User(id: "2", login: "tigra1", password: "tigra1", email: "email1",
            suggestions: 1, rating: 11, timestamp: NSDate(), talk: nil),
        User(id: "3", login: "tigra2", password: "tigra2", email: "email2",
            suggestions: 2, rating: 12, timestamp: NSDate(), talk: nil),
        User(id: "4", login: "tigra3", password: "tigra3", email: "email3",
            suggestions: 3, rating: 13, timestamp: NSDate(), talk: nil),
        User(id: "5", login: "tigra4", password: "tigra4", email: "email4",
            suggestions: 4, rating: 14, timestamp: NSDate(), talk: nil)
    ]
    
    return service
}

class UserService : BaseService {
    var users: [User]?
    var currentUser: User?
    
    func getAllFriends(user: String) -> [User]? {
        for user in users! {
            user.talk = talkService.getTalkByUsers(currentUser!.login, user2: user.login)
        }
        
        return users;
    }
    
    func getUserByLogin(login: String) -> User? {
        for user in users! {
            if (user.login == login) {
                return user
            }
        }
        
        return nil
    }
    
    func getCurrentUser() -> User {
        return currentUser!
    }
    
    func useSuggestion() {
        currentUser!.suggestions--
    }
}