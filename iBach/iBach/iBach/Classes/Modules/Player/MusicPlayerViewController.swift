//
//  MusicPlayerViewController.swift
//  iBach
//
//  Created by Petar Jadek on 14/01/2019.
//  Copyright © 2019 Petar Jedek. All rights reserved.
//

import UIKit

class MusicPlayerViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var labelSongTitle: UILabel!
    @IBOutlet weak var labelSongArtist: UILabel!
    @IBOutlet weak var imageCoverArt: UIImageView!
    @IBOutlet weak var shadow: UIView!
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    
    
    @IBOutlet weak var returnButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCoverArt.layer.shadowColor = UIColor.black.cgColor
        imageCoverArt.layer.shadowOpacity = 1
        imageCoverArt.layer.shadowOffset = CGSize.zero
        imageCoverArt.layer.shadowRadius = 23
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        let scrollViewBounds = scrollView.bounds
        let containerViewBounds = contentView.bounds
        
        var scrollViewInsets = UIEdgeInsets.zero
        scrollViewInsets.top = scrollViewBounds.size.height / 2.0
        scrollViewInsets.top -= contentView.bounds.size.height / 2.0
        
        scrollViewInsets.bottom  = scrollViewBounds.size.height/2.0
        scrollViewInsets.bottom -= contentView.bounds.size.height/2.0
        scrollViewInsets.bottom += 1
        
        scrollView.contentInset = scrollViewInsets
    }
    
    
    
    @IBAction func returnFromLargePlayer(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
