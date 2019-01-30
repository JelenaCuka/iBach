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
    
    var currentSong: Song? {
        guard currentSongIndex > -1, currentSongIndex < songData.count else { return nil }
        return songData[currentSongIndex]
    }
    
    private init() {
        
    }
    
    //set session for playback
    func setSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: [])
        } catch {
            print(error)
        }
    }
    
    //play new song by song id
    //set/change currentSongIndex
    //sets AVPlayer(playerItem)
    //add observer - when song ends play next song
    //sets playing background screen
    //sets playing volume
    @discardableResult
    func playSong( song: Int ) -> Bool {
        if ( songIsInSongList(song: song) ) {
            currentSongIndex = getSongIndex(song: song)
            player = AVPlayer(playerItem: AVPlayerItem(url: URL(string: songData[currentSongIndex].fileUrl)!) )
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main ) { [weak self] _ in self?.player?.seek(to: CMTime.zero)
                self?.nextSong()
            }
            setPlayingScreen()
            checkOldVolume()
        }
        
        return playSong()
    }
    
    //continue playing current song
    //can play song from beginning when currentSongIndex changed (ex. called from nextSong or previousSong or playSong(id))
    @discardableResult
    func playSong() -> Bool {
        if( !isPlaying() && currentSongIndex != -1 && songIsInSongList(song: songData[currentSongIndex].id) ){
            player.play()
            NotificationCenter.default.post(name: .songIsPlaying, object: nil)

            return true
        }
        else {
            return false
        }
    }
    
    //pauses playing song
    //sends notification songIsPaused
    @discardableResult
    func pauseSong() -> Bool {
        if( isPlaying() && songIsInSongList(song: songData[currentSongIndex].id)  ){
            player.pause()
            NotificationCenter.default.post(name: .songIsPaused, object: nil)
            return true
        } else {
            return false
        }
    }
    
    //changes current song index to next
    //calls play new  song
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
        return playSong(song: songData[currentSongIndex].id)
    }
    
    //changes current song index to previous
    //calls play new  song
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
        return playSong(song: songData[currentSongIndex].id)
    }
    
    //returns current song duration in seconds
    func currentSongDuration() -> Int {
        if ( self.player.currentItem != nil ) {
            let duration = Int ( CMTimeGetSeconds( self.player.currentItem!.asset.duration ) )
            return duration
        }
        return 0
    }
    
    //return current time of played song in seconds
    func currentSongTime() -> Int {
        if ( self.player.currentItem != nil ) {
            let currentTime = Int ( CMTimeGetSeconds( self.player.currentItem!.currentTime() )  )
            return currentTime
        }
        return 0
    }
    
    //updates player volume
    func changeVolume(newVolume : Float){
        player.volume = newVolume
        UserDefaults.standard.set(newVolume, forKey: "MusicVolume")
    }
    
    //sets old player volume
    func checkOldVolume(){
        if let oldVolume = UserDefaults.standard.value(forKey: "MusicVolume") {
            changeVolume (newVolume : oldVolume as! Float)
        }
    }
    
    //updates playing songs list
    func updateSongData(songsList: [Song] = [] ) {
        self.songData = songsList
    }
    
    //checks if song is playing returns result true-false
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
    
    //checks if song is in the player playing list by song id
    func songIsInSongList( song: Int) -> Bool {
        let contains = songData.contains { $0.id == song }
        if (contains ){
            return true
        }else{
            return false
        }
    }
    
    //if song is in the player list returns it's index ,if not returns -1
    func getSongIndex(song: Int) -> Int {
        var index = -1
        if (songIsInSongList( song: song)){
            index = songData.index(where: { $0.id == song }) ?? -1
        }
        return index
    }
    
    //true if current song is first in player list
    func firstSongInTheList() -> Bool {
        if(currentSongIndex == 0 ) {
            return true
        }
        return false
    }
    
    //true if current song is last in player list
    func lastSongInTheList() -> Bool {
        if(currentSongIndex == (songData.count - 1) ) {
            return true
        }
        return false
    }
    
    //picks random song in player list
    func shuffleSong() {
        currentSongIndex = Int.random(in: 0 ..< (songData.count - 1) )
    }
    
    //onOff shuffle option
    func shuffleOnOff() {
        if shuffle {
            shuffle = false
        } else {
            shuffle = true
        }
    }
    
    
    //if song is playing
    //set playing screen for lock screen
    func setPlayingScreen() {
        if currentSongIndex != -1 {
            if (songIsInSongList(song: songData[currentSongIndex].id)) {
                let songInfo = [
                    MPMediaItemPropertyTitle : songData[currentSongIndex].title,
                    MPMediaItemPropertyArtist : songData[currentSongIndex].author
                ]
                MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo
            }
        }
    }
    
    //turn off player (for log off)
    //delete songlist
    //set currentSongIndex to -1
    //remove background playing information
    func turnOff() {
        if isPlaying() {
            pauseSong()
            MPNowPlayingInfoCenter.default().nowPlayingInfo?.removeAll()
        }
        if currentSongIndex != -1 {
            currentSongIndex = -1
        }
        if songData.count != 0 {
            songData.removeAll()
        }
        
    }
    
    
    
    
}

