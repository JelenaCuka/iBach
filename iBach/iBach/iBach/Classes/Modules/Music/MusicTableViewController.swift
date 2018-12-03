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

class MusicTableViewController: UIViewController {
    
    var songData: [Song] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            cell.imageViewCoverArt.layer.cornerRadius = 10
            cell.imageViewCoverArt.clipsToBounds = true
            cell.imageViewCoverArt.af_setImage(withURL: imageURL)
        }
        
        cell.labelTrackTitle.text = self.songData[indexPath.row].title
        cell.labelAuthor.text = self.songData[indexPath.row].author
        
        return cell
    }
    
}
