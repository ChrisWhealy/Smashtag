//
//  TweetImageViewController.swift
//  Smashtag
//
//  Created by Whealy, Chris on 19/08/2016.
//  Copyright © 2016 Whealy, Chris. All rights reserved.
//

import UIKit

class TweetImageViewController: UIViewController, UIScrollViewDelegate {
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Outlets
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  @IBOutlet weak var scrollView: UIScrollView! {
    didSet {
      scrollView.contentSize = imageView.frame.size

      // Make this view controller the delegate for handling the all the
      // view's processing requirements - such as zoom etc
      scrollView.delegate         = self
      scrollView.minimumZoomScale = 0.03
      scrollView.maximumZoomScale = 1.0    // This is the default
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Public variables
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  var image: UIImage? {
    get { return imageView.image }

    set { imageView.image = newValue
          imageView.sizeToFit()
          scrollView?.contentSize = imageView.frame.size
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Public API
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? { return imageView }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Private variables
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  private var imageView = UIImageView()

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Overridden methods from superclass
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  override func viewDidLoad() {
    super.viewDidLoad()
    scrollView.addSubview(imageView)
  }
}


