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
    
    var buttonPlay: UIBarButtonItem?
    var buttonShuffle: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPlayingIcons()
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(changePlayPauseIcon(notification:)), name: NSNotification.Name(rawValue: "songIsPlaying"), object: nil)//
        
        NotificationCenter.default.addObserver(self, selector: #selector(changePlayPauseIcon(notification:)), name: NSNotification.Name(rawValue: "songIsPaused"), object: nil)//
        
    }
    
    @objc func playSongClick(_ sender: Any){
        playpause()
    }
    
    @objc func changePlayPauseIcon(notification: NSNotification) {
        setPlayingIcons()
    }
    
    @objc func shuffleClick(_ sender: Any){
        MusicPlayer.sharedInstance.shuffleOnOff()
    }
    
    func playpause() {
        if (!MusicPlayer.sharedInstance.playSong()) {
            MusicPlayer.sharedInstance.pauseSong()
        }
    }
    
    func setPlayingIcons() {
        if(MusicPlayer.sharedInstance.isPlaying() ){
            self.buttonPlay = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.pause, target: self, action: #selector(playSongClick))
        }else{
            self.buttonPlay = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play, target: self, action: #selector(playSongClick ))
        }
        self.buttonShuffle = UIBarButtonItem(image: UIImage(named: "Shuffle Navigation Icon"), style: .plain, target: self, action: #selector(shuffleClick))
        if let addButtonPlay = buttonPlay,let addButtonShuffle = buttonShuffle {
            navigationItem.rightBarButtonItems = [addButtonPlay , addButtonShuffle]
        }
    }
    
}

extension MusicViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}


