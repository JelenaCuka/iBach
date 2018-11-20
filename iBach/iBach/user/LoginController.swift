//
//  LoginController.swift
//  iBach
//
//  Created by Petar Jedek on 06.11.18.
//  Copyright © 2018 Petar Jadek. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    @IBOutlet var textFieldUsername: UITextField!
    @IBOutlet var textFieldPassword: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    
    @IBAction func btnlogin(_ sender: Any) {
    
        let username = textFieldUsername.text!
        let password = textFieldPassword.text!.hash
        print(password)

        let url = URL(string: "http://botticelliproject.com/air/api/user/login.php");
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        let postString = "login=1&username=\(username)&password=\(password)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print("Error: \(String(describing: error))")
                return
            }
            
            print("Response: \(String(describing: response))")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    let logged = parseJSON["description"] as? String
                    print(logged)
                    
                    if (logged == "Login successful") {

                            UserDefaults.standard.set(true, forKey: "status")
                            Switcher.updateRootViewController()
                            
                        
                    }
                    
                    else if (logged == "Wrong password.") {
                        print("Wrong password.")
                    }
                    
                    else {
                        //self.labelFieldStatus.text = "Username is incorrect"
                    }
                    
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    override func viewDidLoad() {
        buttonLogin.layer.cornerRadius = 10
        buttonLogin.clipsToBounds = true
        textFieldPassword.layer.cornerRadius = 10
        textFieldPassword.clipsToBounds = true
        textFieldUsername.layer.cornerRadius = 10
        textFieldUsername.clipsToBounds = true
        super.viewDidLoad()
    }
    
}
