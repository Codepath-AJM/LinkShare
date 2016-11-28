//
//  LinkViewController.swift
//  LinkShare
//
//  Created by Ju Hae Lee on 11/27/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import UIKit
import WebKit

class LinkViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!

    // chat drawer
    var trayView: ChatTrayView!
    var trayOriginalCenter: CGPoint!
    
    required init?(coder aDecoder: NSCoder) {
        let webConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfig)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(webView)
        view.sendSubview(toBack: webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        let height = NSLayoutConstraint(item: webView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: webView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        view.addConstraints([height, width])

        // load url
        let myURL = URL(string: "https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        // misc
        // disable back and forward buttons on load
        backButton.isEnabled = false
        forwardButton.isEnabled = false
        
        // add ChatTrayView programatically
        trayView = ChatTrayView(frame: CGRect(x: 0, y: view.bounds.height - 60, width: view.bounds.width, height: view.bounds.height))
        view.addSubview(trayView)
        
        // add gesture recognizers
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(LinkViewController.didPanTray(_:)))
        trayView.addGestureRecognizer(panGestureRecognizer)

        // add observer to webView to handle back and forward buttons
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // change state of the nav bar buttons depending on current state of the webview
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading" {
            backButton.isEnabled = webView.canGoBack
            forwardButton.isEnabled = webView.canGoForward
        }
    }

    @IBAction func back(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func forward(_ sender: Any) {
        webView.goForward()
    }
    
    @IBAction func reload(_ sender: Any) {
        let request = URLRequest(url: webView.url!)
        webView.load(request)
    }
    
    
    func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        if sender.state == .began {
            trayOriginalCenter = trayView.center
        } else if sender.state == .changed {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
