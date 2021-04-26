//
//  UploadPostController.swift
//  new app 3
//
//  Created by William Hinson on 7/2/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//


import UIKit
import Firebase
import MobileCoreServices
import AVFoundation
import LinkPresentation

class UploadPostController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
    var imagePicker = UIImagePickerController()

    var databaseRef = Database.database().reference()
    
    var videoURL: URL?
    
    var feedController: FeedController?

    private let user: User
    
    var stringURL = ""
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor(named: "DefaultBackgroundColor")
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        containerView.addSubview(imageSelect)
        imageSelect.anchor1(top: nil, left: containerView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 29, paddingBottom: 0, paddingRight: 0, width: 27, height: 20)
        imageSelect.centerY(inView: containerView)
        
        containerView.addSubview(cameraSelect)
        cameraSelect.anchor1(top: nil, left: imageSelect.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 29, paddingBottom: 0, paddingRight: 0, width: 27, height: 20)
        cameraSelect.centerY(inView: containerView)
        
        containerView.addSubview(uploadAudio)
        uploadAudio.anchor1(top: nil, left: cameraSelect.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 29, paddingBottom: 0, paddingRight: 0, width: 23, height: 20)
        uploadAudio.centerY(inView: containerView)
        
        containerView.addSubview(uploadGig)
        uploadGig.anchor1(top: nil, left: uploadAudio.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 29, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        uploadGig.centerY(inView: containerView)
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lightGray
        containerView.addSubview(seperatorView)
        seperatorView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        return containerView
    }()

    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Post", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handlePostUpload), for: .touchUpInside)
        
        button.frame = CGRect(x: 0, y: 0, width: 105, height: 32)
        button.layer.cornerRadius = 32 / 2
        
        
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 0, height: 370)
//        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let linkView: UIView = {
       let view = UIView()
        view.clipsToBounds = true
        view.setDimensions(width: 0, height: 370)
        return view
    }()
    
    private let postVideoView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 0, height: 370)
//        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private lazy var imageSelect: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.tintColor = UIColor(named: "BlackColor")
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
//        button.setDimensions(width: 18, height: 16)
        button.addTarget(self, action: #selector(handleImageSelect), for: .touchUpInside)
        return button
    }()
    
    private lazy var cameraSelect: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = UIColor(named: "BlackColor")
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
//           button.setDimensions(width: 18, height: 16)
        button.addTarget(self, action: #selector(handleCameraTap), for: .touchUpInside)
        return button
       }()
    
     private lazy var uploadAudio: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(UIImage(systemName: "waveform.path.badge.plus"), for: .normal)
            button.tintColor = UIColor(named: "BlackColor")
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill
    //           button.setDimensions(width: 18, height: 16)
            button.addTarget(self, action: #selector(handleAudioTapped), for: .touchUpInside)
            return button
           }()
    
    private lazy var uploadGig: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "application.png"), for: .normal)
        button.tintColor = UIColor(named: "BlackColor")
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(handleGigTapped), for: .touchUpInside)
        return button
    }()

    
    private let replyText = PostInputText()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replyText.inputAccessoryView = containerView
        
        replyText.delegate = self

        configureUI()
        
