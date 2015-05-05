//
//  TextFieldDelegate.swift
//  Mememe
//
//  Created by Ahmed Khedr on 5/5/15.
//  Copyright (c) 2015 Ahmed Khedr. All rights reserved.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {

    /************** UITextFieldDelegate methods (2) *************/
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}