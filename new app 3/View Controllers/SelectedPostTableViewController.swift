//
//  SelectedPostTableViewController.swift
//  new app 3
//
//  Created by William Hinson on 2/28/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SelectedPostTableViewController: UITableViewController {
    
    var post = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return post.count
    }


}
