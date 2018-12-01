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
        
        labelUserName.text = "korisnicko ime"
        labelEmail.text = "email"
        labelFirstName.text = "ime"
        labelLastName.text = "prezime"
    }
    
}
