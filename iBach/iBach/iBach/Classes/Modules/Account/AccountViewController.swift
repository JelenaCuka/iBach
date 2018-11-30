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
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var txtFieldUsername: UITextField!
    @IBOutlet var textFieldEmail: UITextField!
    @IBOutlet var textFieldFirstName: UITextField!
    @IBOutlet var textfieldLastName: UITextField!
    
    
    @IBOutlet var buttonLogout: UIButton!
    
    
    @IBAction func logoutUser(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "status")
        Switcher.updateRootViewController()
    }
    
    
    override func viewDidLoad() {
        if (UserDefaults.standard.integer(forKey: "user_id") > 0) {
            getUserData(id: UserDefaults.standard.integer(forKey: "user_id"))
        }
        
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        let scrollViewBounds = scrollView.bounds
        let containerViewBounds = contentView.bounds
        
        var scrollViewInsets = UIEdgeInsets.zero
        scrollViewInsets.top = scrollViewBounds.size.height / 2.0
        scrollViewInsets.top -= contentView.bounds.size.height / 2.0
        
        scrollViewInsets.bottom = scrollViewBounds.size.height / 2.0
        scrollViewInsets.bottom -= contentView.bounds.size.height / 2.0
        scrollViewInsets.bottom += 1
        
        scrollView.contentInset = scrollViewInsets
    }
    
    private func getUserData(id: Int) {
        print("retriving data... from id:\(id)")
        
        HTTPRequest().sendGetRequest(urlString: "http://botticelliproject.com/air/api/user/findone.php?id=\(id)", completionHandler: {(response, error) in
            let serverResponse: [String: Any] = response!["data"]! as! [String: Any]
            self.processAndDisplayUserData(serverResponse)
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
                self.txtFieldUsername.text = userData.username
                self.textFieldEmail.text = userData.email!
                self.textFieldFirstName.text = userData.firstName!
                self.textfieldLastName.text = userData.lastName!
                
            }
        } catch {
            print("Unable to unbox")
        }
    }
    
}
