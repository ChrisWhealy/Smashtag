//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Whealy, Chris on 03/08/2016.
//  Copyright © 2016 Whealy, Chris. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {
  typealias LabelString = NSMutableAttributedString

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Outlets
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  @IBOutlet weak var tweetScreenNameLabel : UILabel!
  @IBOutlet weak var tweetTextLabel       : UILabel!
  @IBOutlet weak var tweetProfileImageView: UIImageView!
  @IBOutlet weak var tweetCreatedLabel    : UILabel!

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Public variables
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  var tweet: Twitter.Tweet? { didSet { updateUI() } }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Private variables
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  private let midRed   = UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 1)
  private let midGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1)
  private let midBlue  = UIColor(red: 0.0, green: 0.0, blue: 0.5, alpha: 1)

  private let oneDay: Double = 24 * 60 * 60

  private let formatter = NSDateFormatter()

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Private API
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  private func updateUI() {
    // Reset any existing tweet information
    tweetTextLabel?.attributedText = nil
    tweetScreenNameLabel?.text     = nil
    tweetProfileImageView?.image   = nil
    tweetCreatedLabel?.text        = nil

    // Load new information from our tweet (if any)
    if let tweet = self.tweet {
      // Apply formatting to the tweet's text
      tweetTextLabel?.attributedText = formatTweetText(tweet)
      tweetScreenNameLabel?.text     = "\(tweet.user)" // tweet.user.description

      // Get the user's image in a separate thread
      if let profileImageURL = tweet.user.profileImageURL {
        fetchImage(profileImageURL)
      }

      if NSDate().timeIntervalSinceDate(tweet.created) > oneDay {
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
      }
      else {
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
      }

      tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
    }
  }

  private func formatTweetText(tweet: Tweet) -> LabelString {
    // Change URLs to blue, hashtags to green and mentions to red
    let labelStr = LabelString(string: tweet.text)

    var _ = tweet.urls.map         { setTextColour(labelStr, colour: midBlue,  range: $0.nsrange) }
    var _ = tweet.hashtags.map     { setTextColour(labelStr, colour: midGreen, range: $0.nsrange) }
    var _ = tweet.userMentions.map { setTextColour(labelStr, colour: midRed,   range: $0.nsrange) }

    return labelStr
  }

  private func setTextColour(labelStr: LabelString, colour: UIColor, range: NSRange) {
    labelStr.addAttribute(NSForegroundColorAttributeName, value: colour,  range: range)
  }

  private func fetchImage(imageURL: NSURL?) {
    if let url = imageURL {
      dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
        if ImageMemo.getMemoizedImage(url) == nil {
          ImageMemo.setMemoizedImage(url, imgData: NSData(contentsOfURL: url))
        }

        dispatch_async(dispatch_get_main_queue()) { [weak weakSelf = self] in
          if url == imageURL {
            weakSelf?.tweetProfileImageView?.image = UIImage(data: ImageMemo.getMemoizedImage(url)!)
          }
        }
      }
    }
  }
}






