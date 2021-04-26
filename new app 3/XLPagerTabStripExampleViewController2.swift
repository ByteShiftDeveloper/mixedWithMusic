//
//  XLPagerTabStripExampleViewController2.swift
//  new app 3
//
//  Created by William Hinson on 3/4/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit
import TwitterProfile
import XLPagerTabStrip

class XLPagerTabStripExampleViewController2: ButtonBarPagerTabStripViewController, PagerAwareProtocol {
    
    //MARK: PagerAwareProtocol
    weak var pageDelegate: BottomPageDelegate?
    
    var currentViewController: UIViewController?{
        return viewControllers[currentIndex]
    }
    
    var pagerTabHeight: CGFloat?{
        return 0
    }
    var gigs : Gigs?

    //MARK: Properties
    var isReload = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    //MARK: Life cycle
    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = .background
        settings.style.buttonBarItemBackgroundColor = .background
        settings.style.selectedBarBackgroundColor = .lightGray
        settings.style.buttonBarItemTitleColor = .black
    
        settings.style.selectedBarHeight = 0.5
        
        super.viewDidLoad()

        
        
        delegate = self
        
        self.changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = .black
        }
    }

    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
//        let vc = ProfileCollectionView2(user: user!)
//        vc.selectedFilter = ProfileFilterOptions.posts
//        vc.pageIndex = 0
//        vc.pageTitle = "Posts"
//        vc.count = 10
//        let child_1 = vc
        
        let vc = ApplyGigTableView(gigs: gigs!)
        vc.selectedFilter = GigFilterOptions.gigs
        vc.pageIndex = 0
        vc.pageTitle = gigs?.title ?? ""
        vc.count = 10
        let child_1 = vc
        

        return [child_1]
    }

    override func reloadPagerTabStripView() {
        pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
        super.reloadPagerTabStripView()
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        
        guard indexWasChanged == true else { return }

        //IMPORTANT!!!: call the following to let the master scroll controller know which view to control in the bottom section
        self.pageDelegate?.tp_pageViewController(self.currentViewController, didSelectPageAt: toIndex)

    }
}
