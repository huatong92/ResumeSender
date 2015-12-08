

import UIKit
import MediaPlayer
import MobileCoreServices

class ImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var image: UIImageView!
    
    @IBAction func send(sender: UIButton) {
        
        let im: UIImage = image.image!
        let controller = UIActivityViewController(activityItems: [im], applicationActivities: nil)
        // Exclude all activities except AirDrop.
        let list1:[String]?  = [UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
            UIActivityTypePostToWeibo,
            UIActivityTypeMessage, UIActivityTypeMail,
            UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
            UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
            UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
        controller.excludedActivityTypes = list1
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func album(sender: UIButton) {
        
        let pickerC = UIImagePickerController()
        pickerC.delegate = self
        self.presentViewController(pickerC, animated: true, completion: nil)
    }
    
    
    @IBAction func useCamera(sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        
        //to select only camera controls, not video controls
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.showsCameraControls = true
        //imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        let imagePickerc = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        image.image = imagePickerc
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafePointer<()>){
        if(error != nil){
            print("ERROR IMAGE \(error.debugDescription)")
        }
    }
    
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        self.dismissViewControllerAnimated(true, completion: nil)
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

