//
//  MemeCollectionViewController.swift
//  Mememe
//
//  Created by Ahmed Khedr on 5/2/15.
//  Copyright (c) 2015 Ahmed Khedr. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    var memes = [Meme]()
    @IBOutlet weak var addButton: UIBarButtonItem!

    override func viewDidLoad() {
        
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.tabBarController!.tabBar.hidden = false

        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        self.collectionView!.reloadData()
        
        println("Size of memes array (collectionViewController)= \(memes.count)")
        
        if memes.count == 0 {
            performSegueWithIdentifier("addMeme", sender: self.addButton)
        }
    }

    @IBAction func addNewMeme(sender: UIBarButtonItem) {
        performSegueWithIdentifier("addMeme", sender: sender)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        println("numberOfItemsInSection is called: \(memes.count)")
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        println("cellForItemAtIndexPath called")
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! UICollectionViewCell
        
        println("collectionCell = \(cell)")
        
        let meme = memes[indexPath.row]
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        println("didSelectItemAtIndexPath called")
        let sentMemeController = self.storyboard!.instantiateViewControllerWithIdentifier("SentMemeViewController") as! SentMemeViewController
        sentMemeController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(sentMemeController, animated: true)
    }
}
