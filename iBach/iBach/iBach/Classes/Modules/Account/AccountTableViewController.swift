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
    
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelFirstName: UILabel!
    @IBOutlet weak var labelLastName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UserDefaults.standard.integer(forKey: "user_id") > 0) {
            getUserData(id: UserDefaults.standard.integer(forKey: "user_id"))
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
                    self.labelUserName.text = userData.username
                    self.labelEmail.text = userData.email
                    self.labelFirstName.text = userData.firstName
                    self.labelLastName.text = userData.lastName
                }
            }
            else{
                DispatchQueue.main.async {
                    self.labelUserName.text = userData.username
                    self.labelEmail.text = userData.email
                    if(userData.firstName!.isEmpty && !userData.lastName!.isEmpty){
                        self.labelFirstName.text = "bez podataka"
                        self.labelFirstName.isEnabled = false
                        self.labelLastName.text = userData.lastName
                    }
                    else if(!userData.firstName!.isEmpty && userData.lastName!.isEmpty){
                        self.labelFirstName.text = userData.firstName
                        self.labelLastName.text = "bez podataka"
                        self.labelLastName.isEnabled = false
                    }
                    else{
                        self.labelFirstName.text = "bez podataka"
                        self.labelFirstName.isEnabled = false
                        self.labelLastName.text = "bez podataka"
                        self.labelLastName.isEnabled = false
                    }
                }
            }
            
        } catch {
            print("Unable to unbox")
        }
    }
}
