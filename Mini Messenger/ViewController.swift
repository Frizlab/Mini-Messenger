/*
 * ViewController.swift
 * Mini Messenger
 *
 * Created by François Lamboley on 13/07/2017.
 * Copyright © 2017 François Lamboley. All rights reserved.
 */

import UIKit



class ViewController: UIViewController, UIWebViewDelegate {
	
	@IBOutlet var loadingView: UIView!
	@IBOutlet var webView: UIWebView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		webView.loadRequest(URLRequest(url: URL(string: "https://facebook.com/messages/")!))
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func webViewDidStartLoad(_ webView: UIWebView) {
		UIView.animate(withDuration: 0.25){ self.loadingView.alpha = 1 }
	}
	
	func webViewDidFinishLoad(_ webView: UIWebView) {
		UIView.animate(withDuration: 0.25){ self.loadingView.alpha = 0 }
	}
	
}
