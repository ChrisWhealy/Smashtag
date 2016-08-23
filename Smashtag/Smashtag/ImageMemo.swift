//
//  ImageMemo.swift
//  Smashtag
//
//  Created by Whealy, Chris on 03/08/2016.
//  Copyright © 2016 Whealy, Chris. All rights reserved.
//

import Foundation

struct ImageMemo {
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Memo for image data
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  private static var imageMemo = [NSURL:NSData]()

  static func getMemoizedImage(url: NSURL) -> NSData?        { return imageMemo[url] }
  static func setMemoizedImage(url: NSURL, imgData: NSData?) { imageMemo[url] = imgData }
}