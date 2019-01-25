//
//  Album.swift
//  iBach
//
//  Created by Neven Travaš on 22/01/2019.
//  Copyright © 2019 Petar Jedek. All rights reserved.
//

import Foundation
import Unbox

class Album: Unboxable {
    
    let id: Int
    let name: String
    let trackCount: String
    let releaseDate: String
    
    let artistId: Int
    let artistName: String
    
    required init (unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(keyPath: "body.album.album_id")
        self.name = try unboxer.unbox(keyPath: "body.album.album_name")
        self.trackCount = try unboxer.unbox(keyPath: "body.album.album_track")
        self.releaseDate = try unboxer.unbox(keyPath: "body.album.album_release_date")
        self.artistId = try unboxer.unbox(keyPath: "body.album.artist_id")
        self.artistName = try unboxer.unbox(keyPath: "body.album.artist_name")
        
    }
}
