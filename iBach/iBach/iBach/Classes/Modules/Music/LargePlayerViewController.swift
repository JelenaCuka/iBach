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

    var player = MusicPlayer()
    var currentSong: Int = -1
    var index: Int = -1
    var songData: [Song] = []
    
    @IBOutlet var labelSongTitle: UILabel!
    @IBOutlet var imageCoverArt: UIImageView!
    @IBOutlet var labelArtistAlbumYear: UILabel!
    
    @IBOutlet var butonPlay: UIButton!
    @IBOutlet var buttonPause: UIButton!
    @IBOutlet var buttonPrevious: UIButton!
    @IBOutlet var buttonNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let effect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = self.view.bounds
        self.view.addSubview(blurView)
        self.view.sendSubviewToBack(blurView)
        
        let screenEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.dismissLargePlayer(_:)))
        screenEdgeRecognizer.edges = .top
        view.addGestureRecognizer(screenEdgeRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayLargePlayer(notification:)), name: NSNotification.Name(rawValue: "displayMiniPlayer"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(recieveSongList(notification:)), name: NSNotification.Name(rawValue: "sendSongList"), object: nil)
    
    }
    
    
    @objc func dismissLargePlayer(_ sender: UIScreenEdgePanGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func displayLargePlayer(notification: NSNotification) {
        self.labelSongTitle.text = notification.userInfo!["title"]! as? String
        
        if let imageURL = URL(string: (notification.userInfo!["cover_art"]! as? String)!) {
            self.imageCoverArt.layer.cornerRadius = 20
            self.imageCoverArt.clipsToBounds = true
            
            imageCoverArt.layer.shadowColor = UIColor.black.cgColor
            imageCoverArt.layer.shadowOpacity = 1
            imageCoverArt.layer.shadowOffset = CGSize.zero
            imageCoverArt.layer.shadowRadius = 50

            self.imageCoverArt.af_setImage(withURL: imageURL)
        }
        
        let artist: String = (notification.userInfo!["author"]! as? String)!
        //let album: String = (notification.userInfo!["album"]! as? String)!
        let year: String = (notification.userInfo!["year"]! as? String)!
        
        self.labelArtistAlbumYear.text = "\(artist) - \(year)"
    }
    
    @objc func recieveSongList(notification: NSNotification) {
        print(type(of: notification.userInfo!["others"]!))
        
        currentSong = notification.userInfo!["id"] as! Int
        songData = notification.userInfo!["others"] as! [Song]
        
        var i: Int = 0
        for s in songData {
            if (s.id == currentSong) {
                index = i;
            } else {
                i += 1
            }
        }
    }
    
    @IBAction func closeLargePlayer(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pauseSong(_ sender: Any) {
        print("click")
        if (!player.pauseMusic()) {
            butonPlay.setImage(UIImage(named: "Play"), for: .normal)
        } else {
            player.playMusic()
            butonPlay.setImage(UIImage(named: "Pause"), for: .normal)
        }
    }
    
    

}
