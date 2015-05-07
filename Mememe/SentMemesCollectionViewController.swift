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
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        
        collectionView!.backgroundColor = UIColor.whiteColor()
        // Reload collection data
        collectionView!.reloadData()
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
        let sentMemeController = storyboard!.instantiateViewControllerWithIdentifier("SentMemeViewController") as! SentMemeViewController
        sentMemeController.meme = self.memes[indexPath.row]
        hidesBottomBarWhenPushed = true
        navigationController!.pushViewController(sentMemeController, animated: true)
        hidesBottomBarWhenPushed = false
    }

    /******** Activating the edit button to delete memes from the collection view **********/
    /* Manage the view */
    @IBAction func editMeme(sender: UIBarButtonItem) {
        if navigationItem.leftBarButtonItem!.title == "Edit" {
            navigationItem.leftBarButtonItem!.title = "Done"

            // Get all cells that user will tab x on
            for item in collectionView!.visibleCells() as! [MemeCollectionViewCell] {
                let index = collectionView!.indexPathForCell(item as MemeCollectionViewCell)
                let cell = collectionView!.cellForItemAtIndexPath(index!) as! MemeCollectionViewCell
                
                // The (x) clear button
                let xButton = cell.viewWithTag(100) as! UIButton
                xButton.hidden = false
            }
        } else {
            navigationItem.leftBarButtonItem!.title = "Edit"
            collectionView!.reloadData()
        }
    }
    
    /* Actual delete */
    func deleteMeme(sender: UIButton) {
        let index = sender.layer.valueForKey("index") as! Int
        // Delete from the collection view
        memes.removeAtIndex(index)
        // Delete from the model
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(index)
        collectionView!.reloadData()
    }
}
