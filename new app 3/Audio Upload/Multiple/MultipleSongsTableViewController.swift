//
//  MultipleSongsTableViewController.swift
//  audioPlayerApp
//
//  Created by William Hinson on 2/12/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import MRProgress

private let reuseIdentifier = "TrackTitle"
private let reuseIdentifier2 = "Genre"
private let reuseIdentifier3 = "FeaturedArtist"
private let reuseIdentifier4 = "AddAudio"
private let reuseIdentifier5 = "AddSong"
private let headerCellIdentifier = "AudioHeaderCell"
private let footerCellIdentifier = "UploadFooterCell"
private let headerIdentifier = "AudioHeader"

class MultipleSongsTableViewController: UITableViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    var songs = [String]()
    var songsUrl = [URL]()
//    var songNames = [String]()
    var selectedRow : Int = -1
    var progressView : CustomMRProgressView2?
    var imagePicker = UIImagePickerController()
    var isEdit = false
    var songUrlIndex = -1
    
    var user: User?

        let coverImage:UIImageView = {
           let iv = UIImageView()
           iv.contentMode = .scaleAspectFill
           iv.clipsToBounds = true
           iv.setDimensions(width: 150, height: 150)
           iv.backgroundColor = .darkGray
           return iv
       }()
               
       let addImageButton: UIButton = {
           let button = UIButton()
           button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
           button.tintColor = .lightGray
           button.contentVerticalAlignment = .fill
           button.contentHorizontalAlignment = .fill
       //       button.addTarget(self, action: #selector(addImageTapped), for: .touchUpInside)
           return button
       }()
    
//    let headerView: UIView = {
//       let view = UIView()
//        view.backgroundColor = .clear
//
//        let coverImage:UIImageView = {
//                 let iv = UIImageView()
//                 iv.contentMode = .scaleAspectFill
//                 iv.clipsToBounds = true
//                 iv.setDimensions(width: 150, height: 150)
//                 iv.backgroundColor = .darkGray
//                 return iv
//             }()
//
//             let addImageButton: UIButton = {
//                 let button = UIButton()
//                 button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
//                 button.tintColor = .lightGray
//                 button.contentVerticalAlignment = .fill
//                 button.contentHorizontalAlignment = .fill
//                    button.addTarget(self, action: #selector(selectImageFromPhotos), for: .touchUpInside)
//                 return button
//             }()
//
//        view.addSubview(coverImage)
//        coverImage.centerX(inView: view)
//        coverImage.centerY(inView: view)
//
//        view.addSubview(addImageButton)
//        addImageButton.anchor(width: 25, height: 25)
//        addImageButton.centerX(inView: view)
//        addImageButton.centerY(inView: view)
//
//        return view
//    }()
    
    let footerView : UIView = {
       let view = UIView()
        
        let uploadButton: UIButton = {
              let button = UIButton(type: .system)
              button.setTitle("Upload", for: .normal)
              button.setTitleColor(.white, for: .normal)
              button.backgroundColor = Colors.blackColor
              button.layer.cornerRadius = 25
                 button.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
              return button
          }()
        
        view.addSubview(uploadButton)
        uploadButton.anchor(width: 375, height: 50)
        uploadButton.centerY(inView: view)
        uploadButton.centerX(inView: view)
        uploadButton.applyGradient(colors: [UIColor.black.cgColor, Colors.space.cgColor])
        
        return view
    }()

    
    

