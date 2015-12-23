//
//  TestViewController.swift
//  FuzzyChat_Testing
//
//  Created by David on 2015/12/23.
//  Copyright © 2015年 David. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    var ref = Firebase(url: "https://fuzzychat-testing.firebaseio.com/conversations")

    override func viewDidLoad() {
        super.viewDidLoad()

        let b = NSDate()
        // Do any additional setup after loading the view.
        ref.queryOrderedByChild("user_id_1").queryEqualToValue(4).observeEventType(.Value) { (s:FDataSnapshot!) -> Void in
            print(s.childrenCount)
            let a = NSDate()
            print(a.timeIntervalSinceDate(b))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
