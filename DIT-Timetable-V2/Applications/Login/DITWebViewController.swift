//
//  DITWebViewController.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 15/09/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit

class DITWebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var ditWebView: UIWebView!
    var actInd: UIActivityIndicatorView?
    var imageTimer : Timer?

    
    var studentID : String = ""
    var studentPass : String = ""
    var ditURL = "https://timetables.dit.ie/Web/Timetable"
    var ditAuthn = "https://idp.dit.ie/idp/Authn/UserPassword"
    var loginTimes = 0
    var timetableLoaded : Bool = false
    
    var gifURLs = [String]()
    
    var gifImage: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginTimes = 0
        
        let values = [
        "https://media.giphy.com/media/JIX9t2j0ZTN9S/giphy.gif",
        "https://media.giphy.com/media/wW95fEq09hOI8/giphy.gif",
        "https://media.giphy.com/media/u3QHTS2lmwAKc/giphy.gif",
        "https://media.giphy.com/media/ND6xkVPaj8tHO/giphy.gif",
        "https://media.giphy.com/media/l0IyayMlfXiWKTJCM/giphy.gif"
        ]
        
        if values.count >= 4 {
        
            for index in 1...4 {
                gifURLs.append(values[index])
            }
        }
        
        self.showActivityIndicatory(uiView: self.view)
        self.ditWebView.delegate = self
        
        self.imageTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(changeGIF), userInfo: nil, repeats: true)
        
        self.ditWebView.loadRequest(NSURLRequest(url: NSURL(string: self.ditURL)! as URL) as URLRequest)
        //self.sendRawTimetable(data: "")
    }
    
    /*func createBlurScreen() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        view.addSubview(blurEffectView)
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loginTimes = 0
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
      
        if !self.timetableLoaded {
            print(self.ditURL)
            let currentURL : NSString = (webView.request!.url?.absoluteString)! as NSString
            print(currentURL)
        
            if currentURL as String != self.ditURL && loginTimes == 0 {
                print("loading password")
                let loadUsernameJS = "document.getElementsByName(\"j_username\")[0].value = \"\(studentID)\";"
                let loadPasswordJS = "document.getElementsByName(\"j_password\")[0].value = \"\(studentPass)\";"
            
                webView.stringByEvaluatingJavaScript(from: loadUsernameJS)
                webView.stringByEvaluatingJavaScript(from: loadPasswordJS)
            
            
                //submit form
                let deadlineTime = DispatchTime.now() + .seconds(5)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                    webView.stringByEvaluatingJavaScript(from: "document.forms[0].submit();")
                    self.loginTimes = 1
                }
            } else if currentURL as String == self.ditURL {
                print(currentURL)
                self.timetableLoaded = true
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(20)) {
                    let doc = webView.stringByEvaluatingJavaScript(from: "document.body.innerHTML")
                    self.sendRawTimetable(data: doc!)
                }
            }
    
            if ( loginTimes != 0 && currentURL as String == self.ditAuthn ) {
            
                self.ditWebView.stopLoading()
                self.actInd!.stopAnimating()
                let message = "Your credentials are incorrect. Try again"
                self.showIncorrectCred(message: message)
            }
        }
    }
    
    func changeGIF() {
        self.gifImage.image = UIImage.gifImageWithURL(gifUrl: String(describing: self.gifURLs.randomValue()))
    }
    
    func showActivityIndicatory(uiView: UIView) {
        
        let loadingMessage: UILabel = UILabel()
        loadingMessage.frame = CGRect(x: 0, y: 0, width: uiView.bounds.width, height: 50)
        let message = "Retrieving your timetable\n This may take a while...."
        loadingMessage.text = message
        loadingMessage.lineBreakMode = NSLineBreakMode.byWordWrapping
        loadingMessage.numberOfLines = 2
        loadingMessage.textAlignment = .center
        loadingMessage.center = CGPoint(x: uiView.bounds.width/2, y: 70)
        loadingMessage.textColor = UIColor.white
        
        let cancelButton : UIButton = UIButton()
        cancelButton.frame = CGRect(x: 0, y: 0, width: uiView.bounds.width / 3, height: 30)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(self.cancelLogin), for: .touchUpInside)
        cancelButton.center = CGPoint(x: uiView.bounds.width/2, y: uiView.bounds.height - 50)
        cancelButton.setTitleColor(.red, for: .normal)
        
        let imageURL = UIImage.gifImageWithURL(gifUrl: String(describing: self.gifURLs.randomValue()))
        
        //let gifImage : UIImageView = UIImageView()
        self.gifImage.frame = CGRect(x: 0, y: 0, width: uiView.bounds.width - 20, height: uiView.bounds.width - 20)
        self.gifImage.center = uiView.center
        self.gifImage.image = imageURL
        
        
        let container: UIView = UIView()
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor.lightGray
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = CGPoint(x: uiView.bounds.width/2, y: 60)
        loadingView.backgroundColor = UIColor.lightText
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        self.actInd = UIActivityIndicatorView()
        self.actInd!.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        self.actInd!.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        self.actInd!.center = CGPoint(x: loadingView.frame.size.width / 2,
                                y: loadingView.frame.size.width / 2)
        //loadingView.addSubview(self.actInd!)
        container.addSubview(loadingMessage)
        container.addSubview(self.gifImage)
        container.addSubview(cancelButton)
        //container.addSubview(loadingView)
        uiView.addSubview(container)
        self.actInd!.startAnimating()
    }
    
    func cancelLogin() {
        self.timetableLoaded = true
        self.ditWebView.stopLoading()
        //self.actInd!.stopAnimating()
        self.performSegue(withIdentifier: "unwindLogin", sender: self)
    }
    
    func sendRawTimetable(data:String) {
        // Correct url and username/password
        let values = Bundle.contentsOfFile(plistName: "Settings.plist")
        let networkURL = values["URL"]! as! String //= Bundle.main.object(forInfoDictionaryKey: "url") as! String
        var dic = [String: String]()
        dic["myTimetable"] = data
        dic["user"] = studentID
        print(networkURL)
        HTTPConnection.httpRequest(params: dic, url: networkURL, httpMethod: "POST") { (succeeded: Bool, data: NSData) -> () in
            // Move to the UI thread
            
            DispatchQueue.main.async {
                if (!succeeded) {
                    let alert = UIAlertController(title: "Oops!", message:"No data found", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { _ in
                        self.actInd?.stopAnimating()
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true){
                    }
                    
                } else {
                    self.actInd!.stopAnimating()
                    
                    if !HTTPConnection.parseJSONAndSave(data: data) {
                        let message = "No classes found! Go to DIT Timetable website and add your modules then try again"
                        self.showIncorrectCred(message: message)
                    } else {
                        self.performSegue(withIdentifier: "backSegue", sender: self)
                    }
                    
                }

            }
            
        }
        
    }
    
    func showIncorrectCred( message: String ) {
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.actInd!.stopAnimating()
            self.performSegue(withIdentifier: "unwindLogin", sender: self)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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

