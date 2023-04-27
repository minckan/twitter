//
//  SlideInPresentationManager.swift
//  TwiterApp
//
//  Created by MZ01-MINCKAN on 2023/04/27.
//

import UIKit

final class SlideInPresentationManager: NSObject {
    var ratio: CGFloat = 0.75
    var transition = SlideInTransition()
}

// MARK: - UIViewControllerTransitioningDelegate
extension SlideInPresentationManager: UIViewControllerTransitioningDelegate {
  func presentationController(
    forPresented presented: UIViewController,
    presenting: UIViewController?,
    source: UIViewController
  ) -> UIPresentationController? {
    let presentationController = (
      presentedViewController: presented,
      presenting: presenting,
      ratio: ratio
    )
    return presentationController
  }

  func animationController(
    forPresented presented: UIViewController,
    presenting: UIViewController,
    source: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
      transition.isPresenting = true
      return transition
  }

  func animationController(
    forDismissed dismissed: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
      transition.isPresenting = false
      return transition
  }
}
