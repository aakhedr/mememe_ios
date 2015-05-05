//
//  MemeTableViewController.swift
//  Mememe
//
//  Created by Ahmed Khedr on 5/2/15.
//  Copyright (c) 2015 Ahmed Khedr. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var memes = [Meme]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add edit button
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController!.tabBar.hidden = false

        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes

        // Reload table data and configure the table view cell height
        self.tableView!.reloadData()
        self.tableView!.rowHeight = 100

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
    
    /********** UITableViewDelegate and UITableViewDataSource methods (3) **************/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell") as! UITableViewCell
        
        let meme = self.memes[indexPath.row]
        cell.imageView?.image = meme.memedImage
        cell.imageView?.sizeToFit()
        
        cell.textLabel!.text = meme.topText
        cell.detailTextLabel!.text = meme.bottomText
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sentMemeController = self.storyboard!.instantiateViewControllerWithIdentifier("SentMemeViewController") as! SentMemeViewController
        sentMemeController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(sentMemeController, animated: true)
    }

    // Delete row
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.memes.removeAtIndex(indexPath.row)
            // Remove item from the model!
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView!.reloadData()
        }
    }

    // Move a row to another location index
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let item = self.memes.removeAtIndex(sourceIndexPath.row)
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(sourceIndexPath.row)
        
        // Keep the model array sorted as the UITableView class property
        self.memes.insert(item, atIndex: destinationIndexPath.row)
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.insert(item, atIndex: destinationIndexPath.row)
    }

    /* This superclass method gets called by the table view and has to be overrided the subclass property tableView needs to override it */
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView!.setEditing(editing, animated: animated)
    }
}
