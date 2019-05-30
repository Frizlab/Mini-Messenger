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
	
	@IBOutlet var bottomContraint: NSLayoutConstraint!
	
	deinit {
		/* Not actually needed with iOS 11 IIRC. */
		if let observer = observerForEnterBg {NotificationCenter.default.removeObserver(observer, name: UIApplication.didEnterBackgroundNotification, object: nil)}
		if let observer = observerForEnterFg {NotificationCenter.default.removeObserver(observer, name: UIApplication.willEnterForegroundNotification, object: nil)}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		viewLoadingError.alpha = 0
		
		loadMainPage()
		observerForEnterBg = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [weak self] n in
			self?.dateEnteredBg = Date()
		}
		observerForEnterFg = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] n in
			guard let strongSelf = self, let dateBg = strongSelf.dateEnteredBg, dateBg.timeIntervalSinceNow <= -15 else {return}
			strongSelf.loadMainPage()
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		keyboardObserver = NotificationCenter.default.addObserver(forName: UIApplication.keyboardWillChangeFrameNotification, object: nil, queue: .main, using: { [weak self] n in
			guard let strongSelf = self else {return}
//			guard let keyboardFrameStart = n.userInfo?[UIApplication.keyboardFrameBeginUserInfoKey] as? CGRect else {return}
			guard let keyboardFrameEnd = n.userInfo?[UIApplication.keyboardFrameEndUserInfoKey] as? CGRect else {return}
			let duration = n.userInfo?[UIApplication.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.5
			
			UIView.animate(withDuration: duration, animations: {
				let viewBottomY = strongSelf.view.bounds.maxY - strongSelf.view.safeAreaInsets.bottom
				let keyboardBottomY = strongSelf.view.convert(keyboardFrameEnd, from: nil).minY
				strongSelf.bottomContraint.constant = viewBottomY - keyboardBottomY
				strongSelf.view.layoutIfNeeded()
			})
		})
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		if let o = keyboardObserver {
			NotificationCenter.default.removeObserver(o, name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
			keyboardObserver = nil
		}
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
	
	private var keyboardObserver: NSObjectProtocol?
	
	private var dateEnteredBg: Date?
	private var observerForEnterBg: NSObjectProtocol?
	private var observerForEnterFg: NSObjectProtocol?

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
