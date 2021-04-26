//
//  UploadTrackTableViewController.swift
//  audioPlayerApp
//
//  Created by William Hinson on 2/5/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import MobileCoreServices
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import MRProgress

private let reuseIdentifier = "TrackTitle"
private let reuseIdentifier2 = "Genre"
private let reuseIdentifier3 = "FeaturedArtist"
private let reuseIdentifier4 = "AddAudio"
private let headerCellIdentifier = "AudioHeaderCell"
private let footerCellIdentifier = "UploadFooterCell"
private let headerIdentifier = "AudioHeader"


class UploadTrackTableViewController: UITableViewController, UINavigationControllerDelegate, UIDocumentPickerDelegate, UIImagePickerControllerDelegate {
    
    var user: User?

    @IBOutlet weak var uploadButtot: UIButton!
    
    @IBOutlet weak var trackImage: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
 
    var audioUrl : URL?
    var audioName : String?
    var progressView : CustomMRProgressView?
    var dismissTimer: Timer?
    
    let coverImage:UIImageView = {
              let iv = UIImageView()
              iv.contentMode = .scaleAspectFill
              iv.clipsToBounds = true
              iv.setDimensions(width: 150, height: 150)
              iv.backgroundColor = .purple
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
       
       let headerView: UIView = {
          let view = UIView()
           view.backgroundColor = .clear
           
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
                       button.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
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
       }()
       
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
           uploadButton.anchor(top: view.topAnchor, paddingTop: 21, width: 375, height: 50)
           uploadButton.centerX(inView: view)
           
           return view
       }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .black

        self.tableView.register(TrackTitleTVC.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.register(GenreTVC.self, forCellReuseIdentifier: reuseIdentifier2)
        self.tableView.register(FeaturedArtistTVC.self, forCellReuseIdentifier: reuseIdentifier3)
        self.tableView.register(AddAudioTVC.self, forCellReuseIdentifier: reuseIdentifier4)
               
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 230)
            
