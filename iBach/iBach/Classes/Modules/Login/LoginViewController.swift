//
//  LoginViewController.swift
//  iBach
//
//  Created by Petar Jedek on 22.11.18.
//  Copyright © 2018 Petar Jedek. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var textFieldUsername: UITextField!
    @IBOutlet var textFieldPassword: UITextField!
    
    @IBOutlet var buttonLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        let scrollViewBounds = scrollView.bounds
        let containerViewBounds = contentView.bounds
        
        var scrollViewInsets = UIEdgeInsets.zero
        scrollViewInsets.top = scrollViewBounds.size.height / 2.0
        scrollViewInsets.top -= contentView.bounds.size.height / 2.0
        
        scrollViewInsets.bottom  = scrollViewBounds.size.height/2.0
        scrollViewInsets.bottom -= contentView.bounds.size.height/2.0
        scrollViewInsets.bottom += 1
        
        scrollView.contentInset = scrollViewInsets
        
    }
    
    @IBAction func loginUser(_ sender: Any) {
        
        if (textFieldUsername.text!.isEmpty || textFieldPassword.text!.isEmpty) {
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Information required", message: "Please submit all input fields before submitting the form.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }
            
        } else {
            let username = textFieldUsername.text!
            let password = textFieldPassword.text!.hash
            
            print("Params: \(username) and \(password)")
        }
        
    }
    

}
