//
//  ChooseSongsViewController.swift
//  iBach
//
//  Created by Nikola on 26/01/2019.
//  Copyright © 2019 Petar Jedek. All rights reserved.
//

import UIKit

class ChooseSongsViewController: UIViewController {

    var playlistName:String?
    
    @IBOutlet weak var playlistNameLabel: UILabel!
    
    @IBOutlet weak var buttonAdd: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        buttonAdd.isEnabled = false
    }
    
    

}
