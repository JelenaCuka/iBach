//
//  RootView.swift
//  iBach
//
//  Created by Petar Jadek on 15/01/2019.
//  Copyright © 2019 Petar Jedek. All rights reserved.
//

import UIKit
import Foundation

class RootViewController: UIViewController  {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bottomConstraint.constant = self.tabBarController?.view.frame.height ?? 64.0
        self.view.layoutIfNeeded()
    }
    
}
