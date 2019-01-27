//
//  SongsTableViewController.swift
//  iBach
//
//  Created by Nikola on 27/01/2019.
//  Copyright © 2019 Petar Jedek. All rights reserved.
//

import Foundation
import Unbox
import Alamofire

protocol ControllerDelegate {
    func enableAddButton()
}

class SongsTableViewController: UITableViewController {
    
    var songData: [Song] = []
    
    var delegate: ControllerDelegate?
    
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

extension SongsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songData.count
    }
    
    func image(_ image:UIImage, withSize newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.automatic)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)

        cell.textLabel?.text = self.songData[indexPath.row].title
        cell.textLabel?.font = AppLabel.appearance().font
        cell.textLabel?.textColor = AppLabel.appearance().textColor
        
        cell.detailTextLabel?.text = self.songData[indexPath.row].author
        cell.detailTextLabel?.font = cell.detailTextLabel?.font.withSize(14)
        cell.detailTextLabel?.textColor = AppSubhead.appearance().textColor
        
        if URL(string: self.songData[indexPath.row].coverArtUrl) != nil {
            let color: UIColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.4)
            
            cell.imageView?.layer.cornerRadius = 5
            cell.imageView?.clipsToBounds = true
            cell.imageView?.layer.borderWidth = 0.5
            cell.imageView?.layer.borderColor = color.cgColor
            
            // Download cover image
            let url = URL(string: songData[indexPath.row].coverArtUrl)
            let data = try? Data(contentsOf: url!)
            
            cell.imageView?.image = image(UIImage(data: data!)!, withSize: CGSize(width: 50, height: 50))
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            delegate?.enableAddButton()
    }
}
