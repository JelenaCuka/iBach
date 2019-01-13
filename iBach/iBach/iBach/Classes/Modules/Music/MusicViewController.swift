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
    
    fileprivate var largePlayerViewController: LargePlayerViewController!
    
    var buttonPlay: UIBarButtonItem?
    var buttonShuffle: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPlayingIcons()
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayMiniPlayer(notification:)), name: NSNotification.Name(rawValue: "displayMiniPlayer"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMiniPlayerData(notification:)), name: NSNotification.Name(rawValue: "changedSong"), object: nil)//
        
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
    
    @objc func displayMiniPlayer(notification: NSNotification) {
        self.miniPlayerView.isHidden = false
        
        reloadMiniPlayerData()
        //NotificationCenter.default.post(name: .displayLargePlayer, object: nil)
        let miniPlayerTap = UITapGestureRecognizer(target: self, action: #selector(self.openLargePlayer(_:) ))
        
        self.miniPlayerView.addGestureRecognizer(miniPlayerTap)
        self.miniPlayerView.isUserInteractionEnabled = true
        
        setPlayingIcons()
    }
    
    @objc func reloadMiniPlayerData(notification: NSNotification) {
        reloadMiniPlayerData()
    }
    
    func playpause() {
        if (!MusicPlayer.sharedInstance.playSong()) {
            MusicPlayer.sharedInstance.pauseSong()
        }
    }
    
    func setPlayingIcons() {
        if(MusicPlayer.sharedInstance.isPlaying() ){
            self.buttonPlay = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.pause, target: self, action: #selector(playSongClick) )
        }else{
            self.buttonPlay = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play, target: self, action: #selector(playSongClick ))
        }
        self.buttonShuffle = UIBarButtonItem(image: UIImage(named: "Shuffle Navigation Icon"), style: .plain, target: self, action: #selector(shuffleClick))
        if let addButtonPlay = buttonPlay,let addButtonShuffle = buttonShuffle {
            navigationItem.rightBarButtonItems = [addButtonPlay , addButtonShuffle]
        }
    }
    
    func reloadMiniPlayerData(){
        self.labelSongTitle.text = MusicPlayer.sharedInstance.songData[MusicPlayer.sharedInstance.currentSongIndex].title
        self.labelAuthor.text = MusicPlayer.sharedInstance.songData[MusicPlayer.sharedInstance.currentSongIndex].author
        
        if let imageURL = URL(string: MusicPlayer.sharedInstance.songData[MusicPlayer.sharedInstance.currentSongIndex].coverArtUrl ) {
            let color: UIColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.4)
            
            self.imageCoverArt.layer.cornerRadius = 3
            self.imageCoverArt.clipsToBounds = true
            self.imageCoverArt.layer.borderWidth = 0.5
            self.imageCoverArt.layer.borderColor = color.cgColor
            self.imageCoverArt.af_setImage(withURL: imageURL)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMiniPlayerData(notification:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: MusicPlayer.sharedInstance.player?.currentItem)
    }
    
    @objc func openLargePlayer(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Music", bundle: nil)
        let largePleyer = storyboard.instantiateViewController(withIdentifier: "Large Player") as! LargePlayerViewController

        //largePleyer.labelSongTitle.text = "test"
        
        DispatchQueue.main.async {
            self.present(largePleyer, animated: true, completion: nil)
        }

        
    }
    
}

extension MusicViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}

extension Notification.Name{
    static let displayLargePlayer = Notification.Name ("displayLargePlayer")//icons
}
