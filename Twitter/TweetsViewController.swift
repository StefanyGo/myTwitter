//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Stefany Felicia on 27/2/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TwitterClient.sharedInstance?.homeTimeline(success: {(tweets: [Tweet]) -> () in
            self.tweets = tweets
            for tweet in tweets {
                    print(tweet.text)
                }
        }, failure: {(error: NSError) -> () in
            print(error.localizedDescription)
                
            })
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
