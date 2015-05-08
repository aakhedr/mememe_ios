//
//  SentMemeViewController.swift
//  Mememe
//
//  Created by Ahmed Khedr on 5/2/15.
//  Copyright (c) 2015 Ahmed Khedr. All rights reserved.
//

import UIKit

class SentMemeViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    var meme: Meme!

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        image.image = meme!.memedImage
        
        // Background like the Photos app
        view!.backgroundColor = UIColor.blackColor()

        // Show image in a better way
        navigationController!.hidesBarsOnTap = true
    }
}