override func viewDidLoad() {
        super.viewDidLoad()
        
    tableView.backgroundColor = .white
        let headerView = addHeader(image: nil)
        self.tableView.register(TrackTitleTVC.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.register(GenreTVC.self, forCellReuseIdentifier: reuseIdentifier2)
        self.tableView.register(TrackListTVC.self, forCellReuseIdentifier: reuseIdentifier3)
        self.tableView.register(TrackListSongTVC.self, forCellReuseIdentifier: reuseIdentifier4)
        self.tableView.register(AddSongTVC.self, forCellReuseIdentifier: reuseIdentifier5)
        
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 230)
        
        tableView.tableFooterView = footerView
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if AddAudioMutliSongsTableViewController.audioUrl != nil {
            
            songs[selectedRow] = AddAudioMutliSongsTableViewController.trackTitle ?? ""
            songsUrl.append(AddAudioMutliSongsTableViewController.audioUrl!)

            AddAudioMutliSongsTableViewController.audioUrl = nil
            tableView.reloadData()

        }else if  SelectGenreTableViewController.genreLabelMultiple != "" {
            tableView.reloadData()

        }
    
    }
    
    func addHeader(image : UIImage?) ->UIView{
        let view = UIView()
            view.backgroundColor = .clear
            
            let coverImage:UIImageView = {
                     let iv = UIImageView()
                     iv.contentMode = .scaleAspectFill
                     iv.clipsToBounds = true
                     iv.setDimensions(width: 150, height: 150)
                     iv.backgroundColor = .darkGray
                        iv.image = image
                     return iv
                 }()
                         
                 let addImageButton: UIButton = {
                     let button = UIButton()
                     button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
                     button.tintColor = .lightGray
                     button.contentVerticalAlignment = .fill
                     button.contentHorizontalAlignment = .fill
                        button.addTarget(self, action: #selector(selectImageFromPhotos), for: .touchUpInside)
                     return button
                 }()
          
            view.addSubview(coverImage)
            coverImage.centerX(inView: view)
            coverImage.centerY(inView: view)
            
            view.addSubview(addImageButton)
            addImageButton.anchor(width: 25, height: 25)
            addImageButton.centerX(inView: view)
            addImageButton.centerY(inView: view)
            
            return view
        
    }
    
    
@objc func selectImage() {
        let insertionIndex = songs.count
        songs.append("New Song")
        let indexPath = IndexPath(row: insertionIndex, section: 3)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
@objc func addSong() {
        let insertionIndex = songs.count
        songs.append("New Song")
        let indexPath = IndexPath(row: insertionIndex, section: 3)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    
    
    @objc func uploadButtonTapped(_ sender: Any) {
        print("Upload was tapped by \(String(describing: user?.username))")
        let cell = tableView.cellForRow(at: [0,0]) as! TrackTitleTVC
        guard let trackTitle = cell.titleTextField.text else {return}
        

        guard let userProfile = UserService.currentUserProfile else { return }
        uploadSongs { (songs) in
            
            guard let image = self.coverImage.image else {return}
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            self.uploadCoverImage(imageView: image) { (imageUrl) in
                
            
            let data = [
            "uid" : self.user?.uid,
            "username" : self.user?.fullname,
            "photoURL" : self.user?.profileImageURL,
            "Genre" : SelectGenreTableViewController.genreLabelMultiple,
            "AudioUrl" : songs,
            "timestampt": [".sv":"timestamp"],
            "coverImage": imageUrl?.absoluteString,
            "likes": 0,
            "trackTitle": trackTitle] as [String : Any]

            
            
            let ref = Database.database().reference().child("audio").childByAutoId()

            ref.setValue(data, withCompletionBlock: { (error, reference) in
                self.progressView?.dismiss(true)
                SelectGenreTableViewController.genreLabelMultiple = ""
                
                guard let postID = ref.key else { return }
                let genre = SelectGenreTableViewController.genreLabel
                
                Database.database().reference().child("user-uploads").child(uid).updateChildValues([postID: 1]) { (err, ref) in
                }
                Database.database().reference().child("user-albums").child(uid).updateChildValues([postID: 1]) { (err, ref) in
                }
                Database.database().reference().child("audio-by-genres").child(genre).updateChildValues([postID: 1]) { (err, ref) in
                }
                
                 Database.database().reference().child("albums").child(postID).updateChildValues(data) { (err, ref) in
                }
                
                self.songs.removeAll()
                self.tableView.reloadData()
            })
            
            
            
            }
            
            
        }
        
        
    }
    
    func uploadSongs(completionHandler : ((_ abcd : [[String:Any]]) -> Void)? = nil){
        var downloadUrl = [[String:Any]]()
        if songsUrl.count == 0 {
            return
        }
        progressView =  CustomMRProgressView2.showOverlayAdded(to: self.view ,title: "Uploading file, please wait.", mode: .indeterminate, animated: true)
            
            //        progressView?.titleLabelText = "Uploading file, please wait."
            progressView?.setTintColor(UIColor.systemGray2)
            var attr = progressView?.titleLabelAttributedText.attributes(at: 0, effectiveRange: nil)
            attr?[NSAttributedString.Key.foregroundColor] = UIColor.systemGray2
            progressView?.titleLabel.attributedText = NSAttributedString(string: progressView?.titleLabel.text ?? "", attributes: attr ?? [:])
            
        var index = 0

        for song in songsUrl {
            
            uploadAudioFile(url: song) { (url) in
                let songDetail = [self.songs[index] : url!.absoluteString]
                index+=1
                downloadUrl.append(songDetail)
                
                if self.songsUrl.count == downloadUrl.count{
                    
                    self.progressView?.mode = .checkmark
                    self.progressView?.titleLabelText = "Done"
                    
                    if let tableView =  self.progressView?.superview as? UITableView{
                        let frame = self.progressView?.frame
                        self.progressView?.frame = CGRect(x: frame?.minX ?? 0, y: tableView.contentOffset.y  - 70 , width: frame?.width ?? 0, height: frame?.height ?? 0)
                    }
                    
                    
                    completionHandler!(downloadUrl)
                    
                }
            }
            
        }
 }
    
    
@objc func selectImageFromPhotos(_ sender: Any) {
            
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                imagePicker.delegate = self
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
     if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
        coverImage.image = editedImage
        
        let headerView = addHeader(image: editedImage)
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 230)
        tableView.reloadData()
    
    dismiss(animated: true, completion: nil)
        }
    }
    
//    @IBAction func backButton(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    func uploadAudioFile(url : URL , completion: @escaping (_ url: URL?)->()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        //          let storageRef = Storage.storage().reference().child("users/\(uid)")
        let storageRef = Storage.storage().reference().child("audio./\(UUID())")
        let metaData = StorageMetadata()
        metaData.contentType = "audio/wav"
        
    
        storageRef.putFile(from: url, metadata: metaData) { (metaData, error) in
            if error == nil{
                print("success for audio")
                storageRef.downloadURL(completion: { (url, error) in
                    
                    completion(url)
                })
            }else{
                
                
                print("error saving audio \(error?.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    
    func uploadCoverImage(imageView : UIImage , completion: @escaping (_ url: URL?)->()){
        let storageRef = Storage.storage().reference().child("Cover Image").child("\(UUID())")
        let imageData = imageView.jpegData(compressionQuality: 0.8)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        storageRef.putData(imageData!, metadata: metaData) { (metaData, error) in
            if error == nil{
                print("success for cover image")
                storageRef.downloadURL(completion: { (url, error) in
                    completion(url)
                })
            }else{
                
                print("error in save image")
                completion(nil)
            }
        }
    }
    
    
}

extension MultipleSongsTableViewController {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 3: return songs.count
        default: return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TrackTitleTVC
            
            
            return cell
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier2, for: indexPath) as! GenreTVC
            if SelectGenreTableViewController.genreLabelMultiple != ""{
                cell.genrelabel.text = SelectGenreTableViewController.genreLabelMultiple
            }else{
                cell.genrelabel.text = "Select a Genre"
            }

            return cell
        } else if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier3, for: indexPath) as! TrackListTVC
            
            return cell
        } else if indexPath.section == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier4, for: indexPath) as! TrackListSongTVC
            
            cell.trackNumber.text = String(indexPath.row + 1)
            
            if AddAudioMutliSongsTableViewController.trackTitle != nil && selectedRow == indexPath.row {
                cell.songName.text = AddAudioMutliSongsTableViewController.trackTitle
                AddAudioMutliSongsTableViewController.trackTitle = nil
            }
            cell.songName.text = songs[indexPath.row]
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier5, for: indexPath) as! AddSongTVC
            
            cell.addAudioButton.addTarget(self, action: #selector(addSong), for: .touchUpInside)
            return cell
        }
    }
    
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
        return 94
        } else  if indexPath.section == 1 {
            return 65
        } else if indexPath.section == 2 {
        return 71
        } else if indexPath.section == 3 {
           return 52
        } else {
            return 95
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        }
        if indexPath.section == 1 {
            let controller = SelectGenreTableViewController()
            navigationController?.pushViewController(controller, animated: true)
            controller.isSingleAudio = false
        } else if indexPath.section == 2 {
         
        } else if indexPath.section == 3 {
            let controller = AddAudioMutliSongsTableViewController()
            navigationController?.pushViewController(controller, animated: true)
            selectedRow = indexPath.row
            
            
        } else if indexPath.section == 4 {
            
        } else {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            songs.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            let insertionIndex = songs.count
            let indexPath = IndexPath(row: insertionIndex, section: 3)
            if indexPath.row + 1 <= songsUrl.count{
                songsUrl.remove(at: indexPath.row)
                
            }
//            songNames.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}

class CustomMRProgressView2 : MRProgressOverlayView{
    override func createBlurView() -> UIView? {
        let cornerRadius : CGFloat = 7//super.MRProgressOverlayViewCornerRadius;
        
        
        
        let maskView = UIView()
//        maskView.backgroundColor = UIColor.clear
//        let blurEffect = UIBlurEffect(style: .dark)
//        let blurEffectview = UIVisualEffectView(effect: blurEffect)
//        blurEffectview.frame = maskView.bounds
//        blurEffectview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        maskView.addSubview(blurEffectview)
        maskView.layer.cornerRadius = cornerRadius
        return maskView// super.effectView
        

    }
    override func show(_ animated: Bool) {
        super.show(animated)
   

        if let tableView =  self.superview as? UITableView{
            self.frame = CGRect(x: frame.minX, y: tableView.contentOffset.y - 70, width: frame.width , height: frame.height)
        }
        
    }
   // cr
}
