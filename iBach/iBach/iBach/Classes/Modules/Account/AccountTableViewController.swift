//
//  File.swift
//  iBach
//
//  Created by Nikola on 01/12/2018.
//  Copyright © 2018 Petar Jedek. All rights reserved.
//

import Foundation
import UIKit
import Unbox

class AccountTableViewController: UITableViewController {
    
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldFirstname: UITextField!
    @IBOutlet weak var textFieldLastname: UITextField!
    @IBOutlet weak var labelModifyDataDescription: UILabel!
    @IBOutlet weak var buttonSaveChanges: UIButton!
    @IBOutlet weak var buttonResetChanges: UIButton!
    
    var username: String = ""
    var email: String = ""
    var firstname: String = ""
    var lastname: String = ""
    var usernameIsEdited: Bool = false
    var emailIsEdited: Bool = false
    var firstnameIsEdited: Bool = false
    var lastnameIsEdited: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UserDefaults.standard.integer(forKey: "user_id") > 0) {
            getUserData(id: UserDefaults.standard.integer(forKey: "user_id"))
        }
        labelModifyDataDescription.isHidden = false
        buttonSaveChanges.isHidden = true
        buttonResetChanges.isHidden = true
    }
    
    @IBAction func usernameEdited(_ sender: Any) {
        if (username == textFieldUsername.text)
        {
            usernameIsEdited = false
        }
        else{
            usernameIsEdited = true
        }
        showOrHideSaveButton()
    }
    @IBAction func firstnameEdited(_ sender: Any) {
        if(firstname == textFieldFirstname.text)
        {
            firstnameIsEdited = false
        }
        else
        {
            firstnameIsEdited = true
        }
        showOrHideSaveButton()
    }
    @IBAction func emailEdited(_ sender: Any) {
        if(email == textFieldEmail.text)
        {
            emailIsEdited = false        }
        else
        {
            emailIsEdited = true
        }
        showOrHideSaveButton()
    }
    @IBAction func lastnameEdited(_ sender: Any) {
        if(lastname == textFieldLastname.text)
        {
            lastnameIsEdited = false        }
        else
        {
            lastnameIsEdited = true
        }
        showOrHideSaveButton()
    }
    
    private func showOrHideSaveButton()
    {
        if (usernameIsEdited || emailIsEdited || firstnameIsEdited || lastnameIsEdited)
        {
            DispatchQueue.main.async
            {
                self.labelModifyDataDescription.isHidden = true
                self.buttonSaveChanges.isHidden = false
                self.buttonResetChanges.isHidden = false
            }
        }
        else{
            DispatchQueue.main.async{
                self.labelModifyDataDescription.isHidden = false
                self.buttonSaveChanges.isHidden = true
                self.buttonResetChanges.isHidden = true
            }
        }
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

            if(accountName){
                DispatchQueue.main.async {
                    self.textFieldUsername.text = userData.username
                    self.textFieldEmail.text = userData.email
                    self.textFieldFirstname.text = userData.firstName
                    self.textFieldLastname.text = userData.lastName
                }
                username = userData.username
                email = userData.email!
                firstname = userData.firstName!
                lastname = userData.lastName!
            }
            else{
                DispatchQueue.main.async {
                    self.textFieldUsername.text = userData.username
                    self.textFieldEmail.text = userData.email
                    if(userData.firstName!.isEmpty && !userData.lastName!.isEmpty){
                        self.textFieldFirstname.text = ""
                        self.textFieldLastname.text = userData.lastName
                    }
                    else if(!userData.firstName!.isEmpty && userData.lastName!.isEmpty){
                        self.textFieldFirstname.text = userData.firstName
                        self.textFieldLastname.text = ""
                    }
                    else{
                        self.textFieldFirstname.text = ""
                        self.textFieldLastname.text = ""
                    }
                }
                username = userData.username
                email = userData.email!
                firstname = userData.firstName!
                lastname = userData.lastName!
            }

        } catch {
            print("Unable to unbox")
        }
    }
}
