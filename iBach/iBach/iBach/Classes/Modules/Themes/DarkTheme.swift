//
//  DarkTheme.swift
//  iBach
//
//  Created by Neven Travas on 01/12/2018.
//  Copyright © 2018 Petar Jedek. All rights reserved.
//

import UIKit

struct DarkTheme: Theme {
    let tint: UIColor = .yellow
    let secondaryTint: UIColor = .green
    
    let backgroundColor: UIColor = .black
    let separatorColor: UIColor = .lightGray
    let selectionColor: UIColor = .init(red: 38/255, green: 38/255, blue: 40/255, alpha: 1)
    
    let labelColor: UIColor = .white
    let secondaryLabelColor: UIColor = .lightGray
    let subtleLabelColor: UIColor = .darkGray
    
    let barStyle: UIBarStyle = .black
}
