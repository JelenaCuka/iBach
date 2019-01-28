//
//  FavoritesTableViewController.swift
//  iBach
//
//  Created by Petar Jedek on 06.12.18.
//  Copyright © 2018 Petar Jedek. All rights reserved.
//

import UIKit
import Unbox
import AlamofireImage
import Alamofire

class FavoritesTableViewController: UIViewController {
    
    @IBOutlet weak var tableViewFavorites: UITableView!
    
    
    var songData: [Song] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewFavorites.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        songData = []
        loadData()
    }
    
    private func loadData() {
        songData = []
        DispatchQueue.main.async {
            HTTPRequest().sendGetRequest(urlString: "http://botticelliproject.com/air/api/favorite/findall.php?userId=\(UserDefaults.standard.integer(forKey: "user_id"))", completionHandler: {(response, error) in
                if let data: NSArray = response as? NSArray {
                    for song in data {
                        do {
                            
                            let singleSong: Song = try unbox(dictionary: (song as! NSDictionary) as! UnboxableDictionary)
                            self.songData.append(singleSong)
                            
                        }
                        catch {
                            print("Unable to unbox")
                        }
                    }
                }
                self.tableViewFavorites.reloadData()
                
            })
        }
    }
    private func removeFavourite(songId: Int) {
        
            let parameters: Parameters = [
                "save": 1,
                "songId": songId,
                "userId": UserDefaults.standard.integer(forKey: "user_id")
            ]
        
            HTTPRequest().sendPostRequest2(urlString: "https://botticelliproject.com/air/api/favorite/save.php", parameters: parameters, completionHandler: {(response, error) in
   
                var serverResponse: String = ""
                serverResponse = response!["description"]! as! String
                
                if (serverResponse == "OK. Favorite song removed") {
                    DispatchQueue.main.async {
                        //self.tableViewFavorites.tableFooterView = UIView(frame: CGRect.zero)//
                        let oldFavorites : [Song] = self.songData
                        
                        
                        self.songData = []
                        
                        HTTPRequest().sendGetRequest(urlString: "http://botticelliproject.com/air/api/favorite/findall.php?userId=\(UserDefaults.standard.integer(forKey: "user_id"))", completionHandler: {(response, error) in
                            if let data: NSArray = response as? NSArray {
                                for song in data {
                                    do {
                                        
                                        let singleSong: Song = try unbox(dictionary: (song as! NSDictionary) as! UnboxableDictionary)
                                        self.songData.append(singleSong)
                                        
                                    }
                                    catch {
                                        print("Unable to unbox")
                                    }
                                }
                            }
                            self.tableViewFavorites.reloadData()
                            
                            if (oldFavorites.count > 0 ){
                                
                                if  oldFavorites.elementsEqual(MusicPlayer.sharedInstance.songData, by: { $0.id == $1.id }) {
                                    
                                    //dohvati id trenurno reproducirane pjesme favorita
                                    let currentSongId = MusicPlayer.sharedInstance.songData[MusicPlayer.sharedInstance.currentSongIndex].id
                                    //update favorita
                                    MusicPlayer.sharedInstance.updateSongData(songsList: self.songData as [Song])
                                    //index trenutne pjesme u prociscenoj listi
                                    let newCurrentSongIndex = MusicPlayer.sharedInstance.getSongIndex(song: currentSongId)
                                    MusicPlayer.sharedInstance.currentSongIndex = newCurrentSongIndex
                                    
                                }
                            }
                            
                        })
                        //
                        
                    }
                }
            })
    }
    
}

extension FavoritesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "trackCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FavoriteSongTableViewCell else {
            fatalError("Error")
        }
        
        if let imageURL = URL(string: self.songData[indexPath.row].coverArtUrl) {
            let color: UIColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.4)
            
            cell.imageViewCoverArt.layer.cornerRadius = 5
            cell.imageViewCoverArt.clipsToBounds = true
            cell.imageViewCoverArt.layer.borderWidth = 0.5
            cell.imageViewCoverArt.layer.borderColor = color.cgColor
            cell.imageViewCoverArt.af_setImage(withURL: imageURL)
        }
        
        cell.labelTrackTitle.text = self.songData[indexPath.row].title
        cell.labelAuthor.text = self.songData[indexPath.row].author
        cell.id = self.songData[indexPath.row].id
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .normal, title:  "Remove", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
            //ne moze ukloniti pjesmu koja trenutno svira
            if(self.songData[indexPath.row].id != MusicPlayer.sharedInstance.songData[MusicPlayer.sharedInstance.currentSongIndex].id){
                self.removeFavourite(songId: self.songData[indexPath.row].id)
            }
        })
        deleteAction.backgroundColor = .purple
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MusicPlayer.sharedInstance.updateSongData(songsList: songData as [Song])
        
        if(MusicPlayer.sharedInstance.playSong(song: songData[indexPath.row].id)){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "displayMiniPlayer"), object: nil)
        }
        
    }

}

