//
//  ViewController.swift
//  FuzzyChat_Testing
//
//  Created by David on 2015/12/21.
//  Copyright © 2015年 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var myRootRef = Firebase(url: "https://dinosaur-facts.firebaseio.com/dinosaurs")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let temp_users = myRootRef.childByAppendingPath("saving-data/temp_users")
        let alanisawesome = ["full_name": "Alan Turing", "date_of_birth": "June 23, 1912"]
        let gracehop = ["full_name": "Grace Hopper", "date_of_birth": "December 9, 1906"]
        let users = ["alanisawesome": alanisawesome,"gracehop": gracehop, "alanisawesome1": alanisawesome,"gracehop1": gracehop]
//        temp_users.setValue(users)
//        temp_users.updateChildValues(users)
//        temp_users.setValue(users)
        temp_users.observeEventType(FEventType.Value) { (snapshot: FDataSnapshot!) -> Void in
//            print(snapshot)
        }
        temp_users.queryEqualToValue(1).observeEventType(.Value) { (snapshot: FDataSnapshot!) -> Void in
//            print(snapshot)
        }
        myRootRef.queryOrderedByChild("weight").observeEventType(.Value) { (sn: FDataSnapshot!) -> Void in
//            print(sn)
        }
        myRootRef.queryOrderedByChild("weight").queryEqualToValue(135000).observeEventType(.Value) { (s: FDataSnapshot!) -> Void in
//            print(s)
        }
        myRootRef.queryOrderedByChild("dinosaurs").observeEventType(.Value) { (s: FDataSnapshot!) -> Void in
//            print(s)
        }
        
        let some = myRootRef.childByAppendingPath("dinosaurs")
        some.observeEventType(.Value) { (S:FDataSnapshot!) -> Void in
//            print(S)
        }
        some.parent.observeEventType(.Value) { (s:FDataSnapshot!) -> Void in
            print(s)
        }
        some.parent.parent.observeEventType(.Value) { (s:FDataSnapshot!) -> Void in
            // 與上取到的層級是不一樣的喔！
            print(s)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

