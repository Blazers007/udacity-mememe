//
//  SentMemesViewController.swift
//  MemeMe
//
//  Created by blazers on 2017/1/5.
//  Copyright © 2017年 张良. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: -- Properties
    
    var memes: [Meme] = []
    
    @IBOutlet weak var memesTableView: UITableView!
    
    // MARK: -- Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Custom seprator style
        memesTableView.separatorColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Load meme array from AppDelegate
        memes = (UIApplication.shared.delegate as! AppDelegate).memes
        // Reload data
        memesTableView.reloadData()
    }
    
    // MARK: -- Delegate & DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell") as! MemeTableViewCell
        let meme = memes[indexPath.row]
        cell.memeLabel.text = meme.topText + meme.bottomText
        cell.memeImageView.image = meme.memedImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Goto Detail View
        MemeDetailViewController.gotoMemeDetailVC(self, memes[indexPath.row])
    }
    
}
