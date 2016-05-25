//
//  ViewController.swift
//  WkWebViewPlactice
//
//  Created by kentaro on 2016/05/25.
//  Copyright © 2016年 kentaro aoki. All rights reserved.
//

import UIKit
import WebKit
import Social

//WkWebViewのデリゲートを宣言
class ViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    //WkWebViewクラスのインスタンスを生成
    var myWkWebView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //myWkWebViewのサイズを設定
        myWkWebView.frame = CGRectMake(0, 64, self.view.frame.width, self.view.frame.height-108)
        
        //画面にmyWkWebViewを配置
        view.addSubview(myWkWebView)
        
        //WebページのURLから、NSURLRequestのインスタンスを生成し、WkWebViewに読み込む。
        let myURL = NSURL(string: "http://wired.jp/")
        let myURLRequest = NSURLRequest(URL: myURL!)
        myWkWebView.loadRequest(myURLRequest)
        
        //デリゲート先をView Controllerクラスに設定
        myWkWebView.navigationDelegate = self
        
        //Webページのタイトルを監視
        myWkWebView.addObserver(self, forKeyPath: "title", options: .New, context: nil)
        }

    //Webページの読み込みが開始したタイミングで、インジケータを表示
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    //Webページの読み込みが完了したタイミングで、インジケータを非表示
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    //戻るボタン
    @IBAction func tapBackBtn(sender: UIButton) {
        myWkWebView.goBack()
    }
    
    //進むボタン
    @IBAction func tapNextBtn(sender: UIButton) {
        myWkWebView.goForward()
    }
    
    //再読み込みボタン
    @IBAction func tapReloaBtn(sender: UIButton) {
        myWkWebView.reload()
    }
    
    //読み込み中止ボタン
    @IBAction func tapStopBtn(sender: UIButton) {
        myWkWebView.stopLoading()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        //ヘッダーのLabelにWebページの記事のタイトルを表示
        titleLabel.text = myWkWebView.title
    }

    deinit {
        //監視解除
        myWkWebView.removeObserver(self, forKeyPath: "title")
    }
    
    @IBAction func openActionBtn(sender: UIButton) {
        let alertController = UIAlertController(title: "アクションシート", message: "actionsheet", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let facebookAction = UIAlertAction(title: "Facebook", style: .Default, handler: {
            (action: UIAlertAction!) -> Void in
            self.facebookShare()
        })
        alertController.addAction(facebookAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    func facebookShare() {
        let facebookVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        facebookVC.addURL(myWkWebView.URL)
        facebookVC.setInitialText("#TECH::CAMP")
        self.presentViewController(facebookVC, animated: true, completion: nil)
    }
}

