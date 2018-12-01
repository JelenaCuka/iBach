//
//  LightTheme.swift
//  iBach
//
//  Created by Neven Travas on 01/12/2018.
//  Copyright © 2018 Petar Jedek. All rights reserved.
//

import UIKit

struct LightTheme: Theme {
    let tint: UIColor = .blue
    let secondaryTint: UIColor = .orange
    
    let backgroundColor: UIColor = .white
    let separatorColor: UIColor = .lightGray
    let selectionColor: UIColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
    
    let labelColor: UIColor = .black
    let secondaryLabelColor: UIColor = .darkGray
    let subtleLabelColor: UIColor = .lightGray
    
    let barStyle: UIBarStyle = .default
}

extension LightTheme {
    
    func extend() {
        UIImageView.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).with {
            $0.borderColor = separatorColor
            $0.borderWidth = 1
        }
        
        UIImageView.appearance(whenContainedInInstancesOf: [UIButton.self, UITableViewCell.self]).with {
            $0.borderWidth = 0
        }
    }
}
