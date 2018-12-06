//
//  SettingsViewController.swift
//  iBach
//
//  Created by Neven Travas on 01/12/2018.
//  Copyright © 2018 Petar Jedek. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
        
    @IBAction func themeSegmentedControllChanged(_ sender: UISegmentedControl) {
        
        let theme: Theme
        
        switch sender.selectedSegmentIndex {
        case 1: theme = DarkTheme()
        //case 2: theme = OceanTheme()
        default: theme = LightTheme()
        }
        
        theme.apply(for: UIApplication.shared)
    }
}
    
    
        
       


