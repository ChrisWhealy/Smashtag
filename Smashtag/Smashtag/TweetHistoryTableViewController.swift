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
  override func viewDidLoad() {
    super.viewDidLoad()
    logVCL("viewDidLoad()")
  }

  override func numberOfSectionsInTableView(tv: UITableView) -> Int  { return 1 }

  override func tableView(tv: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if (editingStyle == UITableViewCellEditingStyle.Delete) {
      SearchHistory.removeAtIndex(indexPath.row)
      tv.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
  }

  override func tableView(tv: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool { return true }
  override func tableView(tv: UITableView, numberOfRowsInSection section: Int)           -> Int  {
    print("TweetHistoryTableViewController: numberOfRowsInSection: \(SearchHistory.list().count)")
    return SearchHistory.list().count
  }

  // Template for building one row of the table view
  override func tableView(tv: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    print("TweetHistoryTableViewController: cellForRowAtIndexPath: index path = (\(indexPath.section),\(indexPath.row))")

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

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // View Controller Lifecycle stuff
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  var instanceCount: Int = {
    globalTweetHistoryVCCount += 1
    return globalTweetHistoryVCCount
  }()

  func logVCL(msg: String) {
    print(logVCLprefix + "Tweet search history \(instanceCount) " + msg)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    logVCL("init?(coder)")
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    logVCL("init(nibName=\(nibNameOrNil), bundle)")
  }

  deinit { logVCL("deinit") }

  override func awakeFromNib() { logVCL("awakeFromNib()") }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    logVCL("viewWillAppear(animated = \(animated)) - reloading data")
    tableView.reloadData()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    logVCL("viewDidAppear(animated = \(animated))")
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    logVCL("viewWillDisappear(animated = \(animated))")
  }

  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    logVCL("viewDidDisappear(animated = \(animated))")
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    logVCL("viewWillLayoutSubviews() bounds.size = \(view.bounds.size)")
  }
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    logVCL("viewDidLayoutSubviews() bounds.size = \(view.bounds.size)")
  }

  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    logVCL("viewWillTransitionToSize")

    coordinator.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
      self.logVCL("animatingAlongsideTransition")
      }, completion: { context -> Void in
        self.logVCL("doneAnimatingAlongsideTransition")
    })
  }

}


