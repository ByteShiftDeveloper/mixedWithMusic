//  ButtonBarExampleViewController.swift
//  XLPagerTabStrip ( https://github.com/xmartlabs/XLPagerTabStrip )
//
//  Copyright (c) 2017 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import TwitterProfile
import XLPagerTabStrip

class XLPagerTabStripExampleViewController: ButtonBarPagerTabStripViewController, PagerAwareProtocol {
    
    //MARK: PagerAwareProtocol
    weak var pageDelegate: BottomPageDelegate?
    
    var currentViewController: UIViewController?{
        return viewControllers[currentIndex]
    }
    
    var pagerTabHeight: CGFloat?{
        return 44
    }
    var user : User?

    //MARK: Properties
    var isReload = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    //MARK: Life cycle
    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = .background
        settings.style.buttonBarItemBackgroundColor = .background
        settings.style.selectedBarBackgroundColor = UIColor(named: "BlackColor")!
        settings.style.buttonBarItemTitleColor = UIColor(named: "BlackColor")
    
        settings.style.selectedBarHeight = 2
        
        super.viewDidLoad()

        
        
        delegate = self
        
        self.changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = UIColor(named: "BlackColor")
        }
    }

    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let vc = ProfileCollectionView2(user: user!)
        vc.selectedFilter = ProfileFilterOptions.posts
        vc.pageIndex = 0
        vc.pageTitle = "Posts"
        vc.count = 10
        let child_1 = vc
        
        let vc1 = ProfileCollectionView2(user: user!)
        vc.selectedFilter = ProfileFilterOptions.uploads

        vc1.pageIndex = 1
        vc1.pageTitle = "Uploads"
        vc1.count = 1
        let child_2 = vc1
        
        let vc2 = ProfileCollectionView2(user: user!)
        vc.selectedFilter = ProfileFilterOptions.likes

        vc2.pageIndex = 2
        vc2.pageTitle = "Likes"
        vc2.count = 10
        let child_3 = vc2
        
        

        return [child_1, child_2, child_3]
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
