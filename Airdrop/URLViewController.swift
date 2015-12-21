

import UIKit
import Foundation

class URLViewController: UIViewController, UIWebViewDelegate {
    var userId = "default_id"
    let myURL: String = "http://52.91.80.155:80"
    var status = 0
    var pdfurl: String = "default_url"
    var socket = SocketIOClient(socketURL: "http://52.91.80.155:80")
    
    @IBOutlet weak var webView: UIWebView!
  
    @IBAction func testbtn(sender: UIButton) {
        sendViaAirdrop()
    }
 

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
    func sendThroughSocket(senderId: String, url: String) {
        let data: String = senderId + "%%%" + url
        socket.emit("receiveResume", data)
    }
    
    
    // handle message receiver from socket
    func addHandlers() {
        self.socket.on("sendResume") {[weak self] data, ack in
            self!.pdfurl = data as! String
            self!.sendViaAirdrop()
            return
        }
        
        self.socket.on("userId") {[weak self] data, ask in
            self!.userId = data as! String
            return
        }
        
    
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        let request = NSURLRequest(URL: NSURL(string: myURL)!)
        self.webView.loadRequest(request)        // Do any additional setup after loading the view.

        self.addHandlers()
        self.socket.connect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
