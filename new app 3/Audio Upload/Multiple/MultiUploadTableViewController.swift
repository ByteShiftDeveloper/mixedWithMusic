//
//  MultiUploadTableViewController.swift
//  new app 3
//
//  Created by William Hinson on 7/28/20.
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
private let reuseIdentifier5 = "AddSong"
private let headerCellIdentifier = "AudioHeaderCell"
private let footerCellIdentifier = "UploadFooterCell"
private let headerIdentifier = "AudioHeader"

class MultiUploadTableViewController:  UITableViewController, UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

//    var headerView: AudioHeader!
    
    var imagePicker = UIImagePickerController()
    var audioUrl : URL?
    var audioName : String?
    var progressView : CustomMRProgressView?
    var dismissTimer: Timer?
    var selectedRow : Int = -1
    
    var songs = [String]()
    var songsUrl = [URL]()

    
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
          //       button.addTarget(self, action: #selector(handleFollowTap), for: .touchUpInside)
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
        
        imagePicker.delegate = self
        
        self.tableView.register(TrackTitleTVC.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.register(GenreTVC.self, forCellReuseIdentifier: reuseIdentifier2)
        self.tableView.register(TrackListTVC.self, forCellReuseIdentifier: reuseIdentifier3)
        self.tableView.register(TrackListSongTVC.self, forCellReuseIdentifier: reuseIdentifier4)
        self.tableView.register(AddSongTVC.self, forCellReuseIdentifier: reuseIdentifier5)
        
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 230)
        
        tableView.tableFooterView = footerView
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)

//        self.tableView.register(AudioHeaderCell.self, forCellReuseIdentifier: headerCellIdentifier)
//        self.tableView.register(UploadFooter.self, forCellReuseIdentifier: footerCellIdentifier)

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
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

        return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier3, for: indexPath) as! TrackListTVC
//        cell.addAudioButton.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)

        return cell
        } else if indexPath.section == 3{
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
            cell.addAudioButton.addTarget(self, action: #selector(insertNewSongCell), for: .touchUpInside)
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
    
   @objc func insertNewSongCell() {
          let insertionIndex = songs.count
          songs.append("New Song")
          let indexPath = IndexPath(row: insertionIndex, section: 3)
          tableView.insertRows(at: [indexPath], with: .automatic)
      }
      
    
    
    
    
    @objc func selectImage() {
        print("tapped")
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .savedPhotosAlbum
        self.imagePicker.allowsEditing = true
        self.present(self.imagePicker, animated: true, completion: nil)
        //            print("text\(textView.text)")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
           coverImage.image = editedImage
       
       dismiss(animated: true, completion: nil)
           }
       }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        audioUrl = urls.first
        audioName = audioUrl?.lastPathComponent
        tableView.reloadData()
    }

}


extension MultiUploadTableViewController: AddAudioDelegate {
    func addAudio() {
        print("tapped")
        
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
    
    
}
