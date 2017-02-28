//
//  TwitterClient.swift
//  Twitter
//
//  Created by Stefany Felicia on 27/2/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "dfXosGt7CsSKXytrk7NYUZuWU", consumerSecret: "x5YSKcoRNVCDyCNGCybBexGlE1PgILrxtAu38AV0tgRB15wJJ0")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError)->())?
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (NSError) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: {(task: URLSessionDataTask, response: Any?) -> Void in
            //  print("account: \(response)")
            let userDictionary = response as! NSDictionary
            //   print("user: \(user)")
            let user = User(dictionary: userDictionary)
            
            success(user)
            
            print("name: \(user.name)")
            print("screenname: \(user.screenname)")
            print("profile url: \(user.profileUrl)")
            print("description: \(user.tagline)")
        }, failure: {(task: URLSessionDataTask?, error: Error) -> Void in
            failure(error as NSError)
        })
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError)-> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: {(task: URLSessionDataTask, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            for tweet in tweets {
               
            }
        }, failure: {(task: URLSessionDataTask?, error: Error) -> Void in
            
        })
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: {(accessToken: BDBOAuth1Credential?) -> Void in
            
            self.currentAccount(success: {(user: User)->() in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: {(error: NSError) -> () in
                self.loginFailure?(error)
            })
        }) { (error: Error?) -> Void in
            print(error?.localizedDescription)
            self.loginFailure?(error as! NSError)
        }
    
    }
    
    func login(success:@escaping ()->(), failure: @escaping (NSError)->()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth") as URL!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            print("I got a token!")
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)")
            UIApplication.shared.openURL(url! as URL)
        }, failure: { (error: Error?) -> Void in
            print(error?.localizedDescription as Any)
            self.loginFailure?(error as! NSError)
        })

    }

}
