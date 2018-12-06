//
//  MusicPlayer.swift
//  iBach
//
//  Created by Petar Jedek on 06.12.18.
//  Copyright © 2018 Petar Jedek. All rights reserved.
//

import AVKit
import Foundation
import MediaPlayer
import AVFoundation

class MusicPlayer {
    
    static var player = AVPlayer()
    
    public func playMusicFromUrl(url: URL) -> Bool {
        let playerItem = AVPlayerItem(url: url)
        MusicPlayer.player = AVPlayer(playerItem: playerItem)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        MusicPlayer.player.play()
        return true;
    }
    
    public func pauseMusic() -> Bool {
        MusicPlayer.player.pause()
        return false
    }
    
    public func playMusic() -> Bool {
        MusicPlayer.player.play()
        return true
    }
    
}
