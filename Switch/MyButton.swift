//
//  MyButton.swift
//  IOT
//
//  Created by Lakshmipathi, Shekar on 5/27/18.
//  Copyright © 2018 Lakshmipathi, Shekar. All rights reserved.
//
import UIKit
import AVFoundation

@IBDesignable class MyButton: UIButton
{
    var v_host: String = ""
    var v_label: String = ""
    var currentState: String = "-1"
    let defaults = UserDefaults.standard
    var switchPassword: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        }

    // setup via Storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupButtonStyle(index: Int, buttonLabel: String, url: String, switchPassword: String) {
        self.v_host = url
        self.switchPassword = switchPassword
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 20
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 2.0

        backgroundColor         = UIColor.orange
        titleLabel?.font        = UIFont(name: "Courier", size: 30)
        setTitle(buttonLabel, for: .normal)
        v_label = buttonLabel
        setTitleColor(UIColor.black, for: .normal)
        tag = index

        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center

//        setImage(UIImage(named: "btnArrowRight"), for: .normal)
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
        longGesture.minimumPressDuration = 0.9
        self.addGestureRecognizer(longGesture)
        self.showsTouchWhenHighlighted = true
        
        updateLabel()
    }
    
    required init (index: Int, buttonLabel: String, url: String, switchPassword: String) {
        self.init()
        setupButtonStyle(index: index+1, buttonLabel: buttonLabel, url: url, switchPassword: switchPassword)
    }

    func takeActionForButtonPressed() {
        var myURL: String = self.v_host
        if (currentState == "1") {
            myURL = myURL + "/off"
        }
        else if (currentState == "0") {
            myURL = myURL + "/on"
        }
        makeHttpRequest(postURL: myURL)
    }

    func updateLabel() {
        if (v_host != "") { // so not update by making a GET, if no IP is present
            let myURL: String = v_host + "/state"
            makeHttpRequest(postURL: myURL)
        }
    }  // END   func updateLabel()

    func makeHttpRequest(postURL: String) {
        print("Making a request to " + postURL)
        var returnedSwitchStatus: String = "-1"
        var request = URLRequest(url: URL(string: postURL)!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        request.setValue(switchPassword, forHTTPHeaderField: "secret")
        session.dataTask(with: request) {data, response, error in
            DispatchQueue.main.async {
                if error != nil || data == nil {
                    self.setTitle(self.v_label + " 💊CErr", for: .normal)
                    self.backgroundColor = UIColor.errorColor;
                    return
                }
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    self.setTitle(self.v_label + " 😫!200", for: .normal)
                    self.backgroundColor = UIColor.errorColor;
                    return
                }
                if let data = data {
                    returnedSwitchStatus = String(data: data, encoding: String.Encoding.utf8)!
                    self.currentState = returnedSwitchStatus
//                    print(self.v_label + "  " +  returnedSwitchStatus);
                    self.setTitle(self.v_label, for: .normal)
                    if (returnedSwitchStatus == "0") {
                        self.backgroundColor = UIColor.offColor;
                    }
                    if (returnedSwitchStatus == "1") {
                        self.backgroundColor = UIColor.onColor;
                    }
                }
            }  // Outer dispatch
        }.resume()
    }  // END

    @objc func longTap(_ sender: UIGestureRecognizer){
//        print("longtap")
        if sender.state == .ended {
            takeActionForButtonPressed();
        }
        else if sender.state == .began {
            //Do Whatever You want on Began of Gesture
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    }
}
