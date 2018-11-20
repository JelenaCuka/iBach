//
//  RegistrationController.swift
//  iBach
//
//  Created by Petar Jedek on 19.11.18.
//  Copyright © 2018 Petar Jedek. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textFieldUsername: UITextField!
    @IBOutlet var textFieldPassword: UITextField!
    @IBOutlet var textFieldRepeatPassword: UITextField!
    @IBOutlet var textFieldFirstName: UITextField!
    @IBOutlet var textFieldLastName: UITextField!
    @IBOutlet var textFieldEmail: UITextField!
    @IBOutlet weak var buttonRegister: UIButton!
    

    @IBOutlet weak var labelStatusMessage: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldUsername.layer.cornerRadius = 10
        textFieldPassword.layer.cornerRadius = 10
        textFieldRepeatPassword.layer.cornerRadius = 10
        textFieldFirstName.layer.cornerRadius = 10
        textFieldLastName.layer.cornerRadius = 10
        textFieldEmail.layer.cornerRadius = 10
        buttonRegister.layer.cornerRadius = 10
        
        textFieldUsername.clipsToBounds = true
        textFieldPassword.clipsToBounds = true
        textFieldRepeatPassword.clipsToBounds = true
        textFieldFirstName.clipsToBounds = true
        textFieldLastName.clipsToBounds = true
        textFieldEmail.clipsToBounds = true
        
        textFieldUsername.delegate = self
        textFieldPassword.delegate = self
        textFieldRepeatPassword.delegate = self
        textFieldFirstName.delegate = self
        textFieldLastName.delegate = self
        textFieldEmail.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func registerNewUser(_ sender: Any) {
        
        let userDataEntered = self.checkIfCrucialUserDataIsNotEmpty()
        
        if (!userDataEntered) {
            DispatchQueue.main.async {
                self.labelStatusMessage.isHidden = false
                self.labelStatusMessage.text = "User data not enetered..."
            }
        } else {
            
            DispatchQueue.main.async {
                self.labelStatusMessage.isHidden = true
            }
            
            let passwordsMatch = self.checkIfPasswordsMatch()
            
            if (!passwordsMatch) {
                
                DispatchQueue.main.async {
                    self.labelStatusMessage.isHidden = false
                    self.labelStatusMessage.text = "Passwords do not mactch"
                }
                
            } else {
                
                DispatchQueue.main.async {
                    self.labelStatusMessage.isHidden = true
                }
                
                self.register()
    
            }
            
        }
        
    }
    
    func checkIfCrucialUserDataIsNotEmpty() -> Bool {
        
        if (textFieldUsername.text!.isEmpty || textFieldPassword.text!.isEmpty || textFieldRepeatPassword.text!.isEmpty) {
            return false
        }
        
        return true
    }
    
    func checkIfPasswordsMatch() -> Bool {
        
        if (textFieldPassword.text! == textFieldRepeatPassword.text!) {
            return true
        }
    
        return false
    }
    
    func register() {
        
    }
    
}
