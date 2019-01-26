//
//  CreatePlaylistViewController.swift
//  iBach
//
//  Created by Nikola on 26/01/2019.
//  Copyright © 2019 Petar Jedek. All rights reserved.
//

import UIKit

class CreatePlaylistViewController: UIViewController {

    
    @IBOutlet weak var texfieldPlaylistName: UITextField!
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton.isEnabled = false
    }
    

}
