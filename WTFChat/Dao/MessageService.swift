//
//  MessageDao.swift
//  wttc
//
//  Created by Artem Chuzhmarov on 05/09/15.
//  Copyright (c) 2015 Artem Chuzhmarov. All rights reserved.
//

import Foundation

let messageService : MessageService = getMessageServiceInstance()

func getMessageServiceInstance() -> MessageService {
    let dao = MessageService();
    
    let words1 = [
        Word(text: "Добро"),
        Word.delimiterWord(),
        Word(text: "пожаловать"),
        Word.delimiterWord(),
        Word(text: "в", wordType: WordType.Ignore),
        Word.delimiterWord(),
        Word(text: "чат", additional: "!"),
        Word.delimiterWord(),
        Word(text: "Привет"),
        Word.delimiterWord(),
        Word(text: "как"),
        Word.delimiterWord(),
        Word(text: "дела", additional: "?"),
        Word.delimiterWord(),
        Word(text: "Норм", additional: ".")
    ]
    
    let words2 = [
        Word(text: "Привет", wordType: WordType.Success),
        Word.delimiterWord(),
        Word(text: "как", wordType: WordType.Success),
        Word.delimiterWord(),
        Word(text: "дела", additional: "?", wordType: WordType.Success)
    ]
    
    let words3 = [
        Word(text: "Норм", additional: ".")
    ]
    
    let currentUser = userService.getCurrentUser()
    let targetUser = userService.getUserByLogin("tigra1")!
    
    dao.messages = [
        Message(id: "1", talkId: "1", author: currentUser, words: words1),
        Message(id: "2", talkId: "1", author: targetUser, words: words2, deciphered: true),
        Message(id: "3", talkId: "1", author: currentUser, words: words3),
        Message(id: "4", talkId: "1", author: targetUser, words: words1),
        
        Message(id: "5", talkId: "2", author: currentUser, words: words1, deciphered: true),
        Message(id: "6", talkId: "2", author: targetUser, words: words2, deciphered: true),
        
        Message(id: "7", talkId: "3", author: currentUser, words: words2, deciphered: true),
        Message(id: "8", talkId: "3", author: targetUser, words: words1),
    ]
    
    return dao;
}

class MessageService : BaseService {
    var messages = [Message]()
    
    func getMessagesByTalk(talk: Talk) -> [Message]? {
        var result = [Message]()
        
        for message in messages {
            if (message.talkId == talk.id) {
                result.append(message)
            }
        }
        
        return result;
    }
    
    private func getNextId() -> String {
        var max = 0
        
        for message in messages {
            if Int(message.id) > max {
                max = Int(message.id)!
            }
        }
        
        return String(max + 1)
    }
    
    func decipher(message: Message, guessText: String) {
        let guessWords = guessText.characters.split {$0 == " "}.map { String($0) }
        
        let words = message.words
        
        for guessWord in guessWords {
            for word in words! {
                if (word.text.uppercaseString == guessWord.uppercaseString) {
                    word.wordType = WordType.Success
                }
            }
        }
        
        checkDeciphered(message)
    }
    
    func decipher(message: Message, suggestedWord: Word) {
        suggestedWord.wordType = WordType.Success
        checkDeciphered(message)
    }
    
    private func checkDeciphered(message: Message) {
        if (message.countNew() == 0) {
            message.deciphered = true
        }
    }
    
    func failed(message: Message) {
        for word in message.words! {
            if (word.wordType == WordType.New) {
                word.wordType = WordType.Failed
            }
        }
        
        message.deciphered = true
    }

    func createMessage(talk: Talk, text: String, cipherType: CipherType = CipherType.FirstLetterCipher) -> Message {
        let textWords = text.characters.split {$0 == " "}.map { String($0) }
        
        var words = [Word]()
        
        var first = true
        
        for textWord in textWords {
            if (first) {
                first = false
            } else {
                words.append(Word.delimiterWord())
            }
            
            words.appendContentsOf(createWords(textWord))
        }
        
        var author: User!
        
        if (talk.users[0].id == "0") {
            author = talk.users[0]
        } else {
            author = userService.getCurrentUser()
        }
        
        let newMessage = Message(id: messageService.getNextId(),
            talkId: talk.id,
            author: author,
            words: words,
            cipher: CipherFactory.getCipher(cipherType)
        )
        
        checkDeciphered(newMessage)
        
        talk.appendMessage(newMessage)
        
        return newMessage
    }
    
    private func createWords(textWord: String) -> [Word] {
        var words = [Word]()
        
        var newWordText = ""
        var newWordAdditional = ""
        
        var isLastLetter = true
        
        for uniChar in textWord.unicodeScalars {
            if (isLastLetter) {
                if (isLetter(uniChar)) {
                    newWordText += String(uniChar)
                } else {
                    isLastLetter = false
                    newWordAdditional += String(uniChar)
                }
            } else {
                if (isLetter(uniChar)) {
                    isLastLetter = true
                    
                    words.append(Word(text: newWordText, additional: newWordAdditional, wordType: getWordType(newWordText)))
                    
                    newWordText = String(uniChar)
                    newWordAdditional = ""
                } else {
                    newWordAdditional += String(uniChar)
                }
            }
        }
        
        words.append(Word(text: newWordText, additional: newWordAdditional, wordType: getWordType(newWordText)))

        return words
    }
    
    private func getWordType(newWordText: String) -> WordType {
        if (newWordText.characters.count == 1) {
            return WordType.Ignore
        } else {
            return WordType.New
        }
    }
    
    private let letters = NSCharacterSet.letterCharacterSet()
    private func isLetter(unicodeChar: UnicodeScalar) -> Bool {
        return letters.longCharacterIsMember(unicodeChar.value)
            //|| String(unicodeChar) == "'"
            //|| String(unicodeChar) == "-"
    }
    
    //let digits = NSCharacterSet.decimalDigitCharacterSet()
    /*func isDigit(unicodeChar: UnicodeScalar) -> Bool {
        return digits.longCharacterIsMember(unicodeChar.value)
    }*/
}