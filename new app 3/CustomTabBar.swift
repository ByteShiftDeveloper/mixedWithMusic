//
//  CustomTabBar.swift
//  new app 3
//
//  Created by Danyal on 22/12/2020.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//
import UIKit
import Tabman
import Pageboy

class CustomTabBar: TabmanViewController {
    
    var viewControllers : [UIViewController] = []
    var titles : [String] = []
    let bar = TMBar.ButtonBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.dataSource = self
        // Create bar
        
        bar.layout.transitionStyle = .snap // Customize
       
        bar.layout.alignment = .centerDistributed
        bar.layout.interButtonSpacing = 10
        bar.indicator.weight = .light
        bar.buttons.customize { (button) in
            button.selectedTintColor = .black
            button.tintColor = .gray
            button.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            button.selectedFont = UIFont.systemFont(ofSize: 14, weight: .bold)
        }
        bar.backgroundView.style = .clear
        bar.indicator.tintColor = .black
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.cornerStyle = .square
        
        
        // Add to view
        addBar(bar, dataSource: self, at: .top)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension CustomTabBar: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: titles[index])
    }
    
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for tabViewController: TabmanViewController, at index: Int) -> TMBarItemable {
        let title = "Page \(index)"
        return TMBarItem(title: title)
    }
    
    
    
    
}
