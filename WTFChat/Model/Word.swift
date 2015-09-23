//
//  Word.swift
//  wttc
//
//  Created by Artem Chuzhmarov on 05/09/15.
//  Copyright (c) 2015 Artem Chuzhmarov. All rights reserved.
//

import Foundation

enum WordType {
    case New, Success, Failed, Delimiter, Ignore
}

class Word : NSObject {
    var text: String
    var wordType = WordType.New
    var additional = ""
    var cipher: Cipher = FirstLetterCipher() {
        didSet {
            if (wordType == WordType.New) {
                cipherWord()
            }
        }
    }
    
    private var cipheredText = ""
    
    init (word: Word) {
        self.text = word.text
        self.additional = word.additional
        self.wordType = word.wordType
        self.cipher = word.cipher
        self.cipheredText = word.cipheredText
    }
    
    init(text: String) {
        self.text = text
    }
    
    init(text: String, wordType: WordType) {
        self.text = text
        self.wordType = wordType
    }

    init(text: String, additional: String) {
        self.text = text
        self.additional = additional
    }
    
    init(text: String, additional: String, wordType: WordType) {
        self.text = text
        self.additional = additional
        self.wordType = wordType
    }
    
    func getClearText() -> String {
        return self.text + self.additional
    }
    
    func cipherWord() -> String {
        if (cipheredText == "") {
            cipheredText = cipher.getTextForDecipher(self)
        }
        
        return cipheredText
    }
    
    func getTextForDecipher() -> String {
        if (self.wordType == WordType.New) {
            return self.cipherWord()
        } else {
            return text + additional
        }
    }
    
    static func delimiterWord() -> Word {
        return Word(text: " ", wordType: WordType.Delimiter)
    }
}