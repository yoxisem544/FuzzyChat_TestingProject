//
//  Murmur.swift
//  FuzzyChat_Testing
//
//  Created by David on 2015/12/23.
//  Copyright © 2015年 David. All rights reserved.
//

import Foundation

class Murmur: NSObject {
    var user: Int
    var answer: String
    
    init(user: Int, answer: String) {
        self.user = user
        self.answer = answer
    }
    
    init?(snapshot: FDataSnapshot!) {
        self.user = 0
        self.answer = ""
        super.init()
        if let s = snapshot {
            print(s.value["user_id"])
            if let user = s.value["user_id"] as? Int {
                self.user = user
            } else {
                return nil
            }
            if let answer = s.value["answer"] as? String {
                self.answer = answer
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}