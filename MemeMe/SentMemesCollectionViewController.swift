//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by blazers on 2017/1/18.
//  Copyright © 2017年 张良. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {

    // MARK: -- Properties
    
    var memes: [Meme] = []
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: -- Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memes = (UIApplication.shared.delegate as! AppDelegate).memes
        collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: -- Delegate & DataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionCell", for: indexPath) as! MemeCollectionViewCell
        cell.memeImageView.image = memes[indexPath.row].memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Goto Detail View
        MemeDetailViewController.gotoMemeDetailVC(self, memes[indexPath.row])
    }

}
