//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by blazers on 2017/1/5.
//  Copyright © 2017年 张良. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    // Navigato to here
    class func gotoMemeDetailVC(_ from: UIViewController, _ meme : Meme) {
        let detailVC = from.storyboard?.instantiateViewController(withIdentifier: "MemeDetail") as! MemeDetailViewController
        detailVC.memeImage = meme.memedImage
        from.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    var memeImage: UIImage? = nil
    @IBOutlet weak var memeImageView: UIImageView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeImageView.image = memeImage
    }

}
