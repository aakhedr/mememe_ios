//
//  SentMemesCollectionViewController.swift
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
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController!.tabBar.hidden = false

        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        
        self.collectionView!.backgroundColor = UIColor.whiteColor()
        // Reload collection data
        self.collectionView!.reloadData()
    }

    @IBAction func addNewMeme(sender: UIBarButtonItem) {
        performSegueWithIdentifier("addMeme", sender: sender)
    }

    /*********** UICollectionViewDelegate and UICollectionViewDataSource methods (3) ****/
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        let meme = memes[indexPath.row]
        cell.memedImage.image = meme.memedImage
        
        // Keep the x button always hidden unless editing
        if self.navigationItem.leftBarButtonItem!.title == "Edit" {
            cell.xButton!.hidden = true
        } else {
            cell.xButton!.hidden = false
        }
        
        /* Pass the meme index to delete */
        cell.xButton!.layer.setValue(indexPath.row, forKey: "index")
        cell.xButton!.addTarget(self, action: "deleteMeme:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let sentMemeController = self.storyboard!.instantiateViewControllerWithIdentifier("SentMemeViewController") as! SentMemeViewController
        sentMemeController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(sentMemeController, animated: true)
    }

    /******** Activating the edit button to delete memes from the collection view **********/
    /* Manage the view */
    @IBAction func editMeme(sender: UIBarButtonItem) {
        if self.navigationItem.leftBarButtonItem!.title == "Edit" {
            self.navigationItem.leftBarButtonItem!.title = "Done"

            // Get all cells that user will tab x on
            for item in self.collectionView!.visibleCells() as! [MemeCollectionViewCell] {
                let index = self.collectionView!.indexPathForCell(item as MemeCollectionViewCell)
                let cell = self.collectionView!.cellForItemAtIndexPath(index!) as! MemeCollectionViewCell
                
                // The (x) clear button
                let xButton = cell.viewWithTag(100) as! UIButton
                xButton.hidden = false
            }
        } else {
            self.navigationItem.leftBarButtonItem!.title = "Edit"
            self.collectionView!.reloadData()
        }
    }
    
    /* Actual delete */
    func deleteMeme(sender: UIButton) {
        let index = sender.layer.valueForKey("index") as! Int
        // Delete from the collection view
        self.memes.removeAtIndex(index)
        // Delete from the model
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(index)
        self.collectionView!.reloadData()
    }
}
