//
//  TalkDao.swift
//  wttc
//
//  Created by Artem Chuzhmarov on 05/09/15.
//  Copyright (c) 2015 Artem Chuzhmarov. All rights reserved.
//

import Foundation

let talkService : TalkService = getTalkServiceInstance()

func getTalkServiceInstance() -> TalkService {
    let service = TalkService();
    
    let talk1 = Talk(id: "1");
    talk1.users.append(userService.getCurrentUser())
    talk1.users.append(userService.getUserByLogin("tigra1")!)
    
    let talk2 = Talk(id: "2");
    talk2.users.append(userService.getCurrentUser())
    talk2.users.append(userService.getUserByLogin("tigra2")!)
    
    let talk3 = Talk(id: "3");
    talk3.users.append(userService.getCurrentUser())
    talk3.users.append(userService.getUserByLogin("tigra3")!)
    
    talk1.messages = messageService.getMessagesByTalk(talk1)!
    talk2.messages = messageService.getMessagesByTalk(talk2)!
    talk3.messages = messageService.getMessagesByTalk(talk3)!
    
    service.talks = [
        talk1,
        talk2,
        talk3
    ]
    
    return service;
}

class TalkService : BaseService {
    var talks = [Talk]()
    
    func getTalkByUsers(user1: String, user2: String) -> Talk? {
        for talk in talks {
            if (talk.users[0].login == user1 && talk.users[1].login == user2 ||
                talk.users[1].login == user1 && talk.users[0].login == user2) {
                return talk
            }
        }
        
        return nil;
    }
    
    func createTalkForUsers(user1: User, user2: User) -> Talk {
        let newTalk = Talk(id: getNextId())
        newTalk.users.append(user1)
        newTalk.users.append(user2)
        
        talks.append(newTalk)
        
        return newTalk
    }
    
    private func getNextId() -> String {
        var max = 0
        
        for talk in talks {
            if Int(talk.id) > max {
                max = Int(talk.id)!
            }
        }
        
        return String(max + 1)
    }
}