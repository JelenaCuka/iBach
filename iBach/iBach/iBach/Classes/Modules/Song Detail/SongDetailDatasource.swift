//
//  SongDetail.swift
//  iBach
//
//  Created by Neven Travaš on 14/01/2019.
//  Copyright © 2019 Petar Jedek. All rights reserved.
//

import Foundation

protocol SongDetailDatasource {
    
    var apiKey: String { get }
    var baseURL: URL { get }
    
    func getSongDetails(with name: String, artist: String, album: String)
    func getLyrics(for song: String, artist: String)
}