        tableView.tableFooterView = footerView
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
//        tableView.register(TrackTitleTableViewCell.self, forCellReuseIdentifier: "trackTitleCell")
//        tableView.register(SelectGenreTableViewCell.self, forCellReuseIdentifier: "genreCell")
//        tableView.register(AddFeaturedArtistTableViewCell.self, forCellReuseIdentifier: "featuredArtistCell")
//        tableView.register(SelectAudioFileTableViewCell.self, forCellReuseIdentifier: "audioCell")

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //progressView =  CustomMRProgressView.showOverlayAdded(to: self.view ,title: "Uploading file, please wait.", mode: .indeterminate, animated: true)
        tableView.reloadData()
    }

    
    @objc func uploadButtonTapped(_ sender: Any) {
        let cell = tableView.cellForRow(at: [0,0]) as! TrackTitleTVC
        guard let trackTitle = cell.titleTextField.text else {return}
        
        guard let audUrl = audioUrl else {return}
        guard let userProfile = UserService.currentUserProfile else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }

        uploadAudioFile(url: audUrl) { (audiourl) in
            
            guard let image = self.trackImage.image else {return}

            self.uploadCoverImage(imageView: image) { (imageUrl) in
                let ref = Database.database().reference().child("audio").childByAutoId()
                let data = [
                    "uploadBy" : [
                            "uid" : Auth.auth().currentUser?.uid,
                            "username" : userProfile.fullname
                ],
                "Genre" : GenreTableViewController.genreLabel,
                "AudioUrl" : [[trackTitle : audiourl?.absoluteString]],
                "timestampt": [".sv":"timestamp"],
                "coverImage": imageUrl?.absoluteString ?? "",
                "trackTitle": trackTitle] as [String : Any]
                
                
                ref.setValue(data, withCompletionBlock: { (error, reference) in
                    
                    
                    self.dismissTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.runTimer), userInfo: nil, repeats: false)
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    guard let postID = ref.key else { return }
                    
                    Database.database().reference().child("user-uploads").child(uid).updateChildValues([postID: 1]) { (err, ref) in
                    }

                    
                    
                    
                    GenreTableViewController.genreLabel = ""
                    self.audioName = nil
                    self.tableView.reloadData()
                })
            }

         
        }
        
                // self.addGesture()
    }
    
    @objc func runTimer(){
        self.progressView?.dismiss(true)
                
    }
    
    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UploadTrackTableViewController.showActionSheet))
        uploadButtot.addGestureRecognizer(tap)
    }
    
    @objc func showActionSheet() {
        let actionSheet = UIAlertController(title: "Select Audio File", message: "Please select audio file to upload, your file must be WAV or FLAC format", preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let iCloud = UIAlertAction(title: "iCloud", style: .default) { action in
        let documentPickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypeWaveformAudio)], in: .import)
            documentPickerController.delegate = self
            self.present(documentPickerController, animated: true, completion: nil)
        }
        
        actionSheet.addAction(iCloud)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func selectImage(_ sender: Any) {
            
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
        trackImage.image = editedImage
    
    dismiss(animated: true, completion: nil)
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        audioUrl = urls.first
        audioName = audioUrl?.lastPathComponent
        tableView.reloadData()
    }
    @IBAction func backButtonTapped(_ sender: Any) {
       
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func uploadAudioFile(url : URL , completion: @escaping (_ url: URL?)->()) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
    //          let storageRef = Storage.storage().reference().child("users/\(uid)")
        let storageRef = Storage.storage().reference().child("audio./\(UUID())")
        let metaData = StorageMetadata()
            metaData.contentType = "audio/wav"
        
        progressView =  CustomMRProgressView.showOverlayAdded(to: self.view ,title: "Uploading file, please wait.", mode: .indeterminate, animated: true)
        
//        progressView?.titleLabelText = "Uploading file, please wait."
        progressView?.setTintColor(UIColor.systemGray2)
        var attr = progressView?.titleLabelAttributedText.attributes(at: 0, effectiveRange: nil)
        attr?[NSAttributedString.Key.foregroundColor] = UIColor.systemGray2
        progressView?.titleLabel.attributedText = NSAttributedString(string:  progressView?.titleLabel.text ?? "", attributes: attr ?? [:])
        
        storageRef.putFile(from: url, metadata: metaData) { (metaData, error) in
                  if error == nil{
                      print("success for audio")
                      storageRef.downloadURL(completion: { (url, error) in
                        
                        self.progressView?.mode = .checkmark
                        self.progressView?.titleLabelText = "Done"
                        
                        if let tableView =  self.progressView?.superview as? UITableView{
                            let frame = self.progressView?.frame
                            self.progressView?.frame = CGRect(x: frame?.minX ?? 0, y: tableView.contentOffset.y  - 70 , width: frame?.width ?? 0, height: frame?.height ?? 0)
                        }

                        completion(url)
                      })
                  }else{
                    
                    self.progressView?.mode = .cross
                    self.progressView?.titleLabelText = "Failed"
                    self.progressView?.dismiss(true)
                    
                    if let tableView =  self.progressView?.superview as? UITableView{
                        let frame = self.progressView?.frame
                        self.progressView?.frame = CGRect(x: frame?.minX ?? 0, y: tableView.contentOffset.y  - 70 , width: frame?.width ?? 0, height: frame?.height ?? 0)
                    }
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


extension UploadTrackTableViewController {
   
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        } else {
            return 1
        }
       }
       
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TrackTitleTVC
            
                                          
                     return cell
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier2, for: indexPath) as! GenreTVC
            if GenreTableViewController.genreLabel != ""{
                cell.genrelabel.text = GenreTableViewController.genreLabel
            }else{
                cell.genrelabel.text = "Select a Genre"
            }
            return cell
        } else if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier3, for: indexPath) as! FeaturedArtistTVC
            
            return cell
        } else {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier4, for: indexPath) as! AddAudioTVC
            
            if audioName != nil {
                cell.descriptionLabel.text = audioName

            }else {
                cell.descriptionLabel.text = "Select your audio file to upload"

            }
            cell.addAudioButton.addTarget(self, action: #selector(UploadTrackTableViewController.showActionSheet), for: .touchUpInside)
        
        return cell
        
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
        return 94
        } else  if indexPath.section == 1 {
            return 86
        } else if indexPath.section == 2 {
        return 158
        } else {
           return 193
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        }
        if indexPath.section == 1 {
            let controller = SelectGenreTableViewController()
            navigationController?.pushViewController(controller, animated: true)
        } else if indexPath.section == 2 {
         
        } else if indexPath.section == 3 {
            
        } else if indexPath.section == 4 {
            
        } else {
            
        }
    }

   
}

class CustomMRProgressView : MRProgressOverlayView{
    override func createBlurView() -> UIView? {
        let cornerRadius : CGFloat = 7//super.MRProgressOverlayViewCornerRadius;
        
        let maskView = UIView()
        maskView.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .systemThickMaterialDark)
        let blurEffectview = UIVisualEffectView(effect: blurEffect)
        blurEffectview.frame = maskView.bounds
        blurEffectview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        maskView.addSubview(blurEffectview)
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
