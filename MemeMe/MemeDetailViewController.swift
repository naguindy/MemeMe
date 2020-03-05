//
//  MemeDetailViewController.swift
//  MemeMe 1.0
//
//  Created by Noha on 02.08.19.
//  Copyright © 2019 udacity. All rights reserved.
//

import Foundation
import UIKit
class MemeDetailViewController : UIViewController {
    var meme : Meme!
    @IBOutlet weak var detailImageView: UIImageView!
    
   override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = true
    self.detailImageView.image = meme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
