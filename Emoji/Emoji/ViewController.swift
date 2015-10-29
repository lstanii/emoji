//
//  ViewController.swift
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


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // *******************************************************************************************************************************
    // # MARK:  Internal(Public) Properties
    
    
    @IBOutlet var activityIndicator : UIActivityIndicatorView?
    var refreshControl : UIRefreshControl = UIRefreshControl()
    @IBOutlet var tableView : UITableView?
    
    
    // *******************************************************************************************************************************
    // # MARK: Private Properties
    
    
    private var emojiManager : EmojiManager = EmojiManager()
    private var emojis : [Emoji] = []
    
    
    // *******************************************************************************************************************************
    // # MARK: Overrides
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        self.loadEmojis()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: Selector("refresh"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView?.addSubview(refreshControl)
        
        self.loadEmojis()
    }
    
    
    // *******************************************************************************************************************************
    // # MARK: Private Methods
    
    
    private func hideSpinner() {
        self.activityIndicator?.stopAnimating()
    }
    
    
    private func showSpinner() {
        self.activityIndicator?.startAnimating()
    }
    
    
    // *******************************************************************************************************************************
    // # MARK: Internal(Public) Methods
    
    
    
    func loadEmojis() {
        self.emojis = []
        self.tableView?.reloadData()
        self.showSpinner()
        
        emojiManager.downloadEmojis { (emojis, error) -> Void in
            
            if error != nil  {
                self.showAlert("Error", message: "Error Loading Emojis")
                
            } else {
                
                if let emojis$ = emojis {
                    self.emojis = emojis$
                }
                
                self.tableView?.reloadData()
            }
            
            self.hideSpinner()
        }
    }
    
    
    func refresh() {
        self.refreshControl.endRefreshing()
        self.loadEmojis()
    }
    
    
    
    private func showAlert(title : String, message : String) {
        let controller = UIAlertController(title: title,
            message: message,
            preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK",
            style: .Default,
            handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    
    // *******************************************************************************************************************************
    // # MARK: Delegates
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let emoji : Emoji = self.emojis[indexPath.row]
        
        let cell : EmojiCell = tableView.dequeueReusableCellWithIdentifier("cell") as! EmojiCell
        cell.emojiTextLabel?.text = emoji.name
        cell.emoji = emoji
        cell.emojiImageView?.image = nil
        
        emoji.cell = cell
        
        if let image = emoji.image {
            
            cell.emojiImageView?.image = image
            
        } else if emoji.image == nil {
            
            cell.emojiImageView?.image = nil
            self.emojiManager.downloadEmojiImage(emoji, completion: { (error) -> Void in
                
                if let cell$ = emoji.cell {
                    
                    if cell$.emoji == emoji {
                        
                        if error != nil {
                            cell$.emojiImageView?.image = UIImage(named: "notFound.jpeg")
                            
                        } else {
                            cell$.emojiImageView?.image = emoji.image
                        }
                    }
                }
            })
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.emojis.count
    }
    
    
}

