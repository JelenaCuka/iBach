//
//  MusicViewController.swift
//  iBach
//
//  Created by Petar Jedek on 24.11.18.
//  Copyright © 2018 Petar Jedek. All rights reserved.
//

import UIKit

class MusicViewController: UIViewController {
    
    override func viewDidLoad() {
        self.getMusicList()
        super.viewDidLoad()
    }
    
    public func getMusicList() {
        HTTPRequest().sendGetRequest(urlString: "http://botticelliproject.com/air/api/song/findall.php", completionHandler: {(response, error) in
            print(response as Any)//let serverResponse: [String: Any] = response!["data"]! as! [String: Any]
            
        })
    }
    
    public func displayMusicData() {
        
    }
}
