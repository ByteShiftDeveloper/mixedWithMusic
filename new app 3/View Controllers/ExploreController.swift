//
//  ExploreController.swift
//  new app 3
//
//  Created by William Hinson on 6/28/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase

enum selectedScope: Int {
    case people = 0
    case song = 1
    case albums = 2
}

private let reuseIdentifier = "TrackTitle"
private let reuseIdentifier2 = "SongSearchTVC"


class ExploreController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout , UITableViewDelegate,UITableViewDataSource {
    
    var playerViewController : PlayerDetailController?
    var miniPlayerInView = false
    let filterbar = SFilterView()
    
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
    
    
    var users = [User]()
    var filteredUsers = [User]()
    var songs = [SongPost]()
    var filteredSOngs = [SongPost]()
    var inSearchMode = false
    var collectionView: UICollectionView!
    var tableView: UITableView!
    var likedSongsCount : Int = 0
    
    var checkUser : User?
    
    var userCell: UserSearchTVC?
    
    var selectedGenres : [String] = []
    var selectedabdmp : [String] = []
    var selectLocaiton : [String] = []
    
    var collectionViewEnabled = true
    
    let cellId : String = "cellId"
    let cellId2 : String = "cellId2"
    let cellId3 : String = "cellId3"
    let cellId4 : String = "cellId4"
    let cellId5 : String = "cellId5"
    let cellId6 : String = "cellId6"
    let searchBar = UISearchBar()
    
