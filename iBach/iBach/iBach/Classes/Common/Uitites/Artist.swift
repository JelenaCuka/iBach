//
//  Artist.swift
//  iBach
//
//  Created by Neven Travaš on 22/01/2019.
//  Copyright © 2019 Petar Jedek. All rights reserved.
//

import Unbox

class Artist{
    
    let id: Int
    let name: String
    let country: String
    
    required init (unboxer: Unboxer) throws{
        self.id = try unboxer.unbox(keyPath: "artist.artist_id")
        self.name = try unboxer.unbox(keyPath: "artist.artist_name")
        self.country = try unboxer.unbox(keyPath: "artist.artist_country")
    }
}
