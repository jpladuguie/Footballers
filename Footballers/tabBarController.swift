//
//  tabBarController.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 25/11/2016.
//  Copyright © 2016 Jean-Pierre Laduguie. All rights reserved.
//

import UIKit
import SlidingTabBar

class tabBarController: UITabBarController, SlidingTabBarDataSource, SlidingTabBarDelegate, UITabBarControllerDelegate {
    
    var tabBarView: SlidingTabBar!
    var fromIndex: Int!
    var toIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.isHidden = true
        self.selectedIndex = 0
        self.delegate = self
        
        // Increase tab bar height.
        var frame: CGRect = self.tabBar.frame
        frame.origin.y -= 11
        frame.size.height += 11
        
        
        
        tabBarView = SlidingTabBar(frame: frame, initialTabBarItemIndex: self.selectedIndex)
        tabBarView.tabBarBackgroundColor = darkGrey
        tabBarView.tabBarItemTintColor = UIColor.gray
        tabBarView.selectedTabBarItemTintColor = UIColor.white
        tabBarView.selectedTabBarItemColors = [lightGrey, lightGrey, lightGrey]
        tabBarView.slideAnimationDuration = 0.3
        tabBarView.datasource = self
        tabBarView.delegate = self
        tabBarView.setup()
        
        self.view.addSubview(tabBarView)
    }

    // MARK: - SlidingTabBarDataSource
    
    func tabBarItemsInSlidingTabBar(tabBarView: SlidingTabBar) -> [UITabBarItem] {
        return tabBar.items!
    }
    
    // MARK: - SlidingTabBarDelegate
    
    func didSelectViewController(tabBarView: SlidingTabBar, atIndex index: Int, from: Int) {
        self.fromIndex = from
        self.toIndex = index
        self.selectedIndex = index
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return SlidingTabAnimatedTransitioning(transitionDuration: 0.4, direction: .Both,
                                               fromIndex: self.fromIndex, toIndex: self.toIndex)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
