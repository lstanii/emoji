//
//  WebAPI.swift
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


class WebAPI: NSObject {
    
    
    // *******************************************************************************************************************************
    // # MARK: Singleton
    
    
    static var sharedAPI : WebAPI = WebAPI()
    
    
    // *******************************************************************************************************************************
    // # MARK: Internal(Public) Methods
    
    
    func doRequest(url : String, completion : (data : AnyObject?, error : NSError?) -> Void) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
            
            if let requestURL : NSURL = NSURL(string: url) {
                
                if let data = NSData(contentsOfURL: requestURL) {
                    completion(data: data, error: nil)
                    
                } else {
                    let error : NSError = NSError(domain: "RETREIVAL_ERROR", code: 0, userInfo: nil)
                    completion(data: nil, error: error)
                }
            }
        }
    }
    
    
}
