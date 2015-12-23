//
//  Room.swift
//  FuzzyChat_Testing
//
//  Created by David on 2015/12/23.
//  Copyright © 2015年 David. All rights reserved.
//

import Foundation

class Room: NSObject {
    var roomId: String
    var roomTitle: String
    var user1: Int
    var user2: Int
    
    init?(snapshot: FDataSnapshot!) {
        roomId = ""
        roomTitle = ""
        user1 = 0
        user2 = 0
        super.init()
        if let s = snapshot {
            if let roomId = s.value["room_id"] as? String {
                self.roomId = roomId
            } else {
                return nil
            }
            if let roomTitle = s.value["room_title"] as? String {
                self.roomTitle = roomTitle
            } else {
                return nil
            }
            if let user1 = s.value["user_1"] as? Int {
                self.user1 = user1
            } else {
                return nil
            }
            if let user2 = s.value["user_2"] as? Int {
                self.user2 = user2
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}