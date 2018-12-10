//
//  LargePlayerViewController.swift
//  iBach
//
//  Created by Petar Jedek on 06.12.18.
//  Copyright © 2018 Petar Jedek. All rights reserved.
//

import UIKit
import AlamofireImage
import NotificationCenter
import AVFoundation
import AVKit
import MediaPlayer

class LargePlayerViewController: UIViewController {
    /*
    @IBOutlet var labelSongTitle: UILabel!
    @IBOutlet var imageCoverArt: UIImageView!
    @IBOutlet var labelArtistAlbumYear: UILabel!
    
    @IBOutlet var butonPlay: UIButton!
    @IBOutlet var buttonPrevious: UIButton!
    @IBOutlet var buttonNext: UIButton!*/
    
    //@IBOutlet weak var labelSongTitle: UIImageView!
    
    @IBOutlet weak var labelSongTitle: UILabel!
    @IBOutlet weak var imageCoverArt: UIImageView!
    @IBOutlet weak var labelArtistAlbumYear: UILabel!
    
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonPrevious: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("load")
        let effect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = self.view.bounds
        self.view.addSubview(blurView)
        self.view.sendSubviewToBack(blurView)
        
        
        let screenEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.dismissLargePlayer(_:)))
        screenEdgeRecognizer.edges = .top
        view.addGestureRecognizer(screenEdgeRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayLargePlayer(notification:)), name: NSNotification.Name(rawValue: "displayMiniPlayer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(displayLargePlayer(notification:)), name: NSNotification.Name(rawValue: "displayLargePlayer"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(changePlayPauseIcon(notification:)), name: NSNotification.Name(rawValue: "songIsPlaying"), object: nil)//
        
        NotificationCenter.default.addObserver(self, selector: #selector(changePlayPauseIcon(notification:)), name: NSNotification.Name(rawValue: "songIsPaused"), object: nil)//
        
        
    }
    
    
    @objc func dismissLargePlayer(_ sender: UIScreenEdgePanGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func displayLargePlayer(notification: NSNotification) {
        loadData()
    }
    
    @IBAction func closeLargePlayer(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pauseSong(_ sender: Any) {
        if ( MusicPlayer.sharedInstance.playSong() ){
            NotificationCenter.default.post(name: .songIsPlaying, object: nil)
        }else if ( MusicPlayer.sharedInstance.pauseSong() ){
            NotificationCenter.default.post(name: .songIsPaused, object: nil)
        }
    }
    
    @IBAction func buttonNextClick(_ sender: Any) {
        if ( MusicPlayer.sharedInstance.nextSong() ) {
            loadData()
            NotificationCenter.default.post(name: .changedSong, object: nil)
        }
    }
    
    @IBAction func buttonPreviousClick(_ sender: Any) {
        if ( MusicPlayer.sharedInstance.previousSong() ) {
            NotificationCenter.default.post(name: .changedSong, object: nil)
            loadData()
        }
    }
    
    @objc func changePlayPauseIcon(notification: NSNotification) {
        changePlayPauseIcon()
    }
    
    func loadData(){
        self.labelSongTitle.text = MusicPlayer.sharedInstance.songData[MusicPlayer.sharedInstance.currentSongIndex].title
        
        if let imageURL = URL(string: MusicPlayer.sharedInstance.songData[MusicPlayer.sharedInstance.currentSongIndex].coverArtUrl) {
            self.imageCoverArt.layer.cornerRadius = 20
            self.imageCoverArt.clipsToBounds = true
            
            imageCoverArt.layer.shadowColor = UIColor.black.cgColor
            imageCoverArt.layer.shadowOpacity = 1
            imageCoverArt.layer.shadowOffset = CGSize.zero
            imageCoverArt.layer.shadowRadius = 50
            
            self.imageCoverArt.af_setImage(withURL: imageURL)
        }
        
        let artist: String = MusicPlayer.sharedInstance.songData[MusicPlayer.sharedInstance.currentSongIndex].author
        //let album: String = (notification.userInfo!["album"]! as? String)!
        let year: String = MusicPlayer.sharedInstance.songData[MusicPlayer.sharedInstance.currentSongIndex].year
        
        self.labelArtistAlbumYear.text = "\(artist) - \(year)"
        
        //
        NotificationCenter.default.addObserver(self, selector: #selector(displayLargePlayer(notification:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: MusicPlayer.sharedInstance.player?.currentItem)
    }
    
    func changePlayPauseIcon() {
        if ( MusicPlayer.sharedInstance.isPlaying() ){
            buttonPlay.setImage(UIImage(named: "Pause"), for: .normal)
        } else {
            buttonPlay.setImage(UIImage(named: "Play"), for: .normal)
        }
    }
}

extension Notification.Name{
    static let songIsPlaying = Notification.Name ("songIsPlaying")//icons
    static let songIsPaused = Notification.Name ("songIsPaused")//icons
    static let changedSong = Notification.Name ("changedSong")//updateInfo
}
