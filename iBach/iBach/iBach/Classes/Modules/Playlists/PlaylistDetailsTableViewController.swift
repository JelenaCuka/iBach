//
//  PlaylistDetailsTableViewController.swift
//  iBach
//
//  Created by Goran Alković on 26/01/2019.
//  Copyright © 2019 Petar Jedek. All rights reserved.
//

import Foundation
import Unbox

class PlaylistDetailsTableViewController: UITableViewController {

    var songData: [Song] = []
    
    var playlistId: Int = -1
    var playlistName: String = ""
    
    public func customInit(_ id: Int, _ name: String) {
        self.playlistId = id
        self.playlistName = name
        print("initialized")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        loadData()
        
        self.navigationItem.title = playlistName
    }
    
    private func loadData() {
        DispatchQueue.main.async {
            HTTPRequest().sendGetRequest(urlString: "https://botticelliproject.com/air/api/playlistSong/findall.php?playlistId=\(self.playlistId)", completionHandler: {(response, error) in
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songData.count
    }
    
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       /*
        let cellIdentifier = "playlistDetailCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PlaylistItemTableViewCell else {
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
        
        cell.labelName.text = self.songData[indexPath.row].title
        //cell.labelAuthor.text = self.songData[indexPath.row].author
        
        return cell
 */
        
        let cell = UITableViewCell()
        cell.textLabel?.text = songData[indexPath.row].title
        cell.imageView?.af_setImage(withURL: URL(string: songData[indexPath.row].coverArtUrl)!)
        return cell
    }
 
}
