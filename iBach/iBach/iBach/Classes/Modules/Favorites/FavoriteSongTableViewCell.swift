//
//  FavoriteSongTableViewCell.swift
//  iBach
//
//  Created by Petar Jedek on 06.12.18.
//  Copyright © 2018 Petar Jedek. All rights reserved.
//

import UIKit

class FavoriteSongTableViewCell: UITableViewCell {
    
    @IBOutlet var imageViewCoverArt: UIImageView!
    @IBOutlet var labelTrackTitle: UILabel!
    @IBOutlet var labelAuthor: UILabel!
    var id: Int!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
