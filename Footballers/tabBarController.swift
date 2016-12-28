import UIKit
import SlidingTabBar

// Tab bar controller class.
// Uses a custom tab bar from the SlidingTabBar library.
class tabBarController: UITabBarController, SlidingTabBarDataSource, SlidingTabBarDelegate, UITabBarControllerDelegate {
    
    // Custom tab bar.
    var tabBarView: SlidingTabBar!
    var fromIndex: Int!
    var toIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the original tab bar.
        self.tabBar.isHidden = true
        // Start at 0, i.e. home view.
        self.selectedIndex = 0
        self.delegate = self
        
        // Increase the tab bar height.
        var frame: CGRect = self.tabBar.frame
        frame.origin.y -= 11
        frame.size.height += 11
        
        // Create the custom tab bar.
        tabBarView = SlidingTabBar(frame: frame, initialTabBarItemIndex: self.selectedIndex)
        // Set the tab bar colour.
        tabBarView.tabBarBackgroundColor = darkGrey
        tabBarView.tabBarItemTintColor = UIColor.gray
        tabBarView.selectedTabBarItemTintColor = UIColor.white
        tabBarView.selectedTabBarItemColors = [lightGrey, lightGrey, lightGrey]
        // Set the animation duration.
        tabBarView.slideAnimationDuration = 0.3
        // Set up anything else to do with the tab bar.
        tabBarView.datasource = self
        tabBarView.delegate = self
        tabBarView.setup()
        
        // Add the tab bar to view.
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
        
        return SlidingTabAnimatedTransitioning(transitionDuration: 0.3, direction: .Both,
                                               fromIndex: self.fromIndex, toIndex: self.toIndex)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
