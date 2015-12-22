//
//  Message.swift
//  FuzzyChat_Testing
//
//  Created by David on 2015/12/22.
//  Copyright © 2015年 David. All rights reserved.
//

import Foundation

class Message : NSObject, JSQMessageData {
    var senderId_: String
    var senderDisplayName_: String
    var date_: NSDate
    var isMediaMessage_: Bool
    var messageHash_: UInt
    var text_: String
    
    init(text: String, sender: String) {
        self.senderId_ = sender
        self.senderDisplayName_ = "some Guy"
        self.date_ = NSDate()
        self.isMediaMessage_ = false
        self.messageHash_ = 0
        self.text_ = text
    }
    
    // protocols
    func senderId() -> String! {
        return self.senderId_
    }
    func senderDisplayName() -> String! {
        return self.senderDisplayName_
    }
    func date() -> NSDate! {
        return self.date_
    }
    func isMediaMessage() -> Bool {
        return self.isMediaMessage_
    }
    func messageHash() -> UInt {
        return self.messageHash_
    }
    func text() -> String! {
        return self.text_
    }
}