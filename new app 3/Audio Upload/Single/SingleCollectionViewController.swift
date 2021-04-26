//
//  SingleCollectionViewController.swift
//  new app 3
//
//  Created by William Hinson on 7/21/20.
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


class SingleCollectionViewController: UICollectionViewController, UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePicker = UIImagePickerController()
    
    let audioHeaderCell = AudioHeaderCell()
    
    var headerView : AudioCollectionReusableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

//        collectionView.register(AudioCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)


        self.collectionView!.register(TrackTitle.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(Genre.self, forCellWithReuseIdentifier: reuseIdentifier2)
        self.collectionView!.register(FeaturedArtist.self, forCellWithReuseIdentifier: reuseIdentifier3)
        self.collectionView!.register(AddAudio.self, forCellWithReuseIdentifier: reuseIdentifier4)
        self.collectionView!.register(AudioHeaderCell.self, forCellWithReuseIdentifier: headerCellIdentifier)
        self.collectionView!.register(UploadFooterCell.self, forCellWithReuseIdentifier: footerCellIdentifier)
    }
    

    // MARK: -UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellIdentifier, for: indexPath) as! AudioHeaderCell
        cell.delegate = self
            cell.addImageButton.addTarget(self, action: #selector(SingleCollectionViewController.selectImage), for: .touchUpInside)
            
        return cell
        }
        if indexPath.section == 1 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TrackTitle

        return cell
        } else if indexPath.section == 2 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier2, for: indexPath) as! Genre

        return cell
        } else if indexPath.section == 3 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier3, for: indexPath) as! FeaturedArtist

        return cell
        } else if indexPath.section == 4 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier4, for: indexPath) as! AddAudio
        cell.addAudioButton.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)

        return cell
        } else {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: footerCellIdentifier, for: indexPath) as! UploadFooterCell
        return cell
        }
    }
    
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//           let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! AudioCollectionReusableView
////           header.delegate = self
////           header.profileController = self
////           header.user = self.user
//           return header
//       }
}

extension SingleCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
        return CGSize(width: view.frame.width, height: 230)
        }
        if indexPath.section == 1 {
            return CGSize(width: view.frame.width, height: 80)
        } else if indexPath.section == 2 {
            return CGSize(width: view.frame.width, height: 70)
        } else if indexPath.section == 3 {
            return CGSize(width: view.frame.width, height: 158)
        } else if indexPath.section == 4 {
            return CGSize(width: view.frame.width, height: 158)
        } else {
            return CGSize(width: view.frame.width, height: 98)

        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        }
        if indexPath.section == 1 {
            
        } else if indexPath.section == 2 {
            let controller = SelectGenreTableViewController()
            navigationController?.pushViewController(controller, animated: true)
        } else if indexPath.section == 3 {
            
        } else if indexPath.section == 4 {
            
        } else {
            
        }
    }
    
    @objc func showActionSheet() {
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
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        
//        return CGSize(width: view.frame.height, height: 230)
//    }
    
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
                audioHeaderCell.coverImage.image = editedImage
            } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            audioHeaderCell.coverImage.image = originalImage
            }
            
            dismiss(animated: true, completion: nil)
    }
}


extension SingleCollectionViewController: AudioHeaderCellDelegate {
    func handleButtonTap() {
        print("tapped")
    }
    
    
}