//        addLinkToViewContainer()
        
        replyText.becomeFirstResponder()
        
        
        
        actionButton.applyGradient(colors: [UIColor.black.cgColor, Colors.space.cgColor])
        
        
        profileImageView.loadImage(with: user.profileImageURL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleImageSelect() {
        print("tapped")
        
        
         if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.imagePicker.allowsEditing = true
            self.imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
            self.present(self.imagePicker, animated: true, completion: nil)
            if replyText.text != nil{
            }
        }
    }
    
    @objc func handleCameraTap() {
        print("tapped")
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .camera
        self.imagePicker.allowsEditing = false
        self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func handleAudioTapped() {
        print("tapped")
        let controller = WAYUViewController()
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleGigTapped() {
        print("tapped")
        let controller = GigApplication()
//        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func checkForURL(string: String) {
        let detectorType: NSTextCheckingResult.CheckingType = [.link]
        do {
            let detector = try NSDataDetector(types: detectorType.rawValue)
            let results = detector.matches(in: string, options: [], range: NSRange(location: 0, length:
        string.utf16.count))
            
            for result in results {
                if let range = Range(result.range, in: string) {
                    let matchResult = string[range]
                    previewURL(string: String(matchResult))
                    stringURL = String(matchResult)
                    print("result: \(matchResult), range: \(result.range)")
                } else {
                    
                }
            }
            
        } catch {
            print("handle error")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        checkForURL(string: replyText.text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkForURL(string: replyText.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        checkForURL(string: replyText.text)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        checkForURL(string: replyText.text)
    }
  
    
//    func addLinkToViewContainer() {
//        self.link.frame = self.linkView.bounds
//        self.linkView.addSubview(self.link)
//        self.linkView.sizeToFit()
//    }
//
    func previewURL(string: String) {
        guard let url = URL(string: string) else { return }
        
        let linkPreview = LPLinkView()
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url) { (metaData, error) in
            guard let data = metaData, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                linkPreview.metadata = data
                self.view.addSubview(linkPreview)
                linkPreview.anchor(top: self.replyText.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 16, paddingLeft: 8, paddingRight: 8, height : 370)
            }
        }
    }
    
    
    
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
            if let vidURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                
                self.videoURL = vidURL
                
                print("here is the file url:" , vidURL)
                
                
                
//                self.uploadPostVideo(url: vidURL)
                
                if let thumbnail = self.thumbnailImageForVideoURL(fileURL: vidURL) {
                    self.postVideoView.image = thumbnail
                }
            }
            
            if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
               postImageView.image = editedImage
           } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           postImageView.image = originalImage
           }
           
           dismiss(animated: true, completion: nil)
            
        
        }
    
    private func thumbnailImageForVideoURL(fileURL: URL) -> UIImage? {
        let asset = AVAsset(url: fileURL )
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailCGI =  try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGI)
            
        } catch  let err {
            print(err)
        }
        
        return nil
    }
        
    func configureUI() {
           view.backgroundColor = UIColor(named: "DefaultBackgroundColor")
           configureNavigationBar()
           
           let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, replyText])
           imageCaptionStack.axis = .horizontal
           imageCaptionStack.spacing = 12
           imageCaptionStack.alignment = .leading
           
           let stack = UIStackView(arrangedSubviews: [imageCaptionStack])
           stack.axis = .vertical
           stack.spacing = 12
        
        if actionButton.isEnabled == true {
            actionButton.alpha = 1.0
        } else if actionButton.isEnabled == false {
            actionButton.alpha = 0.5
        }
           
           view.addSubview(stack)
           stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                        right: view.rightAnchor, paddingTop: 16, paddingLeft: 16,
                        paddingRight: 16)
        
        view.addSubview(postImageView)
        postImageView.anchor(top: imageCaptionStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16)
        
        view.addSubview(linkView)
        linkView.anchor(top: imageCaptionStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16)
        
        view.addSubview(postVideoView)
        postVideoView.anchor(top: imageCaptionStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16)
        
                   
       }
 
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(named: "DefaultBackgroundColor")
        navigationController?.navigationBar.isTranslucent = false
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
//        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationController?.navigationBar.tintColor = UIColor(named: "BlackColor")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
//        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc func handlePostUpload() {

        if postImageView.image != nil && replyText.text != "" {
            guard let text = replyText.text else { return }
            uploadPostPhoto { photoURL in
                Service.shared.uploadPostWithImage(caption: text, postImage: photoURL?.absoluteString ?? "") { (ref, err) in
                    print("success")
                    self.feedController?.handleRefresh()
                    self.dismiss(animated: true, completion: nil)
            
                }
            }
        } else if (replyText.text != "" && stringURL != "") {
            let url = stringURL
            let text = replyText.text.replacingOccurrences(of: url, with: "")
            Service.shared.uploadPostWithURL(caption: text, url: url) { (ref, err) in
                print("This should upload")
                self.feedController?.handleRefresh()
                print("URL is \(url)")
                self.dismiss(animated: true, completion: nil)
         
                
            }
        } else  if (replyText.text != "") {
            guard let text = replyText.text else { return }
            Service.shared.uploadPost(caption: text) { (ref, err) in
                print("This should upload")
                self.feedController?.handleRefresh()
                self.dismiss(animated: true, completion: nil)
         
                
            }
        } else if (postImageView.image != nil) {
            uploadPostPhoto{ photoURL in
                Service.shared.uploadImageOnly(postImage: photoURL?.absoluteString ?? "") { (ref, err) in
                    self.feedController?.handleRefresh()
                    self.dismiss(animated: true, completion: nil)
           
                }
            }
        } else if (postVideoView.image != nil && postImageView.image == nil) {
//            uploadPostVideo(url: videoURL!)
            uploadVideo(url: videoURL!) { (url, error) in
                Service.shared.uploadVideoOnly(postVideo: url?.absoluteString ?? "") { (err, ref) in
                    self.feedController?.handleRefresh()
                    self.dismiss(animated: true, completion: nil)
             

                }
            }
            
        } else if (postVideoView.image != nil && replyText.text != nil) {
            guard let text = replyText.text else { return }
//            uploadPostVideo(url: videoURL!)
            uploadVideo(url: videoURL!) { (url, error) in
                Service.shared.uploadPostWithVideo(caption: text, postvideo: url?.absoluteString ?? "") { (err, ref) in
                    self.feedController?.handleRefresh()
                    self.dismiss(animated: true, completion: nil)
                }
            }
           
        }
    }
    
    //MARK: -API Calls

         func uploadPostPhoto( completion: @escaping (_ url: URL?)->()) {
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let storageRef = Storage.storage().reference().child("users/profile/\(uid)/\(UUID())")
            let lowResImageData = (postImageView.image!).jpegData(compressionQuality: 0.80)
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpeg"

                storageRef.putData(lowResImageData!, metadata: metaData) { (metaData, error) in
                    if error == nil{

                        print("success for profile photo")
                        storageRef.downloadURL(completion: { (url, error) in
                             completion(url)
                        })
                    }else{
                        print("error in save image")
                        completion(nil)
                    }
                }
            }
    
        
