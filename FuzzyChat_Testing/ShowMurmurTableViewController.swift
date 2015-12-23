//
//  ShowMurmurTableViewController.swift
//  FuzzyChat_Testing
//
//  Created by David on 2015/12/23.
//  Copyright © 2015年 David. All rights reserved.
//

import UIKit

class ShowMurmurTableViewController: UITableViewController {
    
    var murmurs: [Murmur]?
    var answersRef = Firebase(url: FirebaseLinks.answers)
    var roomsRef = Firebase(url: FirebaseLinks.rooms)
    var userId = 997
    
    func setupFirebase() {
        murmurs = []
        answersRef.observeEventType(.ChildAdded) { (s:FDataSnapshot!) -> Void in
            if let snapshot = s {
                print("get snapshot")
                if let murmur = Murmur(snapshot: snapshot) {
                    self.murmurs?.append(murmur)
                    print("yo mur created")
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func dumpData() {
        let user = random() % 99
        let place = ["on the floor", "on your face", "on the desk", "on the pants"]
        let dic = ["user_id": user, "answer": "poopoo" + place[random()%4]]
        answersRef.childByAutoId().setValue(dic)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        setupFirebase()
        
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard murmurs != nil else {
            return 0
        }
        return murmurs!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("murmurCell", forIndexPath: indexPath) as! MurmurTableViewCell

        if let murmur = murmurs?[indexPath.row] {
            // Configure the cell...
            cell.userLabel.text = "\(murmur.user)"
            cell.answerLabel.text = murmur.answer
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        if let murmur = murmurs?[indexPath.row] {
            alertUserIsGoingToCreateRoom(murmur.user, result: murmur.answer)
        }
    }
    
    func alertUserIsGoingToCreateRoom(user: Int, result: String) {
        let alert = UIAlertController(title: "警告", message: "你要跟\(user)發生關係了，原因：\(result)", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "來吧", style: .Cancel) { (action:UIAlertAction) -> Void in
            self.createRoom(user, result: result)
        }
        let no = UIAlertAction(title: "不要", style: .Default, handler: nil)
        alert.addAction(ok)
        alert.addAction(no)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func createRoom(anotherUser: Int, result: String) {
        let room = ["room_id": result, "room_title": result, "user_1": userId, "user_2": anotherUser]
        roomsRef.childByAutoId().setValue(room)
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
