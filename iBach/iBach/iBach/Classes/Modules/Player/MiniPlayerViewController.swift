//
//  MiniPlayerViewController.swift
//  iBach
//
//  Created by Petar Jadek on 15/01/2019.
//  Copyright © 2019 Petar Jedek. All rights reserved.
//

import UIKit
import Foundation
import NotificationCenter

class MiniPlayerViewController: UIViewController {

    
    @IBOutlet var miniPlayerView: UIView!
    @IBOutlet weak var labelSongTitle: UILabel!
    @IBOutlet weak var imageCoverArt: UIImageView!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var styledView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(displayMiniPlayer(notification:)), name: NSNotification.Name(rawValue: "displayMiniPlayer"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMiniPlayerData(notification:)), name: NSNotification.Name(rawValue: "changedSong"), object: nil)
        
        
        
    }
    
    @objc func displayMiniPlayer(notification: NSNotification) {
        self.miniPlayerView.isHidden = false
        
        reloadMiniPlayerData()
        //NotificationCenter.default.post(name: .displayLargePlayer, object: nil)
        let miniPlayerTap = UITapGestureRecognizer(target: self, action: #selector(self.openLargePlayer(_:) ))
        
        self.miniPlayerView.addGestureRecognizer(miniPlayerTap)
        self.miniPlayerView.isUserInteractionEnabled = true
        
        self.styledView.layer.shadowColor = UIColor.black.cgColor
        self.styledView.layer.shadowColor = UIColor.black.cgColor
        self.styledView.layer.shadowOpacity = 0.8
        self.styledView.layer.shadowOffset = CGSize.zero
        self.styledView.layer.shadowRadius = 23
        self.styledView.layer.masksToBounds = false
        self.styledView.layer.cornerRadius = 4.0
        
        //setPlayingIcons()
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
    
    @objc func reloadMiniPlayerData(notification: NSNotification) {
        reloadMiniPlayerData()
    }
    
    @objc func openLargePlayer(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "LargePlayer", bundle: nil)
        let playerVC = storyboard.instantiateViewController(withIdentifier: "Player") as! MusicPlayerViewController
        
        self.present(playerVC, animated: true, completion: nil)
        /*playerVC.labelSongTitle.text = MusicPlayer.sharedInstance.songData[MusicPlayer.sharedInstance.currentSongIndex].title
        playerVC.labelSongArtist.text = MusicPlayer.sharedInstance.songData[MusicPlayer.sharedInstance.currentSongIndex].author
        if let imageURL = URL(string: MusicPlayer.sharedInstance.songData[MusicPlayer.sharedInstance.currentSongIndex].coverArtUrl ) {
            playerVC.imageCoverArt.af_setImage(withURL: imageURL)
            playerVC.shadow.layer.shadowColor = UIColor.black.cgColor
            playerVC.shadow.layer.shadowOpacity = 0.8
            playerVC.shadow.layer.shadowOffset = CGSize.zero
            playerVC.shadow.layer.shadowRadius = 23
            playerVC.shadow.layer.masksToBounds = false
            playerVC.shadow.layer.cornerRadius = 4.0
        }*/
        playerVC.loadData();//endtime
        //playerVC.changePlayPauseIcon();//to update pgb
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
