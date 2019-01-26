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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let recievedPlaylistName = playlistName {
            self.navigationItem.title = "Choose Songs"
            playlistNameLabel.text = "Choose at least one song for your new playlist \(recievedPlaylistName)"
        }
    }
    

}
