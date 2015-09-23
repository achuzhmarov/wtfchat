//
//  Message.swift
//  wttc
//
//  Created by Artem Chuzhmarov on 05/09/15.
//  Copyright (c) 2015 Artem Chuzhmarov. All rights reserved.
//

import Foundation

class Message : BaseEntity, JSQMessageData {
    let timestamp: NSDate
    let talkId: String
    
    var author: User
    var words: [Word]?
    var deciphered: Bool
    
    init(id: String, talkId: String, author: User) {
        
        self.timestamp = NSDate()
        self.talkId = talkId
        self.author = author
        self.deciphered = false
        
        super.init(id: id)
    }
    
    init(id: String, talkId: String, author: User, words: [Word]?, cipher: Cipher = FirstLetterCipher()) {
        
        self.timestamp = NSDate()
        self.talkId = talkId
        self.author = author
        self.deciphered = false
        
        for word in words! {
            word.cipher = cipher
        }
        
        self.words = words
        
        super.init(id: id)
    }
    
    init(id: String, talkId: String, author: User, words: [Word]?, deciphered: Bool) {
        
        self.timestamp = NSDate()
        self.talkId = talkId
        self.author = author
        self.deciphered = deciphered
        self.words = words
        
        super.init(id: id)
    }
    
    init(id: String, timestamp: NSDate, talkId: String, author: User, deciphered: Bool) {
            
            self.timestamp = timestamp
            self.talkId = talkId
            self.author = author
            self.deciphered = deciphered
            
            super.init(id: id)
    }
    
    func getWordsWithoutDelimiters() -> [Word] {
        var result = [Word]()
        
        for word in words! {
            if (word.wordType != WordType.Delimiter) {
                result.append(word)
            }
        }
        
        return result
    }

    func countSuccess() -> Int {
        return countWordsByStatus(WordType.Success)
    }
    
    func countNew() -> Int {
        return countWordsByStatus(WordType.New)
    }
    
    func countFailed() -> Int {
        return countWordsByStatus(WordType.Failed)
    }
    
    func countWordsByStatus(wordType: WordType) -> Int {
        var result = 0
        
        for word in words! {
            if (word.wordType == wordType) {
                result++
            }
        }
        
        return result
    }
    
    // MARK: JSQMessageData realization
    
    func text() -> String! {
        if (self.deciphered) {
            return clearText()
        } else {
            return "???"
        }
    }
    
    func clearText() -> String! {
        var result = ""
            
        if (words != nil) {
            for word in words! {
                result += word.getClearText()
            }
        }
            
        return result
    }
    
    func senderId() -> String! {
        return author.id
    }
    
    func senderDisplayName() -> String! {
        return author.login
    }
    
    func date() -> NSDate! {
        return timestamp
    }
    
    func isMediaMessage() -> Bool {
        return false;
    }
    
    func messageHash() -> UInt {
        return UInt(id.hash);
    }
}