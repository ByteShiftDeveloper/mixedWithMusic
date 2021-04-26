//
//  SettingsTableViewController.swift
//  new app 3
//
//  Created by William Hinson on 10/20/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase
import SafariServices

private let reuseIdentifier = "SettingsEditProfileTVC"
private let reuseIdentifier2 = "LegalDocsTVC"
private let reuseIdentifier3 = "SettingsFooterCell"

protocol SettingsTableViewDelegate: class {
//    func controller(_ controller: EditProfileController, wantsToUpdate user: User)
    func handleLogout()
}

class SettingsTableViewController: UITableViewController {
    private let user: User
    private lazy var viewModel = SettingsOptions.self

    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: SettingsTableViewDelegate?
    
    let keyWindow = UIApplication.shared.connectedScenes
               .map({$0 as? UIWindowScene})
               .compactMap({$0})
               .first?.windows.first
    
    var statusBarUIView: UIView? {

      if #available(iOS 13.0, *) {
          let tag = 3848245

          let keyWindow = UIApplication.shared.connectedScenes
              .map({$0 as? UIWindowScene})
              .compactMap({$0})
              .first?.windows.first

          if let statusBar = keyWindow?.viewWithTag(tag) {
              return statusBar
          } else {
              let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
              let statusBarView = UIView(frame: height)
              statusBarView.tag = tag
              statusBarView.layer.zPosition = 999999

              keyWindow?.addSubview(statusBarView)
              return statusBarView
          }

      } else {

          if responds(to: Selector(("statusBar"))) {
              return value(forKey: "statusBar") as? UIView
          }
      }
      return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        configureTableView()
        
        tableView.backgroundColor = .white
        
        print("The current user is \(user.uid)")
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancle))
        navigationController?.navigationBar.tintColor = .black
        configureTableView()
        statusBarUIView?.isHidden = false
    }
    

    
    let versionLabel: UILabel = {
        let label = UILabel()
        label.text = "Version 1.00"
        label.textColor = .lightGray
        return label
    }()
    
    @objc func handleCancle() {
        dismiss(animated: true, completion: nil)
    }
        
    @objc func handleLogout() {
        
        print("TAPPING BUTTON")
        
        let alert = UIAlertController(title: nil, message: "Are you sure you would like to logout?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                do {
//                    try Auth.auth().signOut()
                    let nav = UINavigationController(rootViewController: UpdatedLoginController())
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true, completion: nil)
                } catch let error {
                    print("Failed to sign out with error \(error.localizedDescription)")
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func configureTableView() {
        tableView.register(SettingsEditProfileTVC.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(LegalDocsTVC.self, forCellReuseIdentifier: reuseIdentifier2)
        tableView.register(SettingsFooterCell.self, forCellReuseIdentifier: reuseIdentifier3)
        
        let footerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: self.tableView.frame.width,
                                              height: 100))

        footerView.addSubview(versionLabel)
        versionLabel.centerX(inView: footerView)
        versionLabel.anchor(top: footerView.topAnchor, paddingTop: 16)
        self.tableView.tableFooterView = footerView
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Settings"
    }
    
    
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 2 {
            return SettingsOptions.allCases.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsEditProfileTVC
        
        return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier3, for: indexPath) as! SettingsFooterCell
            cell.delegate = self
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsEditProfileTVC
            cell.titleLabel.text = "Contact Us"
            cell.settingsIcon.image = UIImage(systemName: "envelope")
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier2, for: indexPath) as! LegalDocsTVC
        cell.titleLabel.text = "Privacy Policy"
//        cell.settingsIcon.image = UIImage(systemName: "envelope")
        guard let option = SettingsOptions(rawValue: indexPath.row) else { return cell }

        cell.viewModel = SettingsViewModel(user: user, option: option)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
                let controller = EditProfileTableViewController(user: user)
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                present(nav, animated: true, completion: nil)
            
        } else if indexPath.section == 1 {
            showSafariVC(for: "https://mixedwithmusic.com/contact/")
        }
        
      
        showSafariVC(for: "https://mixedwithmusic.com/privacy-policy/")
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        

            let label = UILabel()
            label.frame = CGRect.init(x: 16, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
            label.text = "Profile Settings"
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = .black

            headerView.addSubview(label)
        headerView.backgroundColor = .white
        
        if section == 1 {
            label.text = "Contact Us"
        } else if section == 2 {
            label.text = "Legal Settings"
        }

            return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func showSafariVC(for url: String) {
        guard let url = URL(string: url) else { return }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingsTableViewController: SettingsFooterDelegate {
    func logout(_ cell: SettingsFooterCell) {
        print("TAPPING BUTTON")
        
        let alert = UIAlertController(title: nil, message: "Are you sure you would like to logout?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                self.delegate?.handleLogout()
//                let nav = UINavigationController(rootViewController: UpdatedLoginController())
//                nav.modalPresentationStyle = .fullScreen
//                self.present(nav, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
