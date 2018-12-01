//
//  AccountViewController.swift
//  iBach
//
//  Created by Petar Jedek on 24.11.18.
//  Copyright © 2018 Petar Jedek. All rights reserved.
//

import Foundation
import UIKit
import Unbox

class AccountViewController: UIViewController, UITextFieldDelegate {
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        if (UserDefaults.standard.integer(forKey: "user_id") > 0) {
            //getUserData(id: UserDefaults.standard.integer(forKey: "user_id"))
        }
        
        super.viewDidLoad()
    }
    
    
    private func getUserData(id: Int) {
        print("retriving data... from id:\(id)")
        
        HTTPRequest().sendGetRequest(urlString: "http://botticelliproject.com/air/api/user/findone.php?id=\(id)", completionHandler: {(response, error) in

            if let serverResponse = response as? [String : Any]  {
                self.processAndDisplayUserData(serverResponse["data"] as! [String : Any])
            }
        })
    }
    
    private func processAndDisplayUserData(_ data: [String: Any]) {
        do {
            let userData: User = try unbox(dictionary: data)
            
            var accountName: Bool = false
            if (!userData.firstName!.isEmpty && !userData.lastName!.isEmpty) {
                accountName = true
            }
            
            DispatchQueue.main.async {
               
            }
        } catch {
            print("Unable to unbox")
        }
    }
    
}
