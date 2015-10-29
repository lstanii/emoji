//
//  EmojiCell.swift
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


class EmojiCell : UITableViewCell {
    
    
    // *******************************************************************************************************************************
    // # MARK: Public Properties
    
    
    weak var emoji : Emoji?
    @IBOutlet var emojiImageView : UIImageView?
    @IBOutlet var emojiTextLabel : UILabel?
    
    
    
}
