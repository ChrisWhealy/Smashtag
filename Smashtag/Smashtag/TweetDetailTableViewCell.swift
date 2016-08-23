//
//  TweetDetailTableViewCell.swift
//  Smashtag
//
//  Created by Whealy, Chris on 05/08/2016.
//  Copyright © 2016 Whealy, Chris. All rights reserved.
//

import UIKit
import Twitter

class TweetDetailTableViewCell: UITableViewCell {
  typealias LabelString = NSMutableAttributedString

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Outlets
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  @IBOutlet weak var tweetImage       : UIImageView!
  @IBOutlet weak var tweetHashTag     : UILabel!
  @IBOutlet weak var tweetUserMention : UILabel!
  @IBOutlet weak var tweetURL         : UILabel!

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Public variables
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  var imageURL: NSURL? = nil

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Private variables
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  private let midRed   = UIColor(red: 0.5,   green: 0.0,   blue: 0.0,   alpha: 1)
  private let midGreen = UIColor(red: 0.0,   green: 0.5,   blue: 0.0,   alpha: 1)
  private let midBlue  = UIColor(red: 0.0,   green: 0.0,   blue: 0.5,   alpha: 1)

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Public API
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  func urlTapped(sender: UITapGestureRecognizer!) {
    if let label = sender.view as? UILabel {
      UIApplication.sharedApplication().openURL(NSURL(string: label.text!)!)
    }
  }

  func buildTableCells(maybeTweet: Tweet?, indexPath: NSIndexPath) {
    if let t = maybeTweet {
      if indexPath.section == 0 {
        imageURL = t.media[indexPath.row].url
        buildImage(tweetImage, mi: t.media[indexPath.row])
      }
      else if indexPath.section == 1 {
        tweetHashTag.attributedText = formatLabelStr(t.hashtags[indexPath.row].keyword, colour: midGreen)
      }
      else if indexPath.section == 2 {
        tweetUserMention.attributedText = formatLabelStr(t.userMentions[indexPath.row].keyword, colour: midRed)
      }
      else if indexPath.section == 3 {
        tweetURL.attributedText = formatLabelStr(t.urls[indexPath.row].keyword, colour: midBlue)
        tweetURL.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TweetDetailTableViewCell.urlTapped(_:))))
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Private API
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  private func formatLabelStr(labelText: String, colour: UIColor) -> LabelString {
    let labStr = LabelString(string: labelText)
    labStr.addAttribute(NSForegroundColorAttributeName, value: colour, range: NSRange(location: 0, length: labelText.characters.count))

    return labStr
  }

  private func buildImage(imageView: UIImageView?, mi: MediaItem) {
    if let url = mi.url {
      dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
        if ImageMemo.getMemoizedImage(url) == nil {
          ImageMemo.setMemoizedImage(url, imgData: NSData(contentsOfURL: url))
        }

        dispatch_async(dispatch_get_main_queue()) { [weak weakSelf = self] in
          if url == weakSelf?.imageURL {
            imageView!.image = UIImage(data: ImageMemo.getMemoizedImage(url)!)
          }
        }
      }
    }
  }
}


