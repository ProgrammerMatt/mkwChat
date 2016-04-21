//
//  ChatWindowController.swift
//  mkwChat
//
//  Created by Matt Wilfert on 4/19/16.
//  Copyright © 2016 Matt Wilfert. All rights reserved.
//

import Cocoa

class ChatWindowController: NSWindowController {

    @IBOutlet weak var chatText: NSTextField!

    @IBOutlet weak var sendMessage: NSTextField!
    let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
    
    var flag = false

    
    override func windowDidLoad() {
        super.windowDidLoad()

        chatText.stringValue = ""
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        //var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("updateChat"), userInfo: nil, repeats: true)
        
        

    }
    
    
    func append(newString: String){
        chatText.stringValue += newString + "\n"
    }
    
    @IBAction func sendMessageAction(sender: AnyObject) {
        
        
        let socket = ActiveSocket<sockaddr_in>()!
            .onRead { sock, _ in
                let (count, block, errno) = sock.read() // $0 for sock doesn't work anymore?
                guard count > 0 else {
                    print("EOF, or great error handling \(errno).")
                    return
                }
                print("Answer to ring,ring is: \(count) bytes: \(block)")
            }
            .connect(appDelegate.s!) { socket in
                socket.write(self.appDelegate.Encryptor.encrypt(self.sendMessage.stringValue, key: "E", option: self.appDelegate.encryptionMethod!)
)
        }
        
        chatText.stringValue += "Me: "+sendMessage.stringValue + "\n"
        let client = appDelegate.client
        let string = sendMessage.stringValue
        client?.send(str:string)
        sendMessage.stringValue = ""
        
        

    }
    }



