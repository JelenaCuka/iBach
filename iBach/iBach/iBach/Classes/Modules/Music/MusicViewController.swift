//
//  MusicViewController.swift
//  iBach
//
//  Created by Petar Jedek on 03.12.18.
//  Copyright © 2018 Petar Jedek. All rights reserved.
//

import NotificationCenter
import UIKit
import Unbox
import AlamofireImage
import AVKit
import AVFoundation

class MusicViewController: UIViewController {
    
    @IBOutlet var miniPlayerView: UIView!
    @IBOutlet var imageCoverArt: UIImageView!
    @IBOutlet var labelSongTitle: UILabel!
    @IBOutlet var labelAuthor: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shuffleImage = UIImage(named: "Shuffle Navigation Icon")
        
        let buttonPlay = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play, target: self, action: "someAction")
        let buttonShuffle = UIBarButtonItem(image: shuffleImage, style: .plain, target: self, action: "action")
        
        navigationItem.rightBarButtonItems = [buttonPlay, buttonShuffle]
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search

        NotificationCenter.default.addObserver(self, selector: #selector(displayMiniPlayer(notification:)), name: NSNotification.Name(rawValue: "displayMiniPlayer"), object: nil)
        
    }
    
    @objc func displayMiniPlayer(notification: NSNotification) {
        self.miniPlayerView.isHidden = false
        self.labelSongTitle.text = notification.userInfo!["title"]! as? String
        self.labelAuthor.text = notification.userInfo!["author"]! as? String
        
        if let imageURL = URL(string: (notification.userInfo!["cover_art"]! as? String)!) {
            let color: UIColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.4)
            
            self.imageCoverArt.layer.cornerRadius = 3
            self.imageCoverArt.clipsToBounds = true
            self.imageCoverArt.layer.borderWidth = 0.5
            self.imageCoverArt.layer.borderColor = color.cgColor
            self.imageCoverArt.af_setImage(withURL: imageURL)
        }
        
        let miniPlayerTap = UITapGestureRecognizer(target: self, action: #selector(self.openLargePlayer(_:)))
        
        self.miniPlayerView.addGestureRecognizer(miniPlayerTap)
        self.miniPlayerView.isUserInteractionEnabled = true
    }
    
    @objc func openLargePlayer(_ sender: UITapGestureRecognizer) {
        //largePlayerViewController.labelSongTitle.text
        let storyoard = UIStoryboard(name: "Music", bundle: nil)
        guard let largePlayerViewController = storyoard.instantiateViewController(withIdentifier: "Large Player") as? LargePlayerViewController else {
            return
        }
        largePlayerViewController.modalPresentationStyle = .fullScreen
        
        self.present(largePlayerViewController, animated: true, completion: nil)
    }
    
}

extension MusicViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}