    var tabView : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUsers()
        configureTabView()
        configureSearchBar()
        configureCollectionView()
        tableView.rowHeight = 70
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadLikes), name: Notification.Name("reloadLikesSongs"), object: nil)
    }
    
    @objc func reloadLikes(notification : Notification){
        let notObj = notification.userInfo! as NSDictionary
        likedSongsCount = notObj["likedSongsCount"] as? Int ?? 0
        self.collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //            searchBar.becomeFirstResponder()
        tableView.backgroundColor = UIColor(named: "DefaultBackgroundColor")//        navigationController?.navigationBar.backgroundColor = Colors.blackColor
        //        navigationController?.navigationBar.tintColor = Colors.blackColor
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.isHidden = false
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .darkGray
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let image = UIImage()
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isTranslucent = true
        
        self.navigationController?.navigationBar.setBackgroundImage(.none, for: .default)
        self.navigationController?.navigationBar.shadowImage = .none
        
        searchBar.backgroundImage = image
        searchBar.backgroundColor = .clear
        searchBar.tintColor = .black
        searchBar.isTranslucent = true

    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
//    func fetchAllUser() {
//        UserService.shared.fetchAllUsers { users in
//            self.users = users
//            users.forEach { user in
//                print("User is \(user.fullname)")
//            }
//        }
//    }
    
    func checkIfUserIsFollowed() {
        guard let user = userCell?.user else { return }
        Service.shared.checkIfUserIsFollowed(uid: user.uid) { (isFollowed) in
            user.isFollowed = isFollowed
            if isFollowed == true {
                self.userCell?.followButton.setTitle("Following", for: .normal)
                self.userCell?.followButton.backgroundColor = .black
                self.userCell?.followButton.setTitleColor(.white, for: .normal)
            } else if isFollowed == false {
                self.userCell?.followButton.setTitle("Follow", for: .normal)
                self.userCell?.followButton.backgroundColor = .clear
                self.userCell?.followButton.setTitleColor(.black, for: .normal)
                self.userCell?.followButton.layer.borderColor = UIColor.black.cgColor
            } else if user.isCurrentUser == true {
                self.userCell?.followButton.setTitle("Edit Profile", for: .normal)
                self.userCell?.followButton.setTitleColor(.black, for: .normal)
                self.userCell?.followButton.backgroundColor = .white
                self.userCell?.followButton.layer.borderColor = UIColor.black.cgColor
            }
        }

    }
    
    
    //MARK: -UITableView
    
    func configureTableView(vc : UIViewController) {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - (tabBarController?.tabBar.frame.height)! - (navigationController?.navigationBar.frame.height)!)
        tableView = UITableView(frame: frame)
        
        tableView.register(UserSearchTVC.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(SongSearchTVC.self, forCellReuseIdentifier: reuseIdentifier2)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        tableView.backgroundColor = UIColor(named: "DefaultBackgroundColor")
        vc.view.addSubview(tableView)
        
        tableView.separatorColor = .clear
        
        view.backgroundColor = .white
        
        let refreshControl2 = UIRefreshControl()
        refreshControl2.addTarget(self, action: #selector(handleRefresh2), for: .valueChanged)
        tableView.refreshControl = refreshControl2

    }
    
    func configureTabView(){
        
        let frame = CGRect(x: 0, y: navigationController?.navigationBar.frame.height ?? 0, width: view.frame.width, height: view.frame.height - (tabBarController?.tabBar.frame.height)! - (navigationController?.navigationBar.frame.height)!)
        tabView = UIView(frame: frame)
        
        if let tab = tabView{
            self.view.addSubview(tab)
            self.view.bringSubviewToFront(tab)
            addTabView()
        }
    }
    
    func addTabView() {
            // 1- Init bottomSheetVC
        var tabbar : CustomTabBar!

            if tabbar != nil{
                return
            }
            
            if let _ = self.children.first(where: {$0 is CustomTabBar}){
                return
            }
            
        let titles = ["Users","Uploads"]
        weak var storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let usersVC = UIViewController()
        configureTableView(vc: usersVC)
        let uploadVC = UIViewController()
        let viewControllers : [UIViewController] = [usersVC,uploadVC]
        tabbar = CustomTabBar()
        tabbar.titles = titles
        tabbar.viewControllers = viewControllers
        tabbar.bar.layout.contentMode = .fit
        self.addChild(tabbar)
        tabView?.addSubview(tabbar.view)
        tabbar.didMove(toParent: self)
        tabbar.view.frame = CGRect(x: 0, y: 0, width: tabView?.frame.width ?? 0, height: tabView?.frame.height ?? 0)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchBar.selectedScopeButtonIndex == 0 {
            if inSearchMode {
                if filteredUsers.count == 0 {
                       self.tableView.setEmptyMessage("Sorry, no users fit your current search criteria, please update or reset them.")
                   } else {
                       self.tableView.restore()
                   }

                return filteredUsers.count
            } else {
                self.tableView.restore()
                return users.count
            }
            
        }
        
        if searchBar.selectedScopeButtonIndex == 1 {
            if inSearchMode {
                return filteredSOngs.count
            } else {
                return songs.count
            }
            
        }
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searchBar.selectedScopeButtonIndex == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserSearchTVC
            
            
            var user: User!
            
            if inSearchMode {
                user = filteredUsers[indexPath.row]
            } else {
                user = users[indexPath.row]
            }
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.delegate = self
            cell.user = user
            return cell
            
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier2, for: indexPath) as! SongSearchTVC
        var song: SongPost
        
        if inSearchMode {
            song = filteredSOngs[indexPath.row]
        } else {
            song = songs[indexPath.row]
        }
        
        cell.song = song
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searchBar.selectedScopeButtonIndex == 0 {
            let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
            let userProfileVC = NewProfileVC()
            userProfileVC.user = user
            navigationController?.pushViewController(userProfileVC, animated: true)
        } else if searchBar.selectedScopeButtonIndex == 1 {
            let song = inSearchMode ? filteredSOngs[indexPath.row] : songs[indexPath.row]
            let controller = SelectSongController(collectionViewLayout: StretchyHeaderLayout())
            controller.song = song
            controller.user = song.author
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    //MARK: -UICollectionView
    
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let frame = CGRect(x: 0, y: 0, width: view.frame.height, height: view.frame.height)
        //                            -
        //                            (tabBarController?.tabBar.frame.height)! - (navigationController?.navigationBar.frame.height)!)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor(named: "DefaultBackgroundColor")
        
        //        tableView.addSubview(collectionView)
        self.view.addSubview(collectionView)
        collectionView.register(ExploreCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(ExploreCell2.self, forCellWithReuseIdentifier: cellId2)
        collectionView.register(ExploreCell3.self, forCellWithReuseIdentifier: cellId3)
        collectionView.register(ExploreCell4.self, forCellWithReuseIdentifier: cellId4)
        collectionView.register(ExploreCell5.self, forCellWithReuseIdentifier: cellId5)
        collectionView.register(ExploreCell6.self, forCellWithReuseIdentifier: cellId6)
        tableView.separatorColor = .clear
        
        let refreshControl = UIRefreshControl()
       refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
       collectionView.refreshControl = refreshControl

        
        view.backgroundColor = UIColor(named: "DefaultBackgroundColor")
    }
    
    @objc func handleRefresh() {
        collectionView.refreshControl?.beginRefreshing()
        collectionView.refreshControl?.endRefreshing()
        collectionView.reloadData()
    }
    
    @objc func handleRefresh2() {
        fetchUsers()
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! ExploreCell2
            cell.del = self
            return cell
        }   else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId5, for: indexPath) as! ExploreCell5
            cell.del = self
            cell.delegate = self
            if likedSongsCount == 0 {
                cell.seeMoreButton.isHidden = true
            }else{
                cell.seeMoreButton.isHidden = false
                
            }
            return cell
        } else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId3, for: indexPath) as! ExploreCell3
            cell.del = self
            return cell
        } else if indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ExploreCell
            cell.del = self
            return cell
        } else if indexPath.section == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId4, for: indexPath) as! ExploreCell4
            cell.del = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId6, for: indexPath) as! ExploreCell6
            cell.del = self
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        
//        if likedSongsCount == 0 &&
        if indexPath.section == 1{
            print("section:\(indexPath.section)")
            return CGSize(width: width, height: 200)
        }
        
        if indexPath.section == 0 {
            
            let height = CGFloat(160)
            return CGSize(width: width, height: height)
            
        }
        
        else if indexPath.section == 2 {
            
            let height = CGFloat(300)
            return CGSize(width: width, height: height)
            
        } else if indexPath.section == 5 {
            let height = CGFloat(300)
            return CGSize(width: width, height: height)
        }
        
        else {
            
            let height = CGFloat(250)
            return CGSize(width: width, height: height)
            
        }
        
        
        
    }
    
    
    func configureSearchBar() {
        let image = UIImage()
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
//      searchBar.barTintColor = .white
        searchBar.backgroundImage = image
        searchBar.backgroundColor = .clear
        searchBar.tintColor = UIColor(named: "BlackColor")
        searchBar.isTranslucent = true
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("New scope index is now \(selectedScope)")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        //
//        searchBar.showsScopeBar = true
//        searchBar.scopeButtonTitles = ["Users", "Uploads"]
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(systemName: "slider.horizontal.3"), for: .bookmark, state: .normal)



        fetchUsers()

        collectionView.isHidden = true
        collectionViewEnabled = false

        tableView.separatorColor = .clear
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let controller = SearchFilterCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        //        controller.filterClosed = {  (userFilters,genresArr)  in
        //
        //        }
        controller.selectedGenres = selectedGenres
        controller.selectedabdmp = selectedabdmp
        
        
        
        
        controller.filterClosed = {  (userFilters,genresArr,location) in
            print("user filter count:\(userFilters?.count ?? 0)")
            
            self.selectedGenres = genresArr ?? []
            self.selectedabdmp = userFilters ?? []
            self.selectLocaiton = location ?? []
            
            var userIDs : [String] = []
            var genreIDs : [String] = []
            var userFilterId : [String] = []
            
            
            if userFilters?.count ?? 0 > 0 {
                //                 userIDs = self.users.filter({userFilters!.contains($0.artistBand)}).map({$0.uid})
                userFilterId = self.users.filter({userFilters!.contains($0.artistBand)}).map({$0.uid})
                
            }
            if let genres = genresArr{
                for i in genres{
                    //                    let tempIDs = self.users.filter({$0.genre.localizedCaseInsensitiveContains(i)}).map({$0.uid})
                    //                    userIDs.append(contentsOf: tempIDs)
                    
                    let tempIDs = self.users.filter({$0.genre.localizedCaseInsensitiveContains(i)}).map({$0.uid})
                    genreIDs.append(contentsOf: tempIDs)
                }
            }
            
          
            
            if (userFilters?.count ?? 0  > 0) && (genresArr?.count ?? 0 > 0) {
                let userSet = Set(userFilterId)
                let genreSet = Set(genreIDs)
                userIDs = Array(userSet.intersection(genreSet))
            }else if userFilters?.count ?? 0 > 0{
                userIDs = Array(Set(userFilterId))
            }else if genresArr?.count ?? 0 > 0{
                userIDs = Array(Set(genreIDs))
            }
            
            
            //            userIDs = Array(Set(userIDs))
            
            self.filteredUsers = self.users.filter({userIDs.contains($0.uid)})
            self.inSearchMode = true
            
            if userFilters?.count == 0 && genresArr?.count == 0 {
                self.inSearchMode = false
            }
            self.tableView.reloadData()
            
        }
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        //        navigationController?.pushViewController(controller, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchText = searchText.lowercased()
        
        if searchText.isEmpty || searchText == " " {
            inSearchMode = false
            tableView.reloadData()
        } else {
            inSearchMode = true
            //              filteredUsers = users.filter({ (user) -> Bool in
            //                  return user.username.contains(searchText)
            //              })
            filterTableView(ind: searchBar.selectedScopeButtonIndex, searchText: searchText)
            tableView.reloadData()
        }
        
    }
    
    func filterTableView(ind: Int, searchText: String) {
        switch ind {
        case selectedScope.people.rawValue:
            filteredUsers = users.filter({ (user) -> Bool in
                return user.fullname.contains(searchText)
                tableView.reloadData()
            })
        case selectedScope.song.rawValue:
            filteredSOngs = songs.filter({ (song) -> Bool in
                return song.title.contains(searchText)
                tableView.reloadData()
                
            })
            
        case selectedScope.albums.rawValue:
            filteredSOngs = songs.filter({ (song) -> Bool in
                return song.title.contains(searchText)
            })
            
            
        default:
            print("break")
        }
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        inSearchMode = false
        
        collectionViewEnabled = true
        collectionView.isHidden = false
        
        searchBar.showsScopeBar = false
        
        searchBar.showsBookmarkButton = false
        
        tableView.separatorColor = .clear
        tableView.reloadData()
    }
    
    // MARK: -API Calls
    
    func fetchUser(){
        
        self.tableView?.refreshControl?.beginRefreshing()
        
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            print(snapshot)
            
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            let uid = snapshot.key
            
            let user = User(uid: uid, dictionary: dictionary)
            
            self.users.forEach { (user) in
                Service.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
                    user.isFollowed = isFollowed
                    if isFollowed == true {
                        self.userCell?.followButton.setTitle("Following", for: .normal)
                        self.userCell?.followButton.backgroundColor = .black
                        self.userCell?.followButton.setTitleColor(.white, for: .normal)
                    } else if isFollowed == false {
                        self.userCell?.followButton.setTitle("Follow", for: .normal)
                        self.userCell?.followButton.backgroundColor = .clear
                        self.userCell?.followButton.setTitleColor(.black, for: .normal)
                        self.userCell?.followButton.layer.borderColor = UIColor.black.cgColor
                    }
                }
            }

            
            self.users.append(user)
            self.tableView.reloadData()
        }
        
        self.tableView?.refreshControl?.endRefreshing()

    }
    
    func fetchUsers() {
        tableView?.refreshControl?.beginRefreshing()
        UserService.shared.fetchUsers { (users) in
            self.users = users
            self.users.forEach { (user) in
                Service.shared.checkIfUserIsFollowed(uid: user.uid) { (isFollowed) in
                    user.isFollowed = isFollowed
                    if isFollowed == true {
                        self.userCell?.followButton.setTitle("Following", for: .normal)
                        self.userCell?.followButton.backgroundColor = .black
                        self.userCell?.followButton.setTitleColor(.white, for: .normal)
                    } else if isFollowed == false {
                        self.userCell?.followButton.setTitle("Follow", for: .normal)
                        self.userCell?.followButton.backgroundColor = .clear
                        self.userCell?.followButton.setTitleColor(.black, for: .normal)
                        self.userCell?.followButton.layer.borderColor = UIColor.black.cgColor
                    }
                }
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    

    
    func grabAudioUpload() {
        let ref = Database.database().reference().child("audio")
        
        ref.observe(.value) { (snapshot) in
            
            //                              print(snapshot)
            
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let dict = childSnapshot.value as? [String:Any],
                   //                          let author = dict["uploadBy"] as? [String:Any],
                   let uid = dict["uid"] as? String,
                   let fullname = dict["username"] as? String,
                   let photoURL = dict["photoURL"] as? String,
                   let trackTitle = dict["trackTitle"] as? String,
                   let url = URL (string:photoURL),
                   let likes = dictionary["likes"] as? Int,
                   let coverImageURL = dict["coverImage"] as? String,
                   let imageURL = URL (string:coverImageURL),
                   let audios = dict["AudioUrl"] as? [[String:Any]],
                   let streams = dictionary["streams"] as? Int,
                   //let songURL = URL (string:audioURL),
                   
                   let timestamp = dict["timestampt"] as? Double {
                    
                    var audioNames  = [String]()
                    var audioUrls  = [URL]()
                    for audio in audios{
                        let audioName = audio.first?.key
                        let audioUrl = audio.first?.value as? String
                        let songURL = URL (string:audioUrl!)
                        
                        audioNames.append(audioName!)
                        audioUrls.append(songURL!)
                    }
                    
                    UserService.shared.fetchUser(uid: uid) { user in
                        //                            let userProfile = UserProfile(uid: uid, fullname: fullname, photoURL: url)
                        //                            let profile = User(uid: uid, dictionary: dictionary)
                        let song = SongPost(id: childSnapshot.key, author: user, title: trackTitle, coverImage: imageURL, audioUrl: audioUrls , audioName: audioNames , likes: likes, timestamp: timestamp, streams: streams)
                        
                        print("user is this guy \(user)")
                        
                        self.songs.removeAll(where: {$0.id == childSnapshot.key})
                        
                        self.songs.append(song)
                        //
                        self.songs = self.songs.sorted(by: { $0.createdAt > $1.createdAt})
                        
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
}


extension ExploreController: LikesDelegate {
    func handleSeeAll(_ cell: ExploreCell5) {
        print("SUCCESSFULY TAPPED BUTTON")
        let controller = Library(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(controller, animated: true)
    }
}


extension ExploreController: UserSearchDelegate {
    func handleProfileImageTapped(_ cell: UserSearchTVC) {
        
    }
    
    func didTapFollow(_ cell: UserSearchTVC) {
        guard let user = cell.user else { return }
        
        if user.isCurrentUser {
            let controller = EditProfileTableViewController(user: user)
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
            return
        }
        
        if user.isFollowed {
            cell.followButton.backgroundColor = .white
            cell.followButton.setTitleColor(.black, for: .normal)
            cell.followButton.setTitle("Follow", for: .normal)
            cell.followButton.layer.borderColor = UIColor.black.cgColor
            Service.shared.unfollowUser(uid: user.uid) { (err, ref) in
                user.isFollowed = false
                self.collectionView.reloadData()
            }
        } else {
            cell.followButton.backgroundColor = .black
            cell.followButton.setTitleColor(.white, for: .normal)
            cell.followButton.setTitle("Following", for: .normal)
            Service.shared.followUser(uid: (user.uid)) { (ref, err) in
                user.isFollowed = true
              self.collectionView.reloadData()
                
                NotificationService.shared.uploadNotification(type: .follow, user: user)
            }
        }
    }
}

extension ExploreController: subCustom3Delegate{
    func buttonTapped(_ cell: SubCustomCell3) {
        print("BUTTON WAS TAPPED")
    }
}

extension ExploreController: ExploreCell6Delegate {
    
    func seeMoreButtonTapped(_ cell: ExploreCell6) {
        print("tapped")
        let controller = GigsController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func buttonTapped(_ cell: ExploreCell6) {
        let controller = GigsController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

