//
//  EmojiManager.swift
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


class EmojiManager: NSObject {
    
    
    // *******************************************************************************************************************************
    // # MARK: Public Methods
    
    
    func downloadEmojiImage( emoji : Emoji, completion : (error : NSError?) -> Void ) {
        
        WebAPI.sharedAPI.doRequest(emoji.url) { (data, error) -> Void in
            
            if (error != nil) {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(error: error)
                })
                
            } else {
                
                if let data$ = data as? NSData {
                    
                    if let image : UIImage = UIImage(data: data$) {
                        emoji.image = image
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(error : nil)
                        })
                    }
                }
            }
            
            if (emoji.image == nil) {
                let error : NSError = NSError(domain: "DOWNLOAD_ERROR", code: 0, userInfo: nil)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(error: error)
                })
            }
        }
    }
    
    
    func downloadEmojis(completion : (emojis : [Emoji]?, error : NSError?) -> Void) {
        
        let url : String = "https://api.github.com/emojis"
        WebAPI.sharedAPI.doRequest(url) { (data, error) -> Void in
            
            if error != nil {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(emojis: nil, error: error)
                })
                
            } else if let responseData = data as? NSData {
                
                if let response : NSString = NSString(data: responseData, encoding: NSUTF8StringEncoding) {
                    
                    do {
                        let JSONData = response.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                        
                        let JSONDictionary : NSDictionary = try NSJSONSerialization.JSONObjectWithData(JSONData!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                        
                        let dict = JSONDictionary as Dictionary
                        var emojis : [Emoji] = []
                        
                        for (key, value) in dict {
                            let emoji : Emoji = Emoji()
                            
                            if let name : String = key as? String {
                                emoji.name = name
                            }
                            
                            if let url : String = value as? String {
                                emoji.url = url
                            }
                            
                            emojis.append(emoji)
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(emojis: emojis, error: nil)
                        })
                        
                    } catch let parseError {
                        print("Parse Error\(parseError)")
                        
                        let error : NSError = NSError(domain: "PARSE_ERROR", code: 0, userInfo: nil)
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(emojis: nil, error: error)
                        })
                    }
                }
            }
        }
    }
    
    
}
