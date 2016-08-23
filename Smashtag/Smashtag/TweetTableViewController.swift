//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Whealy, Chris on 27/07/2016.
//  Copyright © 2016 Whealy, Chris. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Outlets
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  @IBOutlet weak var searchTextField: UITextField! {
    didSet {
      searchTextField.delegate = self
      searchTextField.text     = searchText
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Public variables
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // An array of arrays corresponds nicely to the sections and rows in a UITableViewController
  var tweets = [Array<Twitter.Tweet>]() { didSet { tableView.reloadData() } }

  var searchText: String? {
    didSet {
      if let str = searchText {
        // Remember what the user searched for
        SearchHistory.insert(str)

        tweets.removeAll()
        searchForTweets()
        title = str
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Public API
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    searchText = textField.text

    return true
  }
  
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Private variables
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  private var twitterRequest: Request? {
    return searchText != nil && !(searchText?.isEmpty)!
      ? Twitter.Request(search: searchText! + " -filter:retweets", count: 100)
      : nil
  }

  private var lastTwitterRequest: Request?

  private struct Storyboard { static let TweetCellIdentifier = "Tweet" }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Private API
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  private func searchForTweets() {
    if let request = twitterRequest {
      lastTwitterRequest = request

      request.fetchTweets { [weak weakSelf = self] newTweets in
        dispatch_async(dispatch_get_main_queue()) {
          if request == weakSelf?.lastTwitterRequest &&
             !newTweets.isEmpty {
            weakSelf?.tweets.insert(newTweets, atIndex: 0)
          }
        }
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Overridden functions from superclass
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.estimatedRowHeight = tableView.rowHeight
    tableView.rowHeight          = UITableViewAutomaticDimension
  }

  override func numberOfSectionsInTableView(tableView: UITableView)                   -> Int { return tweets.count }
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return tweets[section].count }

  // Template for building one row of the table view
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetCellIdentifier, forIndexPath: indexPath) as! TweetTableViewCell

    cell.tweet = tweets[indexPath.section][indexPath.row]

    return cell
  }

  // Segue to show the details of one tweet
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    var destVC = segue.destinationViewController

    if let navCon = destVC as? UINavigationController {
      destVC = navCon.visibleViewController ?? destVC
    }

    if let tweetDetailVC = destVC as? TweetDetailTableViewController,
           selectedRow   = sender as? TweetTableViewCell {
      tweetDetailVC.tweet = selectedRow.tweet
      tweetDetailVC.navigationItem.title = selectedRow.tweet?.user.name
    }
  }
}
