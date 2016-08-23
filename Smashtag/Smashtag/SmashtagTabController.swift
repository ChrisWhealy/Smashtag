//
//  SmashtagTabController.swift
//  Smashtag
//
//  Created by Whealy, Chris on 22/08/2016.
//  Copyright © 2016 Whealy, Chris. All rights reserved.
//

import UIKit

class SmashtagTabController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()

    tabBar.items?[0].title = "Tweets"
    tabBar.items?[0].image = UIImage(named: "icon-twitter")

    tabBar.items?[1].title = "Search History"
    tabBar.items?[1].image = UIImage(named: "icon-history")
  }
}