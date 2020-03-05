//
//  MemeTableViewController.swift
//  MemeMe 1.0
//
//  Created by Noha on 01.08.19.
//  Copyright © 2019 udacity. All rights reserved.
//

import Foundation
import UIKit
class MemeTableViewController : UITableViewController{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    
    var memes : [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.memes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath) as! MemeTableViewCell 
        
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.memeImage.image = meme.memedImage
        cell.memeText.text = meme.topText + " " + meme.bottomText
     
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailViewController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
}
