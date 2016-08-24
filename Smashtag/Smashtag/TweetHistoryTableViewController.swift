//
//  TweetHistoryViewController.swift
//  Smashtag
//
//  Created by Whealy, Chris on 22/08/2016.
//  Copyright © 2016 Whealy, Chris. All rights reserved.
//

import UIKit

var globalTweetHistoryVCCount = 0

class TweetHistoryTableViewController: UITableViewController {
  @IBAction func deleteHistory() {
    SearchHistory.removeAll()
    tableView.reloadData()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Overridden functions from superclass
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  override func viewDidLoad() { super.viewDidLoad() }

  override func numberOfSectionsInTableView(tv: UITableView) -> Int  { return 1 }

  override func tableView(tv: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if (editingStyle == UITableViewCellEditingStyle.Delete) {
      SearchHistory.removeAtIndex(indexPath.row)
      tv.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
  }

  override func tableView(tv: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool { return true }
  override func tableView(tv: UITableView, numberOfRowsInSection section: Int)           -> Int  { return SearchHistory.list().count }

  // Template for building one row of the table view
  override func tableView(tv: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tv.dequeueReusableCellWithIdentifier("TweetHistoryItem", forIndexPath: indexPath) as! TweetHistoryTableViewCell
    cell.searchString = SearchHistory.list()[indexPath.row]
    return cell
  }

  // Segue to show the details of one tweet
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    var destVC = segue.destinationViewController

    if let navCon = destVC as? UINavigationController {
      destVC = navCon.visibleViewController ?? destVC
    }

    if let tweetTableVC = destVC as? TweetTableViewController,
           searchString = sender as? TweetHistoryTableViewCell {
      tweetTableVC.searchText = searchString.searchText.text
      tweetTableVC.navigationItem.title = searchString.searchText.text
    }
  }

  // The search history table doesn't refresh after a new entry is created unless refreshData() is called from here
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    tableView.reloadData()
  }
}


