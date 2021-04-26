//
//  AddAudioMutliSongsTableViewController.swift
//  audioPlayerApp
//
//  Created by William Hinson on 2/12/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import MobileCoreServices

private let reuseIdentifier = "TrackTitle"
private let reuseIdentifier2 = "Genre"
private let reuseIdentifier3 = "FeaturedArtist"
private let reuseIdentifier4 = "AddAudio"

class AddAudioMutliSongsTableViewController: UITableViewController, UIDocumentPickerDelegate {

    public var audioName: String?
    static var audioUrl : URL?
    static var trackTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.tableView.register(TrackTitleTVC.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.register(GenreTVC.self, forCellReuseIdentifier: reuseIdentifier2)
        self.tableView.register(FeaturedArtistTVC.self, forCellReuseIdentifier: reuseIdentifier3)
        self.tableView.register(AddAudioTVC.self, forCellReuseIdentifier: reuseIdentifier4)
        self.tableView.separatorColor = .clear
        
        let barbutton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(backButtonTapped(_:)))
        self.navigationItem.leftBarButtonItem = barbutton
        
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
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        AddAudioMutliSongsTableViewController.audioUrl = urls.first
        audioName = AddAudioMutliSongsTableViewController.audioUrl?.lastPathComponent
        //AddAudioMutliSongsTableViewController.trackTitle = AddAudioMutliSongsTableViewController.audioUrl?.lastPathComponent

        tableView.reloadData()
    }
    
    @objc func backButtonTapped(_ sender: Any) {
        tableView.reloadData()
//        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)

    }
    
}

extension AddAudioMutliSongsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }  else {
            return 1
        }
       }
       
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TrackTitleTVC
            if cell.titleLabel.text != nil{
            AddAudioMutliSongsTableViewController.trackTitle = cell.titleTextField.text
            }
//            if AddAudioMutliSongsTableViewController.trackTitle != nil {
//                cell.titleTextField.text = AddAudioMutliSongsTableViewController.trackTitle
//            }
        return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier4, for: indexPath) as! AddAudioTVC
            
            cell.addAudioButton.addTarget(self, action: #selector(UploadTrackTableViewController.showActionSheet), for: .touchUpInside)
            if audioName != nil {
                cell.descriptionLabel.text = audioName

            }
            return cell
        }
        
       }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 94
        } else  {
            return 158
        }

    }

}
