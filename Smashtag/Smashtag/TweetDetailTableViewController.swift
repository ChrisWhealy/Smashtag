//
//  TweetDetailTableViewController.swift
//  Smashtag
//
//  Created by Whealy, Chris on 05/08/2016.
//  Copyright © 2016 Whealy, Chris. All rights reserved.
//

import UIKit
import Twitter

class TweetDetailTableViewController: UITableViewController {
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Public variables
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  var tweet: Twitter.Tweet? = nil

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Private variables
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  var defaultRowHeight: CGFloat = 28

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Private API
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  private func makeTableViewCell(tv: UITableView, ip: NSIndexPath, s: String) -> TweetDetailTableViewCell? {
    if let tweetCell = tableView.dequeueReusableCellWithIdentifier(s, forIndexPath: ip) as? TweetDetailTableViewCell
       where tweet?.sectionSize(ip.section) > 0 {
      tweetCell.buildTableCells(tweet!, indexPath: ip)

      return tweetCell
    }
    else {
      return nil
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Overridden functions from superclass
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  override func numberOfSectionsInTableView(tv: UITableView)                     -> Int     { return 4 }
  override func tableView(tv: UITableView, numberOfRowsInSection section: Int)   -> Int     { return tweet?.sectionSize(section) ?? 1 }
  override func tableView(tv: UITableView, titleForHeaderInSection section: Int) -> String? { return tweet?.titleForSection(section) }

  override func tableView(tv: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return makeTableViewCell(tableView, ip: indexPath, s: tweet?.titleForSection(indexPath.section) ?? "") ?? UITableViewCell()
  }

  override func tableView(tv: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if let tw = tweet
       where indexPath.section == 0 && tweet?.media.count > 0 {
      return tv.frame.width / CGFloat(tw.media[indexPath.row].aspectRatio)
    }
    else {
      return defaultRowHeight
    }

  }

  // Segue to show the details of one tweet
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    var destVC = segue.destinationViewController

    // Just check we don't have to pass through a navigation controller...
    if let navCon = destVC as? UINavigationController {
      destVC = navCon.visibleViewController ?? destVC
    }

    // It would be pretty strange if the selected row was not an instance of TweetDetailTableViewCell, but
    // let's just check anyway...
    if let selectedRow = sender as? TweetDetailTableViewCell {

      // To where are we segueing?
      if let tweetImageVC = destVC as? TweetImageViewController {
        tweetImageVC.image = selectedRow.tweetImage.image
      }
      else if let tweetTableVC = destVC as? TweetTableViewController {
        tweetTableVC.searchText = segue.identifier == "Show Hash Tags"
                                  ? selectedRow.tweetHashTag.text
                                  : selectedRow.tweetUserMention.text
      }
    }
  }
}
