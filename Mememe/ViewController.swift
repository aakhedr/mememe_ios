//
//  ViewController.swift
//  Mememe
//
//  Created by Ahmed Khedr on 4/30/15.
//  Copyright (c) 2015 Ahmed Khedr. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var image: UIImageView!

    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelSharingButton: UIBarButtonItem!
    
    /* Meme textFields attributes */
    let memeTextAttributes = [ NSStrokeColorAttributeName: UIColor.blackColor(), NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, NSStrokeWidthAttributeName: -3.0 ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set textFields default texts
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        // Define UITextFieldDelegate
        topTextField.delegate = self
        bottomTextField.delegate = self

        
        // Set the default textFields attributes
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
    }
    
    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
        // This ViewController subscribes to NSKeybaordWillShowNotifiaction
        self.subscribeToKeyboardNotifications()
        
        // In case no image is picked disable shareButton
        if let iamge = image.image {
            shareButton.enabled = true
        } else {
            shareButton.enabled = false
        }

        /* REVISIT THIS!!! */
        // Hide the previous navigation controller tab bar
        self.navigationController!.tabBarController!.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)

        // Now this ViewController unscubscribes from NSKeyboardWillShowNotification
        self.unsubscribeFromKeyboardNotifications()
    }

    /* UIImagePickerControllerDelegate methods (2) */
    
    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem) {

        let imagePicker = UIImagePickerController()

        // Define UIImagePickerControllerDelegate
        imagePicker.delegate = self
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary

        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {

        let imagePicker = UIImagePickerController()

        // Define UIIMagePickerControllerDelegate
        imagePicker.delegate = self

        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera

        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = saveMemeAfterSharing
        self.presentViewController(activityController, animated: true, completion: nil)
    }

    func saveMemeAfterSharing(activity: String!, completed: Bool, items: [AnyObject]!, error: NSError!) {
        if completed {
            println("saveMemeAfterSharing called")
            save()
            dismissViewControllerAnimated(true, completion: nil)
            /* INSTANTIATE TAB BAR VIEW HERE */
            self.navigationController!.navigationController!.popToRootViewControllerAnimated(true)
        }
    }

    @IBAction func cancelSharingMeme(sender: UIBarButtonItem) {

        // There are two navigation controllers (See storyboard!)
        self.navigationController!.navigationController!.popToRootViewControllerAnimated(true)
    }
    
    /* UIImagePickerController methods (2) */
    /* In case a user picks an image */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {

        // Dismiss current modal Picker View first!
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image.image = image
        }
    }
    
    /* In case a user doesn't pick an image */                                       // There might be no need to implement this!
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /* UITextFieldDelegate methods (2) */
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }

    /* Move the view when the textFields is tabbed and keybaord shows (4 methods) */

    func subscribeToKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    func keyboardWillShow(notification: NSNotification) {
        
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        // Claculate keyboard height only if editing bottomTextField
        if bottomTextField.editing {
            
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
            return keyboardSize.CGRectValue().height
            
        } else {
            
            // Otherwise do not move view up (editing topTextField)
            return 0
        }
    }

    /* Move the view back when done typing textFields and keyboard disappears (1 extra method) */
    
    func keyboardWillHide(notification: NSNotification) {
        
        self.view.frame.origin.y += getKeyboardHeight(notification)
    }

    /* Talk to the model */
    /* Prepare teh memedImage first */
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // Show toolbar and navbar
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        return memedImage
    }
    
    func save() {
        
        var meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: image.image!, memedImage: generateMemedImage())
        
        // Add the meme to the memes array in the Application Delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        println((UIApplication.sharedApplication().delegate as! AppDelegate).memes.count)
    }
}








