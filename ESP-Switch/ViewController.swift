//
//  ViewController.swift
//  iOS-Swift-UIButtonFromArray
//
//  Created by Shekar on 2020-10-01
//  Copyright © 2020 eshapathi.com. All rights reserved.
//  Inspired from https://github.com/soonin/iOS-Swift-UIButtonFromArray/blob/master/iOS-Swift-UIButtonFromArray/ViewController.swift
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var buttonsStack: UIStackView!
    var myButtonsArray : [String] = []
    
    var protocols = [String](repeating: "", count: 11)
    var hosts     = [String](repeating: "", count:11)
    var labels    = [String](repeating: "", count: 11)

    var switchPassword: String = ""

    func populateArrayFromSUserDefaults(){
        readFromPlistIntoMemory()
        //Get the defaults
        let defaults = UserDefaults.standard

        switchPassword = defaults.string(forKey: "SwitchPassword") ?? "Change_Me";print(switchPassword)
        if (switchPassword != "Change_Me") {
//            print (self.defaultPassword.text as Any)
//            self.defaultPassword.isHidden = true;
        }
        var host: String
        var httpProtocol: String
        
        httpProtocol = (defaults.bool(forKey: "http1") ? "https://" : "http://")
        host = (defaults.string(forKey: "address1") ?? "")
        host = (host != "") ? httpProtocol+host : ""
        hosts[0] = host
        
        httpProtocol = (defaults.bool(forKey: "http2") ? "https://" : "http://")
        host = (defaults.string(forKey: "address2") ?? "")
        host = (host != "") ? httpProtocol+host : ""
        hosts[1] = host
        
        httpProtocol = (defaults.bool(forKey: "http3") ? "https://" : "http://")
        host = (defaults.string(forKey: "address3") ?? "")
        host = (host != "") ? httpProtocol+host : ""
        hosts[2] = host
        
        httpProtocol = (defaults.bool(forKey: "http4") ? "https://" : "http://")
        host = (defaults.string(forKey: "address4") ?? "")
        host = (host != "") ? httpProtocol+host : ""
        hosts[3] = host
        
        httpProtocol = (defaults.bool(forKey: "http5") ? "https://" : "http://")
        host = (defaults.string(forKey: "address5") ?? "")
        host = (host != "") ? httpProtocol+host : ""
        hosts[4] = host
        
        httpProtocol = (defaults.bool(forKey: "http6") ? "https://" : "http://")
        host = (defaults.string(forKey: "address6") ?? "")
        host = (host != "") ? httpProtocol+host : ""
        hosts[5] = host
        
        httpProtocol = (defaults.bool(forKey: "http7") ? "https://" : "http://")
        host = (defaults.string(forKey: "address7") ?? "")
        host = (host != "") ? httpProtocol+host : ""
        hosts[6] = host
        
        labels[0]=defaults.string(forKey: "name1") ?? ""
        labels[1]=defaults.string(forKey: "name2") ?? ""
        labels[2]=defaults.string(forKey: "name3") ?? ""
        labels[3]=defaults.string(forKey: "name4") ?? ""
        labels[4]=defaults.string(forKey: "name5") ?? ""
        labels[5]=defaults.string(forKey: "name6") ?? ""
        labels[6]=defaults.string(forKey: "name7") ?? ""
    }
    
    @objc func appMovedToForeground() {
        print("Inside appMovedToForeground()")
        populateArrayFromSUserDefaults()
        for item in buttonsStack.arrangedSubviews {
            buttonsStack.removeArrangedSubview(item)
        }
        for index in 0...6 {
            if ((hosts[index] != "") && (labels[index] != "")) {
                let button = MyButton(index: index, buttonLabel: labels[index], url: hosts[index], switchPassword: switchPassword)
                buttonsStack.addArrangedSubview(button)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
        populateArrayFromSUserDefaults()

        for index in 0...6 {
            let button = MyButton(index: index, buttonLabel: labels[index], url: hosts[index], switchPassword: switchPassword)
            buttonsStack.addArrangedSubview(button)
        }
    } //End ViewDidload
}

func readFromPlistIntoMemory() {
    print("Inside readFromPlistIntoMemory()")
    let settingsName                    = "Settings"
    let settingsExtension               = "bundle"
    let settingsRootPlist               = "Root.plist"
    let settingsPreferencesItems        = "PreferenceSpecifiers"
    let settingsPreferenceKey           = "Key"
    let settingsPreferenceDefaultValue  = "DefaultValue"

    guard let settingsBundleURL = Bundle.main.url(forResource: settingsName, withExtension: settingsExtension),
        let settingsData = try? Data(contentsOf: settingsBundleURL.appendingPathComponent(settingsRootPlist)),
        let settingsPlist = try? PropertyListSerialization.propertyList(
            from: settingsData,
            options: [],
            format: nil) as? [String: Any],
        let settingsPreferences = settingsPlist?[settingsPreferencesItems] as? [[String: Any]] else {
            return
    }

    var defaultsToRegister = [String: Any]()

    settingsPreferences.forEach { preference in
        if let key = preference[settingsPreferenceKey] as? String {
            defaultsToRegister[key] = preference[settingsPreferenceDefaultValue]
        }
    }

    UserDefaults.standard.register(defaults: defaultsToRegister)
}
