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
        messageRef.queryLimitedToLast(25).observeEventType(.ChildAdded) { (s: FDataSnapshot!) -> Void in
            print(s)
            
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: toolbar
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        print(text)
        print(senderId)
        print(senderDisplayName)
        print(date)
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        print("acc tapped")
    }

    // MARK: JSQ Data source
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

}

