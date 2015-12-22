//
//  ViewController.swift
//  FuzzyChat_Testing
//
//  Created by David on 2015/12/21.
//  Copyright © 2015年 David. All rights reserved.
//

import UIKit

class ViewController: JSQMessagesViewController {

    var messageRef = Firebase(url: "https://fuzzychat-testing.firebaseio.com/").childByAppendingPath("testing-message")
    var messages: [Message]?
    // jsq stuff
    var outgoingMessagesBubbleImage = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    var incomingMessagesBubbleImage = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    
    func setupFirebase() {
        // initialize
        messages = []
        // query the latest 25 messages
        messageRef.queryLimitedToLast(25).observeEventType(.ChildAdded) { (s: FDataSnapshot!) -> Void in
            print(s)
            let text = s.value?["text"] as? String
            let sender = s.value?["sender_id"] as? String
            let msg = Message(text: text!, sender: sender!)
            self.messages?.append(msg)
            // after receiving msgs
            self.finishReceivingMessage()
        }
    }
    
    func setupJSQ() {
        senderId = "some one!"
        senderDisplayName = "Displaying Name"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupJSQ()
        setupFirebase()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView!.collectionViewLayout.springinessEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        JSQMessagesCollectionViewFlowLayoutInvalidationContext.con
    }

    func sendMessage(text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let msg = ["text": text, "sender_id": senderId, "sender_display_name": senderDisplayName, "date": date.stringValue]
        messageRef.childByAutoId().setValue(msg)
    }
    
    // MARK: toolbar
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        print(text)
        print(senderId)
        print(senderDisplayName)
        print(date)
        sendMessage(text, senderId: senderId, senderDisplayName: senderDisplayName, date: date)
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        print("acc tapped")
    }

    // MARK: JSQ Data source
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if messages != nil {
            return messages!.count
        }
        
        return 0
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages![indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didDeleteMessageAtIndexPath indexPath: NSIndexPath!) {
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let msg = messages![indexPath.item]
        
        if msg.senderId() == senderId {
            return outgoingMessagesBubbleImage
        }
        
        return incomingMessagesBubbleImage
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let a = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "1.jpg"), diameter: 30)
        return a
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let msg = messages![indexPath.item]
        if msg.senderId() == senderId {
            cell.textView?.textColor = UIColor.blackColor()
        } else {
            cell.textView?.textColor = UIColor.whiteColor()
        }
        
        return cell
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
}

extension NSDate {
    var stringValue: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        return formatter.stringFromDate(self)
    }
}
