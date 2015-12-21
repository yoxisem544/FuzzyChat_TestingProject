//
//  ViewController.swift
//  FuzzyChat_Testing
//
//  Created by David on 2015/12/21.
//  Copyright © 2015年 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var myRootRef = Firebase(url: "https://fuzzychat-testing.firebaseio.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var temp_users = myRootRef.childByAppendingPath("saving-data/temp_users")
        var alanisawesome = ["full_name": "Alan Turing", "date_of_birth": "June 23, 1912"]
        var gracehop = ["full_name": "Grace Hopper", "date_of_birth": "December 9, 1906"]
        var users = ["alanisawesome": alanisawesome, "gracehop": gracehop]
        temp_users.setValue(users)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

