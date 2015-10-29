//
//  Emoji.swift
//  Emoji
//
//  Created by Lorenzo S on 10/29/15.
//  Copyright © 2015 Apple. All rights reserved.
//


// *******************************************************************************************************************************
// # MARK: Imports


import UIKit


// *******************************************************************************************************************************
// # MARK: Implementation


class Emoji: NSObject {
    
    
    // *******************************************************************************************************************************
    // # MARK: Public Properties
    
    
    weak var cell : EmojiCell?
    var image : UIImage?
    var name : String = ""
    var url : String = ""
    
    
}
