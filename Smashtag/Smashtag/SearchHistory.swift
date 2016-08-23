//
//  SearchHistory.swift
//  Smashtag
//
//  Created by Whealy, Chris on 22/08/2016.
//  Copyright © 2016 Whealy, Chris. All rights reserved.
//

import Foundation

let defaults = NSUserDefaults.standardUserDefaults()
let objName  = "searchHistory"

struct SearchHistory {
  private static var searches: Array<String> = {
    if let sh = defaults.arrayForKey(objName) {
      return sh.reduce([String]()) { $0 + ["\($1)"] }
    }
    else {
      return [String]()
    }
  }()

  static func insert(str: String) {
    // Are there more than 100 items in the search history?
    if searches.count <= 100 {
      // Does the search term already exist in the array?
      if let idx = searches.indexOf(str) {
        // So remove it from its current location
        searches.removeAtIndex(idx)
      }

      // Insert it at the front of the array
      searches.insert(str, atIndex: 0)
      defaults.setObject(searches, forKey: objName)
    }
  }

  static func list() -> [String]  { return searches }
  static func removeAtIndex(idx: Int) {
    if idx >= 0 &&
       idx < searches.count {
      searches.removeAtIndex(idx)
    }
  }

  static func removeAll() {
    searches.removeAll()
    defaults.setObject(searches, forKey: objName)
  }
}
