//
//  ContainerViewController.swift
//  barbot
//
//  Created by Naveen Yadav on 4/10/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

//  TODO: Fix pan gesture to move left only

import UIKit


enum SlideOutState {
    case Collapsed
    case LeftPanelExpanded
    case Expanding
}

class ContainerViewController: UIViewController {
    
    let centerPanelExpandedOffset: CGFloat = 60
  
    var centerNavigationController: UINavigationController!
    var menuTableViewController: MenuTableViewController!
    var currentState: SlideOutState = .Collapsed {
        didSet {
            let shouldShowShadow = currentState != .Collapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    var leftViewController: SidePanelViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuTableViewController = UIStoryboard.menuTableViewController()
        self.menuTableViewController.delegate = self

        // wrap the centerViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        self.centerNavigationController = UINavigationController(rootViewController: self.menuTableViewController)
        view.addSubview(self.centerNavigationController.view)
        addChildViewController(self.centerNavigationController)

        self.centerNavigationController.didMoveToParentViewController(self)
        
        //let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ContainerViewController.handlePanGesture(_:)))
        //centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
    }
  
}

// MARK: MenuTableViewController delegate

extension ContainerViewController: MenuTableViewControllerDelegate {
    
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(notAlreadyExpanded)
    }
    
    func addLeftPanelViewController() {
        if (leftViewController == nil) {
            leftViewController = UIStoryboard.leftViewController()
            leftViewController!.settings = Setting.allSettings()
            
            addChildSidePanelController(leftViewController!)
        }
    }
    
    func addChildSidePanelController(sidePanelController: SidePanelViewController) {
        view.insertSubview(sidePanelController.view, atIndex: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    func animateLeftPanel(shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .LeftPanelExpanded
            
            animateCenterPanelXPosition(CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(0) { finished in
                self.currentState = .Collapsed
                
                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController = nil;
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if shouldShowShadow {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
}

extension ContainerViewController: UIGestureRecognizerDelegate {
    // MARK: Gesture recognizer
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
        
        switch(recognizer.state) {
            case .Began:
                if currentState == .Collapsed {
                    if gestureIsDraggingFromLeftToRight {
                        addLeftPanelViewController()
                        showShadowForCenterViewController(true)
                        currentState = .Expanding
                    }
                }
                if currentState == .LeftPanelExpanded {
                    if !gestureIsDraggingFromLeftToRight {
                        currentState = .Expanding
                    }
                }
            case .Changed:
                if currentState == .Expanding {
                    print(recognizer.velocityInView(view).x)
                    if gestureIsDraggingFromLeftToRight {
                        recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
                        recognizer.setTranslation(CGPointZero, inView: view)
                    }
                }
            case .Ended:
                if leftViewController != nil {
                    // animate the side panel open or closed based on whether the view has moved more or less than halfway
                    let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
                    animateLeftPanel(hasMovedGreaterThanHalfway)
                }
            default:
                break
        }
    }
}

private extension UIStoryboard {
  class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
  
  class func leftViewController() -> SidePanelViewController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("LeftViewController") as? SidePanelViewController
  }
  
  class func menuTableViewController() -> MenuTableViewController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("MenuTableViewController") as? MenuTableViewController
  }
  
}