//    func uploadPostVideo(url: URL) {
//        let filename = "postUploads"
//        let storageRef = Storage.storage().reference().child("postUploads/\(UUID())")
//        let metadata = StorageMetadata()
//        metadata.contentType = "video/quicktime"
//
//        let vidURL = NSData(contentsOf: url) as Data?
//        let uploadTask = storageRef.putData(vidURL!, metadata: metadata)
//
//        uploadTask.observe(.progress) { (snapshot) in
//            print(snapshot.progress?.completedUnitCount)
//
//
//        }
//    }
    
    func uploadVideo(url : URL, completionHandler : ((_ url : URL? , _ error : Error?) -> Void)? = nil){
        
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + UUID().uuidString + ".mp4")
        compressVideo(inputURL: url, outputURL: compressedURL) { [weak self](session) in
            guard let session = session else {
                return
            }
            
            switch session.status {
            case .unknown:
                completionHandler!(nil,nil)
                break
            case .waiting:
                completionHandler!(nil,nil)
                break
            case .exporting:
                completionHandler!(nil,nil)
                break
            case .completed:
                guard let compressedData = try? Data(contentsOf: compressedURL) else {
                    return
                }
                let vidName = UUID()
//                let vidReference = self?.storageRef.child("Videos/\(vidName).mp4")
//
                let filename = "postUploads"
                let storageRef = Storage.storage().reference().child("postUploads/\(UUID()).mp4")
                let metadata = StorageMetadata()
//                metadata.contentType = "video/quicktime"
                
//                let vidReference = self?.storageRef.child("Videos/\(vidName).mp4")

                
                storageRef.putData(compressedData, metadata: nil) { (metadata, error) in
                    guard let _ = metadata else {
                        completionHandler!(nil,error)
                        // Uh-oh, an error occurred!
                        return
                    }
                    
                    // You can also access to download URL after upload.
                    storageRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            completionHandler!(nil,error)
                            // Uh-oh, an error occurred!
                            return
                        }
                        completionHandler!(downloadURL,error)
                    }
                    
                    print("File size after compression: \(Double(compressedData.count / 1048576)) mb")
                    
                }
            default:
                completionHandler!(nil,nil)
                break
                
            }
            
            
        }
    }
    
    func compressVideo(inputURL: URL,
                       outputURL: URL,
                       handler:@escaping (_ exportSession: AVAssetExportSession?) -> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset,
                                                       presetName: AVAssetExportPresetMediumQuality) else {
                                                        handler(nil)
                                                        
                                                        return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously {
            handler(exportSession)
        }
        
    }
    
        
    func uploadHashtagToServer(withPostiD postID: String) {
           
           guard let text = replyText.text else { return }
           
           let words: [String] = text.components(separatedBy: .whitespacesAndNewlines)
           
           for var word in words {
               
               if word.hasPrefix("#") {
                   word = word.trimmingCharacters(in: .punctuationCharacters)
                   word = word.trimmingCharacters(in: .symbols)
                   
                   let hashtagValues = [postID: 1]
                   
                   HASHTAGPOSTREF.child(word.lowercased()).updateChildValues(hashtagValues)
               }
           }
       }
    
    internal func setProfilePic(imageView:UIImageView,imageToSet:UIImage) {
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.layer.masksToBounds = true
        imageView.image = imageToSet
        }
}
