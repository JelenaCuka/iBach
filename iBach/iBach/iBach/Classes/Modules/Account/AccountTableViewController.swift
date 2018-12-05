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
import Alamofire

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
    
    @IBAction func usernameEdited(_ sender: Any?) {
        if (username == textFieldUsername.text)
        {
            usernameIsEdited = false
        }
        else{
            usernameIsEdited = true
        }
        showOrHideSaveAndResetButton()
    }
    @IBAction func firstnameEdited(_ sender: Any?) {
        if(firstname == textFieldFirstname.text)
        {
            firstnameIsEdited = false
        }
        else
        {
            firstnameIsEdited = true
        }
        showOrHideSaveAndResetButton()
    }
    @IBAction func emailEdited(_ sender: Any?) {
        if(email == textFieldEmail.text)
        {
            emailIsEdited = false        }
        else
        {
            emailIsEdited = true
        }
        showOrHideSaveAndResetButton()
    }
    @IBAction func lastnameEdited(_ sender: Any?) {
        if(lastname == textFieldLastname.text)
        {
            lastnameIsEdited = false        }
        else
        {
            lastnameIsEdited = true
        }
        showOrHideSaveAndResetButton()
    }
    
    private func showOrHideSaveAndResetButton()
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
    
    @IBAction func resetChanges(_ sender: Any?) {
        DispatchQueue.main.async {
            self.textFieldUsername.text = self.username
            self.textFieldEmail.text = self.email
            self.textFieldFirstname.text = self.firstname
            self.textFieldLastname.text = self.lastname
        }
        usernameIsEdited = false
        emailIsEdited = false
        firstnameIsEdited = false
        lastnameIsEdited = false
        showOrHideSaveAndResetButton()
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
    
    @IBAction func updateAccountData(_ sender: Any)
    {
        if (textFieldUsername.text!.isEmpty || textFieldEmail.text!.isEmpty) {
            
            DispatchQueue.main.async {
                self.printAlert(title: "Required fields", message: "Username and email are required fields.")
            }
            
        } else {
            
            let parameters: Parameters = [
                "id": UserDefaults.standard.integer(forKey: "user_id"),
                "username": textFieldUsername.text!,
                "email": textFieldEmail.text!,
                "first_name": textFieldFirstname.text!,
                "last_name": textFieldLastname.text!
            ]
            
            Alamofire.request("https://botticelliproject.com/air/api/user/update.php", method: .post, parameters: parameters).responseJSON(completionHandler: { (response) in
                
                guard response.result.error == nil else {
                    
                    print("error calling POST")
                    print(response.result.error!)
                    return
                }
                
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get object as JSON from API")
                    if let error = response.result.error {
                        print("Error: \(error)")
                    }
                    return
                }
                
                guard let message = json["message"] as? String else {
                    print("Could not get message from JSON")
                    return
                }
                print(message)
                
                switch message {
                case "Data inserted":
                    print(message)
                    self.getUserData(id: UserDefaults.standard.integer(forKey: "user_id"))
                    DispatchQueue.main.async
                    {
                        self.printAlert(title: "Account information updated", message: "You have successfully updated account information.")
                    }
                    self.resetChanges(nil)
                case "User updated":
                    print(message)
                case "User failed to update":
                    print(message)
                case "Data is not inserted":
                    print(message)
                case "Username, id or email of user is not set or is empty":
                    print(message)
                case "That username is already taken":
                    print(message)
                    DispatchQueue.main.async
                    {
                        self.printAlert(title: "Update Failed", message: "Username \(self.textFieldUsername.text!) is already taken.")
                    }
                case "Unexpected error":
                    print(message)
                default:
                    print(message)
                }
            })
        }
    }
    
    private func printAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
