

import UIKit
import Foundation

class URLViewController: UIViewController, UIWebViewDelegate {
    
    var userName = "shenme" // test
    var myURL: String = ""
    var status = 0
    var pdfurl: String = "pdfurl" // test
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var sendBut: UIButton!
    
    @IBAction func hide() {
        if (sendBut.hidden == true) {
            sendBut.hidden = false;
        }
        else {
            sendBut.hidden = true;
        }
        
    }

    @IBAction func send(sender: UIButton) {
        // get the documents folder url
        let documentDirectoryURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        
        // create the destination url for the text file to be saved
        let fileDestinationUrl = documentDirectoryURL.URLByAppendingPathComponent(userName + ".resume");
        
        let text = userName + "%%%" + pdfurl;
        
        do{
            // writing to disk
            try text.writeToURL(fileDestinationUrl, atomically: true, encoding: NSUTF8StringEncoding)
            
            // saving was successful. any code posterior code goes here
            
            // reading from disk
            do {
                let mytext = try String(contentsOfURL: fileDestinationUrl, encoding: NSUTF8StringEncoding)
                print(mytext)   // "some text\n"
            } catch let error as NSError {
                print("error loading from url \(fileDestinationUrl)")
                print(error.localizedDescription)
            }
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
    
//    @IBAction func load(sender: UIButton) {
//        let request = NSURLRequest(URL: NSURL(string: myURL.text!)!)
//        self.webView.loadRequest(request)
//    }
    
    func websocket() {
        let ws = WebSocket("ws://localhost:8080/wsTest/echo")
        let send : () -> () = {
            let msg = "login"
            print("send: \(msg)")
            ws.send(msg)
        }
        send()
        ws.event.message = { message in
            if let text = message as? String {
                if (text == "login") {
                    self.sendBut.hidden = false;
                }
                else if (text.hasPrefix("http://")) {
                    self.pdfurl = text;
                }
                
                print("receive: \(text)")
            }
            
        }
        
    }
    
    
    override func viewDidLoad() {
//        sendBut.hidden = true;
        
        super.viewDidLoad()
        myURL = "http://54.173.162.138:8080"
        //myURL = "http://google.com"
        webView.delegate = self
        let request = NSURLRequest(URL: NSURL(string: myURL)!)
        self.webView.loadRequest(request)        // Do any additional setup after loading the view.
        
        websocket()
        
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
