//
//  Talk.swift
//  wttc
//
//  Created by Artem Chuzhmarov on 05/09/15.
//  Copyright (c) 2015 Artem Chuzhmarov. All rights reserved.
//

import Foundation

class Talk : BaseEntity {
    var users = [User]()
    var size: Int
    
    var messages = [Message]() {
        didSet {
            lastMessage = messages.last
        }
    }
    
    var lastMessage: Message?
    
    override init(id: String) {
        self.size = 2
        super.init(id: id)
    }
    
    func appendMessage(message: Message) {
        messages.append(message)
        lastMessage = message
    }
}