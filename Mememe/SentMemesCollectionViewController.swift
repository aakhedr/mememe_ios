//
//  MemeCollectionViewController.swift
//  Mememe
//
//  Created by Ahmed Khedr on 5/2/15.
//  Copyright (c) 2015 Ahmed Khedr. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var memes = [Meme]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add edit button
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        // Reload collection data
        self.collectionView!.reloadData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController!.tabBar.hidden = false

        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        
        if memes.count == 0 {
            addNewMeme(addButton)
        }
        // Reload collection data
        self.collectionView!.reloadData()
    }

    @IBAction func addNewMeme(sender: UIBarButtonItem) {
        performSegueWithIdentifier("addMeme", sender: sender)

        /* REVISIT THIS!!! */
        // Hide the previous navigation controller tab bar
//        self.tabBarController!.tabBar.hidden = true
    }

    /*********** UICollectionViewDelegate and UICollectionViewDataSource methods (3) ****/
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        let meme = memes[indexPath.row]
        cell.memedImage.image = meme.memedImage
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let sentMemeController = self.storyboard!.instantiateViewControllerWithIdentifier("SentMemeViewController") as! SentMemeViewController
        sentMemeController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(sentMemeController, animated: true)
    }
}
