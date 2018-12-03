//
//  MusicTableViewController.swift
//  iBach
//
//  Created by Petar Jedek on 01.12.18.
//  Copyright © 2018 Petar Jedek. All rights reserved.
//

import UIKit
import Unbox
import AlamofireImage
import AVKit
import AVFoundation

class MusicTableViewController: UIViewController {
      
    var songData: [Song] = []
    var player = AVPlayer()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shuffleImage = UIImage(named: "Shuffle Navigation Icon")
        
        let buttonPlay = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play, target: self, action: "someAction")
        let buttonShuffle = UIBarButtonItem(image: shuffleImage, style: .plain, target: self, action: "action")
        
        navigationItem.rightBarButtonItems = [buttonPlay, buttonShuffle]
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
        
        loadTracks()
        
    }

    
    private func loadTracks() {
        DispatchQueue.main.async {
            HTTPRequest().sendGetRequest(urlString: "https://botticelliproject.com/air/api/song/findall.php", completionHandler: {(response, error) in
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
                self.tableView.reloadData()
            })
        }
    }
    

}

extension MusicTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "trackCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TrackTableViewCell else {
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerItem = AVPlayerItem(url: URL(string: self.songData[indexPath.row].fileUrl)!)
        player = AVPlayer(playerItem: playerItem)
        player.play()
     
        
    }
    
}

extension MusicTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
    
    }
    
}

