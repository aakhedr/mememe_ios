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
    @IBOutlet weak var albumButton: UIBarButtonItem!                                    // There might be no need for this property!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
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
    }

    /* UIImagePickerControllerDelegate methods (2) */
    /* Note: UIImageControllerDelegate has to conform with UINavigationController */
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

    /* UIImagePickerController methods (2) */
    /* In case a user picks an image */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {

        // Dismiss current modal Picker View first!
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image.image = image
        }
    }
    
    /* In case a user doesn't pick an image                                         // Ther might be no need to implement this! */
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

    /* Meme textFields attributes */
    let memeTextAttributes = [ NSStrokeColorAttributeName: UIColor.blackColor(), NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, NSStrokeWidthAttributeName: 3.0 ]
}

