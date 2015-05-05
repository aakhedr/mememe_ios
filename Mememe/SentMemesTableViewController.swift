//
//  MemeTableViewController.swift
//  Mememe
//
//  Created by Ahmed Khedr on 5/2/15.
//  Copyright (c) 2015 Ahmed Khedr. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
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
        self.tableView!.reloadData()
        
        println("Size of memes array (tableViewController) = \(memes.count)")
        
        if memes.count == 0 {
            addNewMeme(addButton)
        }
    }
    
    @IBAction func addNewMeme(sender: UIBarButtonItem) {
        performSegueWithIdentifier("addMeme", sender: sender)
        
        /* REVISIT THIS!!! */
        // Hide the previous navigation controller tab bar
        self.tabBarController!.tabBar.hidden = true

    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        println("numberOfRowsInSection is called: \(memes.count)")
        return memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        println("cellForRowAtIndexPath is called")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell") as! UITableViewCell
        
        println("tableCell = \(cell)")
        
        let meme = self.memes[indexPath.row]
        cell.imageView?.image = meme.memedImage
        cell.imageView?.sizeToFit()
        
        cell.textLabel!.text = meme.topText
        cell.detailTextLabel!.text = meme.bottomText
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("didSelectRowAtIndexPath is called")
        
        let sentMemeController = self.storyboard!.instantiateViewControllerWithIdentifier("SentMemeViewController") as! SentMemeViewController
        sentMemeController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(sentMemeController, animated: true)
    }
}