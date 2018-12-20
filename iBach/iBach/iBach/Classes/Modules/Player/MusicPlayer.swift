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
import NotificationCenter
import Unbox

class MusicPlayer {
    
    var player: AVPlayer!
    var songData: [Song] = [] //all,playlist,favourites
    var shuffle: Bool = false
    var currentSongIndex: Int = -1
    
    static let sharedInstance = MusicPlayer()
    
    //let changeSong = Notification.Name("changeSong")
    
    /*var currentSong: Song? {
     get {
     return (currentSongIndex < 0 || currentSongIndex >= songData.count) ? nil : songData[currentSongIndex]
     }
     }*/
    
    private init() {
        //playback
        setSession()
        UIApplication.shared.beginReceivingRemoteControlEvents()//bg playing controls
        
        //interruptions ex headphones,call...
        NotificationCenter.default.addObserver(self, selector: "handleInterruption", name: AVAudioSession.interruptionNotification, object: nil )
        
    }
    
    func setSession(){
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: [])
        }catch{
            print(error)
        }
    }
    
    @discardableResult
    func playSong( song: Int ) -> Bool {
        if ( songIsInSongList(song: song) ) {
            currentSongIndex = song
            player = AVPlayer(playerItem: AVPlayerItem(url: URL(string: songData[currentSongIndex].fileUrl)!) )
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main ){ [weak self] _ in self?.player?.seek(to: CMTime.zero)
                self?.nextSong()
            }
            setPlayingScreen()
        }
        return playSong()
    }
    
    @discardableResult
    func playSong() -> Bool {
        if( !isPlaying() && songIsInSongList(song: currentSongIndex) ){
            player.play()
            NotificationCenter.default.post(name: .songIsPlaying, object: nil)

            return true
        }
        else {
            return false
        }
    }
    
    @discardableResult
    func pauseSong() -> Bool {
        if( isPlaying() && songIsInSongList(song: currentSongIndex) ){
            player.pause()
            NotificationCenter.default.post(name: .songIsPaused, object: nil)
            return true
        } else {
            return false
        }
    }
    
    @discardableResult
    func previousSong() -> Bool {
        if shuffle {
            shuffleSong()
        }else{
            if( firstSongInTheList() ) {
                currentSongIndex = (songData.count - 1)
            }else{
                currentSongIndex = currentSongIndex - 1
            }
        }
        return playSong(song: currentSongIndex )
    }
    
    @discardableResult
    func nextSong()  -> Bool {
        if shuffle {
            shuffleSong()
        } else {
            if( lastSongInTheList() ) {
                currentSongIndex = 0
            }else{
                currentSongIndex = currentSongIndex + 1
            }
        }
        return playSong( song: currentSongIndex )
    }
    
    func currentSongDuration() -> Int {
        if ( self.player.currentItem != nil ) {
            let duration = Int ( CMTimeGetSeconds( self.player.currentItem!.asset.duration ) )
            return duration
        }
        return 0
    }
    
    func currentSongTime() -> Int {
        if ( self.player.currentItem != nil ) {
            let currentTime = Int ( CMTimeGetSeconds( self.player.currentItem!.currentTime() )  )
            return currentTime
        }
        return 0
    }
    
    //interruptions
    func handleInterruption(notification: NSNotification){
        pauseSong()
        let interruptionTypeAsObject = notification.userInfo![AVAudioSessionInterruptionTypeKey] as! NSNumber
        let interruptionType = AVAudioSession.InterruptionType(rawValue: interruptionTypeAsObject.uintValue)
        if let type = interruptionType {
            if type == .ended {
                playSong()
            }
        }
    }
    
    func updateSongData(songsList: [Song] = [] ){
        self.songData = songsList
    }
    
    func isPlaying () -> Bool {
        if (player != nil) {
            if( player.rate > 0 && player.error == nil ){
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func songIsInSongList( song: Int) -> Bool {
        if ((song >= 0 && song < songData.count ) && song != -1  ){
            return true
        }else{
            return false
        }
    }
    
    func firstSongInTheList() -> Bool {
        if(currentSongIndex == 0 ) {
            return true
        }
        return false
    }
    
    func lastSongInTheList() -> Bool {
        if(currentSongIndex == (songData.count - 1) ) {
            return true
        }
        return false
    }
    
    func shuffleSong() {
        currentSongIndex = Int.random(in: 0 ..< (songData.count - 1) )
    }
    
    func shuffleOnOff() {
        if shuffle {
            shuffle = false
        } else {
            shuffle = true
        }
    }
    
    func setPlayingScreen() {
        if (songIsInSongList(song: currentSongIndex)) {
            let songInfo = [
                MPMediaItemPropertyTitle : songData[currentSongIndex].title,
                MPMediaItemPropertyArtist : songData[currentSongIndex].author
            ]
            MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo
        }
    }
    
    
    
    
}

