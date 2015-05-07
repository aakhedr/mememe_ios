//
//  SentMemesTableViewController.swift
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
        navigationItem.leftBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes

        // Reload table data and configure the table view cell height
        tableView!.reloadData()
        tableView!.rowHeight = 100
    }
    
    // Move to the meme editor (ViewController) in case no memes are saved!
    override func viewDidAppear(animated: Bool) {
        if memes.count == 0 {
            let memeEditorNavigationController = storyboard!.instantiateViewControllerWithIdentifier("memeEditorNC") as! UINavigationController
            presentViewController(memeEditorNavigationController, animated: true, completion: nil)
        }
    }
    
    @IBAction func addNewMeme(sender: UIBarButtonItem) {
        performSegueWithIdentifier("addMeme", sender: sender)
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
        let sentMemeController = storyboard!.instantiateViewControllerWithIdentifier("SentMemeViewController") as! SentMemeViewController
        sentMemeController.meme = self.memes[indexPath.row]
        hidesBottomBarWhenPushed = true
        navigationController!.pushViewController(sentMemeController, animated: true)
        hidesBottomBarWhenPushed = false
    }

    // Delete row
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        if editingStyle == UITableViewCellEditingStyle.Delete {
            memes.removeAtIndex(indexPath.row)
            // Remove item from the model!
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.reloadData()
        }
    }

    // Move a row to another location index
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let item = self.memes.removeAtIndex(sourceIndexPath.row)
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(sourceIndexPath.row)
        
        // Keep the model array sorted as the UITableView class property
        memes.insert(item, atIndex: destinationIndexPath.row)
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.insert(item, atIndex: destinationIndexPath.row)
    }

    /* This superclass method gets called by the table view and has to be overrided the subclass property tableView needs to override it */
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView!.setEditing(editing, animated: animated)
    }
}
