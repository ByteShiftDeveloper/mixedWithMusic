//
//  SocialsActionSheetLauncher.swift
//  new app 3
//
//  Created by William Hinson on 3/23/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "InstagramActionCell"
private let reuseIdentifier2 = "TwitterActionCell"
private let reuseIdentifier3 = "SpotifyActionCell"
private let reuseIdentifier4 = "SoundCloudActionCell"


protocol SocialsActionSheetLauncherDelegate: class {
    func didSelect(option: SocialsActionSheetLauncher)
}

class SocialsActionSheetLauncher: NSObject, UITextFieldDelegate {
    
    // MARK: - Properties
//    
//    private let user: User
//
//     let tableView = UITableView()
//    private var window: UIWindow?
////    private lazy var viewModel = ActionSheetViewModel(user: user, post: post)
//    weak var delegate: SocialsActionSheetLauncherDelegate?
//    private var tableViewHeight: CGFloat?
//    var containerView : CommentInputTextViewAccessory?
//    
//    
//    var cell1: InstagramActionCell?
//    var cell2: TwitterActionCell?
//    var cell3: SpotifyActionCell?
//    var cell4: SoundCloudActionCell?
//    
//    let urls = [1,2,3,4]
//    
//    
//    private lazy var blackView: UIView = {
//        let view = UIView()
//        view.alpha = 0
//        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
//        view.addGestureRecognizer(tap)
//        
//        return view
//    }()
//    
//    
//    private lazy var footerView: UIView = {
//        let view = UIView()
//                
//        view.addSubview(cancelButton)
//        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        cancelButton.anchor(left: view.leftAnchor, right: view.rightAnchor,
//                            paddingLeft: 12, paddingRight: 12)
//        cancelButton.centerY(inView: view)
//        cancelButton.layer.cornerRadius = 50 / 2
//        
//        return view
//    }()
//    
//    private lazy var cancelButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Save", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
//        button.setTitleColor(.black, for: .normal)
//        button.backgroundColor = .systemGroupedBackground
//        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
//        return button
//    }()
//    
//    // MARK: - Lifecycle
//    
//    init(user: User) {
//        self.user = user
//        super.init()
//        
//        configureTableView()
//        tableView.becomeFirstResponder()
//    }
//    
//    // MARK: - Selectors
//    
//    @objc func handleDismissal() {
////        let controller = SelectedPostController(post: post)
//        UIView.animate(withDuration: 0.3) {
//            self.blackView.alpha = 0
//            self.tableView.frame.origin.y += 800
//            self.containerView?.isHidden = false
//        }
//        
//        tableView.endEditing(true)
//        
////        cell1?.endEditing(true)
////        cell2?.endEditing(true)
////        cell3?.endEditing(true)
////        cell4?.endEditing(true)
//    }
//    
//    @objc func handleSave() {
//        print("Button is being tapped")
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        
//        guard let igInfo = cell1?.titleLabel.text else { return }
//        guard let twitterInfo = cell2?.titleLabel.text else { return }
//        guard let spotifyInfo = cell3?.titleLabel.text else { return }
//        guard let soundcloudInfo = cell4?.titleLabel.text else { return }
//        
//        let values = ["igInfo": igInfo,
//                      "twitterInfo": twitterInfo,
//                      "spotifyInfo": spotifyInfo,
//                      "soundcloudInfo": soundcloudInfo] as [String:Any]
//        
//        let ref = REF_USERS.child(uid)
//        ref.updateChildValues(values) { (err, ref) in
//        }
//        
//        handleDismissal()
//    }
//    
// 
//    
//    // MARK: - Helpers
//    
//    func showTableView(_ shouldShow: Bool) {
//        guard let window = window else { return }
//        guard let height = tableViewHeight else { return }
//        let y = shouldShow ? window.frame.height - height : window.frame.height
//        tableView.frame.origin.y = y
//    }
//    
//    func show() {
//        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
//        self.window = window
//        
//        window.addSubview(blackView)
//        blackView.frame = window.frame
//        
//        window.addSubview(tableView)
//        
//        let height = CGFloat(4 * 150) + 124
//        self.tableViewHeight = height
//        tableView.frame = CGRect(x: 0, y: window.frame.height,
//                                 width: window.frame.width, height: height)
//        
//        UIView.animate(withDuration: 0.3) {
//            self.blackView.alpha = 1
//            self.showTableView(true)
//        }
//    }
//    
//    func configureTableView() {
//        tableView.backgroundColor = .white
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.rowHeight = 40
//        tableView.separatorStyle = .none
//        tableView.layer.cornerRadius = 5
//        tableView.isScrollEnabled = true
//        
//        
//        tableView.register(InstagramActionCell.self, forCellReuseIdentifier: reuseIdentifier)
//        tableView.register(TwitterActionCell.self, forCellReuseIdentifier: reuseIdentifier2)
//        tableView.register(SpotifyActionCell.self, forCellReuseIdentifier: reuseIdentifier3)
//        tableView.register(SoundCloudActionCell.self, forCellReuseIdentifier: reuseIdentifier4)
//    }
//    
//    func configureKeyboardObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
//    }
//    
//    @objc func handleKeyboardDidShow() {
//       
//    }
//}
//
//// MARK: - UITableViewDataSource
//
//extension SocialsActionSheetLauncher: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return urls.count
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier2, for: indexPath) as! TwitterActionCell
//            cell.user = user
//            cell.titleLabel.delegate = self
//            return cell
//        } else   if indexPath.section == 2 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier3, for: indexPath) as! SpotifyActionCell
//            cell.user = user
//            cell.titleLabel.delegate = self
//            return cell
//        } else   if indexPath.section == 3 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier4, for: indexPath) as! SoundCloudActionCell
//            cell.user = user
//            cell.titleLabel.delegate = self
//            return cell
//        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! InstagramActionCell
//        cell.user = user
//        cell.titleLabel.delegate = self
//        return cell
//    }
//    
//    func scrollToBottom() {
//          if urls.count > 0 {
//              let indexPath = IndexPath(item: urls.count - 1, section: 0)
//            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
//          }
//      }}
//
//// MARK: - UITableViewDelegate
//
//extension SocialsActionSheetLauncher: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return footerView
//    }
//    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 60
//    }
//    

    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        let option = viewModel.option[indexPath.row]
//        UIView.animate(withDuration: 0.5, animations: {
//            self.blackView.alpha = 0
//            self.showTableView(false)
//            self.containerView?.isHidden = false
//
//
//        }) { _ in
//            self.delegate?.didSelect(option: self)
//        }
//    }
}
