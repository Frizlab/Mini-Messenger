/*
 * ViewController.swift
 * Mini Messenger
 *
 * Created by François Lamboley on 13/07/2017.
 * Copyright © 2017 François Lamboley. All rights reserved.
 */

import UIKit



class ViewController: UIViewController, UIWebViewDelegate {
	
	@IBOutlet var viewLoading: UIView!
	@IBOutlet var viewLoadingError: UIView!
	@IBOutlet var labelErrorDescription: UILabel!
	
	@IBOutlet var webView: UIWebView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		loadMainPage()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	@IBAction func goBackAction(_ sender: AnyObject) {
		guard let gesture = sender as? UIGestureRecognizer, gesture.state == .recognized else {return}
		webView.goBack()
	}
	
	@IBAction func reload(_ sender: AnyObject) {
		loadMainPage()
	}
	
	func webViewDidStartLoad(_ webView: UIWebView) {
		UIView.animate(withDuration: 0.25){ self.viewLoading.alpha = 1; self.viewLoadingError.alpha = 0; self.webView.alpha = 1 }
	}
	
	func webViewDidFinishLoad(_ webView: UIWebView) {
		UIView.animate(withDuration: 0.25){ self.viewLoading.alpha = 0; self.viewLoadingError.alpha = 0; self.webView.alpha = 1 }
	}
	
	func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
		labelErrorDescription.text = error.localizedDescription
		UIView.animate(withDuration: 0.25){ self.viewLoading.alpha = 0; self.viewLoadingError.alpha = 1; self.webView.alpha = 0 }
	}
	
	private func loadMainPage() {
		webView.loadRequest(URLRequest(url: URL(string: "https://facebook.com/messages/")!))
	}
	
	private func imageWithColor(_ color: UIColor) -> UIImage {
		let rect = CGRect(x: 0, y: 0, width: 1 , height: 1)
		
		UIGraphicsBeginImageContext(rect.size)
		let context = UIGraphicsGetCurrentContext()
		
		context?.setFillColor(color.cgColor)
		context?.fill(rect)
		
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return image!
	}
	
}
