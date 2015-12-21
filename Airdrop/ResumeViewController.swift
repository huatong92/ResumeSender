//
//  ResumeViewController.swift
//  Airdrop
//
//  Created by Hua Tong on 12/20/15.
//  Copyright © 2015 Carlos Butron. All rights reserved.
//

import UIKit
import Foundation

class ResumeViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    func showResume(url: String) {
        super.viewDidLoad()
        self.webView.delegate = self
        let request = NSURLRequest(URL: NSURL(string: url)!)
        self.webView.loadRequest(request)
    }

}