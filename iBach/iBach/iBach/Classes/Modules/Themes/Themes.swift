//
//  Themes.swift
//  iBach
//
//  Created by Neven Travas on 01/12/2018.
//  Copyright © 2018 Petar Jedek. All rights reserved.
//

import UIKit

protocol Theme {
    var tint: UIColor { get }
    
    var backgroundColor: UIColor { get }
    var separatorColor: UIColor { get }
    var selectionColor: UIColor { get }
    
    var labelColor: UIColor { get }
    var secondaryLabelColor: UIColor { get }
    var subtleLabelColor: UIColor { get }
    
    var barStyle: UIBarStyle { get }
    var textFieldColor: UIColor {get}
    var buttonColor: UIColor{get}
    var textView: UIColor{get}
    var miniPlayerColor: UIColor {get}
    var playlistLableColor: UIColor {get}
    
    
    func apply(for application: UIApplication)
    
}

extension Theme {
    
    func apply(for application: UIApplication) {
        application.keyWindow?.tintColor = tint
        
        UITabBar.appearance().with {
            $0.barStyle = barStyle
            $0.tintColor = tint
        }
        
        UINavigationBar.appearance().with {
            $0.barStyle = barStyle
            $0.tintColor = tint
            $0.titleTextAttributes = [
                .foregroundColor: labelColor
            ]
        }
        
        UILabel.appearance().textColor = labelColor
        UITextField.appearance().textColor = textFieldColor
        
        
        UITableView.appearance().with {
            $0.backgroundColor = backgroundColor
            $0.separatorColor = separatorColor
        }
        
        UITableViewCell.appearance().with {
            $0.backgroundColor = .clear
            $0.selectionColor = selectionColor
        }
        
        UIView.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
            .backgroundColor = backgroundColor
        
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self, UITableViewCell.self])
            .textColor = labelColor
        
        UITextView.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self, UITableViewCell.self])
            .textColor = labelColor
        
        
        
        AppTextView.appearance().textColor = textView
        AppLabel.appearance().textColor = labelColor
        AppSubhead.appearance().textColor =  secondaryLabelColor
        //AppFootnote.appearance().textColor = subtleLabelColor
        
        
        AppButton.appearance().with {
            $0.setTitleColor(buttonColor, for: .normal)
            
        }
        
        
        AppView.appearance().backgroundColor = backgroundColor
        
        AppSeparator.appearance().with {
            $0.backgroundColor = separatorColor
            $0.alpha = 0.5
        }
        
        AppStackView.appearance().backgroundColor = backgroundColor
        AppMiniPlayer.appearance().backgroundColor = miniPlayerColor
        AppPlaylistLable.appearance().textColor = playlistLableColor
        
        
        AppView.appearance(whenContainedInInstancesOf: [AppView.self]).with {
            $0.backgroundColor = selectionColor
            $0.cornerRadius = 10
        }
        
//        // Style differently when inside a special container
//        
//        AppLabel.appearance(whenContainedInInstancesOf: [AppView.self, AppView.self]).textColor = subtleLabelColor
//        AppHeadline.appearance(whenContainedInInstancesOf: [AppView.self, AppView.self]).textColor = secondaryLabelColor
//        AppFootnote.appearance(whenContainedInInstancesOf: [AppView.self, AppView.self]).textColor = labelColor
//        
//        AppButton.appearance(whenContainedInInstancesOf: [AppView.self, AppView.self]).with {
//            $0.setTitleColor(labelColor, for: .normal)
//            $0.borderColor = labelColor
//        }
//        
//        AppDangerButton.appearance(whenContainedInInstancesOf: [AppView.self, AppView.self]).with {
//            $0.setTitleColor(subtleLabelColor, for: .normal)
//            $0.backgroundColor = labelColor
//        }
//        
//        
        
        // Ensure existing views render with new theme
        // https://developer.apple.com/documentation/uikit/uiappearance
        application.windows.reload()
    }
}
