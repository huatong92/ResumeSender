
//  URLViewController.swift
//  Airdrop
//
//  Created by Hua Tong on 11/22/15.
//  Copyright © 2015 Carlos Butron. All rights reserved.

import UIKit
import Foundation

class URLViewController: UIViewController, UIWebViewDelegate {
    var userId = "default_id"
    let myURL: String = "http://52.91.80.155"
    var status = 0
    var pdfurl: String = "default_url"
    var socket = SocketIOClient(socketURL: "52.91.80.155")
    
    @IBOutlet weak var webView: UIWebView!
 

    func sendViaAirdrop() {
        // get the documents folder url
        let documentDirectoryURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        
        // create the destination url for the text file to be saved
        let fileDestinationUrl = documentDirectoryURL.URLByAppendingPathComponent(userId + ".resume");
        
        let text = userId + "%%%" + pdfurl;
        
        do{
            // writing to disk
            try text.writeToURL(fileDestinationUrl, atomically: true, encoding: NSUTF8StringEncoding)
            
        } catch let error as NSError {
            print("error writing to url \(fileDestinationUrl)")
            print(error.localizedDescription)
        }
        
        let controller = UIActivityViewController(activityItems: [fileDestinationUrl], applicationActivities: nil)
        // Exclude all activities except AirDrop.
        let list:[String]?  = [UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
            UIActivityTypePostToWeibo,
            UIActivityTypeMessage, UIActivityTypeMail,
            UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
            UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
            UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
        controller.excludedActivityTypes = list
        self.presentViewController(controller, animated: true, completion: nil)
    }

    
    // send receive confirmation message
    func sendIdAndUrl(senderId: String, url: String) {
        self.socket.emit("receiveResume", ["id": senderId, "url": url])
    }
    
    
    // handle message receiver from socket
    func addHandlers() {
        self.socket.on("sendResume") {data, ack in
            print("url received")
            if let json = data[0] as? NSDictionary {
                print(json["data"]!)
                self.pdfurl = json["data"] as! String
                self.sendViaAirdrop()
            }
            
            return
        }
        
        self.socket.on("uid") {data, ask in
            print("uid received")
            if let json = data[0] as? NSDictionary {
                print(json["user"]!)
                self.userId = json["user"] as! String
            }
            return
        }
        
        self.socket.on("test") {data, ask in
            if let json = data[0] as? NSDictionary {
                print(json["test"]!)
                self.socket.emit("ios", ["data":"hello!"])
            }
            return
        }
       
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        let request = NSURLRequest(URL: NSURL(string: myURL)!)
        self.webView.loadRequest(request)
        
        self.addHandlers()
        self.socket.connect()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
