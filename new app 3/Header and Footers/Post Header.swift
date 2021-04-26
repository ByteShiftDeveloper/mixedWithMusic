//
//  Post Header.swift
//  new app 3
//
//  Created by William Hinson on 5/15/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import ActiveLabel
import AVFoundation
import LinkPresentation


protocol PostHeaderDelegate: class {
    func showActionSheet()
    func handleProfileImageTapped(_ header: PostHeader)
    func handleFetchUser(withUsername username: String)
    func handleImageZoom(_ header: PostHeader)
    func handleVideoPlay(_ header: PostHeader)
    func handleSongTap(_ header: PostHeader)
    func handleLikeTap(_ header: PostHeader)

}

class PostHeader: UICollectionReusableView {
    
    var post: Post? {
        didSet { congifureUI() }
    }
    
    weak var delegate: PostHeaderDelegate?
    var postController: SelectedPostController?

    
    private lazy var profileImageView: UIImageView = {
           let iv = UIImageView()
           iv.contentMode = .scaleAspectFill
           iv.clipsToBounds = true
           iv.setDimensions(width: 50, height: 50)
           iv.layer.cornerRadius = 50 / 2
           iv.backgroundColor = .lightGray
           
           let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageTap))
           iv.addGestureRecognizer(tap)
           iv.isUserInteractionEnabled = true
           
           return iv
       }()
    
        let linkView: UIView = {
            let view = UIView()
            view.backgroundColor = .lightGray
            return view
        }()
       
       
       private let fullnameLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.boldSystemFont(ofSize: 18)
           label.text = "Peter Parker"
           return label
       }()
       
       private let timestampLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.systemFont(ofSize: 14)
           label.textColor = .lightGray
           label.text = "15 minutes ago"
           return label
       }()
    
     let postTextLabel: ActiveLabel = {
       let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.mentionColor = Colors.activelabelblue
        label.hashtagColor = Colors.activelabelblue
        label.text = "Some random type of text"
        return label
    }()
    
    private let postPicture: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
//        iv.setHeight(height: 317)
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 5
        return iv
    }()
    
    let postVideo: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
//        iv.setHeight(height: 317)
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 5
        return iv
    }()
    
    let songView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    let infoView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    let songInfoLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "This is the song information."
        return label
    }()
    
    let artistLabel: UILabel =  {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Artist name"
        return label
    }()

    
    let coverImage: UIImageView = {
       let iv = UIImageView()
       iv.contentMode = .scaleAspectFill
       iv.clipsToBounds = true
       iv.setHeight(height: 200)
       iv.backgroundColor = .lightGray
       let tap = UITapGestureRecognizer(target: self, action: #selector(handleImageZoom(tapGesture:)))
       iv.addGestureRecognizer(tap)
       iv.isUserInteractionEnabled = true
       iv.layer.cornerRadius = 10
       iv.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
       return iv
   }()
    
    
        let playButton: UIButton = {
           let button = UIButton()
            button.setImage(UIImage(systemName: "play 5.png"), for: .normal)
            button.tintColor = .white
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill
            return button
        }()
    
    let songPlayButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play 5.png"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.setDimensions(width: 20, height: 10)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var commentsLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.systemFont(ofSize: 12)
           label.textColor = .lightGray
           label.text = "1 comment"
           return label
       }()
    
    lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.text = "1"
        return label
    }()
       
    
  private lazy var commentButton: UIButton = {
          let button = UIButton(type: .system)
               button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
               button.tintColor = .black
           button.setTitle("Comments", for: .normal)
           button.setDimensions(width: 22, height: 20)
//           button.addTarget(self, action: #selector(handleCommentTap), for: .touchUpInside)
           return button
       }()
       
       private lazy var repostButton: UIButton = {
               let button = UIButton(type: .system)
                   button.setImage(UIImage(systemName: "arrow.2.squarepath"), for: .normal)
                   button.tintColor = .black
                   button.setDimensions(width: 22, height: 16)
//                   button.addTarget(self, action: #selector(handleRepostTap), for: .touchUpInside)
                   return button
       }()
       
       lazy var likeButton: UIButton = {
               let button = UIButton(type: .system)
                   button.setImage(UIImage(systemName: "heart"), for: .normal)
                   button.tintColor = .black
           button.setTitle("Like", for: .normal)
                   button.setDimensions(width: 22, height: 20)
                   button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
                   return button
               }()


       private lazy var shareButton: UIButton = {
               let button = UIButton(type: .system)
                   button.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
                   button.tintColor = .black
                   button.setDimensions(width: 24, height: 20)
//                   button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
                   return button
       }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(handleImageZoom))
        imageTap.numberOfTouchesRequired = 1
        postPicture.isUserInteractionEnabled = true
        postPicture.addGestureRecognizer(imageTap)
//        postVideo.isUserInteractionEnabled = true
//        postVideo.addGestureRecognizer(imageTap)
        
        let labelStack = UIStackView(arrangedSubviews: [fullnameLabel, timestampLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -15
        let stack = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        stack.spacing = 12
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        addSubview(postTextLabel)
        postTextLabel.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16)
        
        addSubview(postPicture)
        postPicture.anchor(top: postTextLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 8, paddingRight: 8, width: frame.width, height: 317)
        
        addSubview(songView)
        songView.anchor(top: postTextLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 8, paddingRight: 8, width: frame.width, height: 150)
        
        addSubview(postVideo)
        postVideo.anchor(top: postTextLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 8, paddingRight: 8, width: frame.width, height: 317)
        
        addSubview(linkView)
        linkView.anchor(top: postTextLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 8, paddingRight: 8, width: frame.width, height: 317)
        
        addSubview(playButton)
        playButton.addTarget(self, action: #selector(handleVideoTap), for: .touchUpInside)
        playButton.centerX(inView: postVideo)
        playButton.centerY(inView: postVideo)
        playButton.anchor(width: 50, height: 50)
        
        songView.addSubview(coverImage)
        coverImage.anchor(top: songView.topAnchor, left: songView.leftAnchor, paddingLeft: 0, width: 150, height: 150)
        
        
        songView.addSubview(infoView)
        infoView.anchor(left: coverImage.rightAnchor, right: songView.rightAnchor, height: 150)
        
        infoView.addSubview(songInfoLabel)
        songInfoLabel.centerX(inView: infoView)
        songInfoLabel.anchor(top: infoView.topAnchor, paddingTop: 56)
        
        infoView.addSubview(artistLabel)
        artistLabel.centerX(inView: infoView)
        artistLabel.anchor(top: songInfoLabel.bottomAnchor, paddingTop: 6)
        
        
        coverImage.addSubview(songPlayButton)
        songPlayButton.centerX(inView: coverImage)
        songPlayButton.centerY(inView: coverImage)
        songPlayButton.anchor(width: 30, height: 30)
        songPlayButton.addTarget(self, action: #selector(handleSongTap), for: .touchUpInside)
        
        addSubview(optionsButton)
        optionsButton.centerY(inView: stack)
        optionsButton.anchor(right: rightAnchor, paddingRight: 16)
        
//        addSubview(statsView)
//        statsView.anchor(top: postPicture.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, height: 40)
        
        let buttonStack = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        buttonStack.spacing = 100
        
        addSubview(buttonStack)
        buttonStack.centerX(inView: self)
        buttonStack.anchor(bottom: bottomAnchor, paddingBottom: 8)
        
        let divider = UIView()
        divider.backgroundColor = .tertiarySystemGroupedBackground
        addSubview(divider)
        divider.anchor(left: leftAnchor, bottom: buttonStack.topAnchor,
                       right: rightAnchor, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, height: 1)
        
        addSubview(likesLabel)
        //            likesLabel.anchor(left: likeButton.rightAnchor, bottom: bottomAnchor , paddingLeft: 1, paddingBottom: 11)
        likesLabel.anchor(left: leftAnchor, bottom: divider.topAnchor, paddingLeft: 16, paddingBottom: 2)
        
        
        
        addSubview(commentsLabel)
        //            commentsLabel.anchor(left: commentButton.rightAnchor, bottom: bottomAnchor , paddingLeft: 1, paddingBottom: 11)
        
//        commentsLabel.anchor(top: postPicture.bottomAnchor, right: rightAnchor, paddingTop: 2, paddingRight: 16)
        commentsLabel.anchor(bottom: divider.topAnchor, right: rightAnchor, paddingBottom: 2, paddingRight: 16)
        
        let underlineView = UIView()
        underlineView.backgroundColor = .tertiarySystemGroupedBackground
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor,
                             right: rightAnchor, height: 1)
        
        
        configureMentionHandler()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createButton(withImageName imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }
    
    @objc func profileImageTap() {
        delegate?.handleProfileImageTapped(self)
     
    }
    
    @objc func showActionSheet() {
        delegate?.showActionSheet()
        
    }
    
    @objc func handleShareTapped() {
        print("Share tapped")
    }
    
    @objc func handleCommentTapped() {
        print("Comment tapped")
    }
    
    @objc func handleLikeTapped() {
        delegate?.handleLikeTap(self)
    }
    
    @objc func handleRepostTapped() {
        print("Repost tapped")
    }
    
    @objc func handleImageZoom(tapGesture: UITapGestureRecognizer) {
        delegate?.handleImageZoom(self)
        let imageView = tapGesture.view as? UIImageView
        self.postController?.performZoomInForStartingImageView(startingImageView: imageView!)
    }
    
    @objc func handleVideoTap() {
        delegate?.handleVideoPlay(self)
//        let imageView = tapGesture.view as? UIImageView
//        self.postController?.performZoomInForStartingImageView(startingImageView: imageView!)
    }
    
    @objc func handleSongTap() {
        delegate?.handleSongTap(self)
//        postController?.song = songPost
    }
    
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
                self.addSubview(linkPreview)
                linkPreview.anchor(top: self.postTextLabel.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 5, paddingLeft: 16, paddingRight: 16, height : 317)
            }
        }
    }

    
    func congifureUI() {
        guard let post = post else { return }
        
        let viewModel = PostViewModel(post: post)
        
        profileImageView.loadImage(with: post.user.profileImageURL)
        postTextLabel.text = post.text
        fullnameLabel.text = post.user.fullname
        
        if post.picture != "" {
            postPicture.loadImage(with: post.picture)
            postPicture.setHeight(height: 317)
        } else {
            postPicture.setHeight(height: 0)
        }
        
        if post.songID != "" {
            
            Service.shared.fetchUpload(withSongID: post.songID) { (song) in
                self.coverImage.loadImage(with: song.coverImage.absoluteString)
            }
   
            for constraint in coverImage.constraints {
                if constraint.firstAnchor == coverImage.heightAnchor {
                    constraint.isActive = false
                    
                }
                
            }
            
            songView.setHeight(height: 150)
            coverImage.setHeight(height: 150)
            infoView.setHeight(height: 150)
            artistLabel.isHidden = false
            songInfoLabel.isHidden = false
            
        }  else {
            for constraint in coverImage.constraints {
                if constraint.firstAnchor == coverImage.heightAnchor {
                    constraint.isActive = false
                    
                }
                
            }
            songView.setHeight(height: 0)
            coverImage.setHeight(height: 0)
            infoView.setHeight(height: 0)
            artistLabel.isHidden = true
            songInfoLabel.isHidden = true
            
        }
        
        if post.postURL != "" {
            let url = post.postURL
            previewURL(string: url)
            for constraint in linkView.constraints {
                if constraint.firstAnchor == linkView.heightAnchor {
                    constraint.isActive = false
                    
                }
                
            }
            
            linkView.setHeight(height: 317)
            

            
        }
        else {
            for constraint in linkView.constraints {
                if constraint.firstAnchor == linkView.heightAnchor {
                    constraint.isActive = false
                    
                }
                
            }
            linkView.setHeight(height: 0)
        }

        
        if post.video != "" {
            guard let videoURL = URL(string: post.video) else { return }
            if let thumbnail = self.thumbnailImageForVideoURL(fileURL: videoURL) {
                self.postVideo.image = thumbnail
            }
            postVideo.setHeight(height: 317)
        } else {
            postVideo.setHeight(height: 0)
            playButton.isHidden = true
        }
        
        if post.text == "" {
            postTextLabel.setHeight(height: 0)
        }
        
//        if post.didLike == false {
//            likeButton.tintColor = .black
//            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
//        } else if post.didLike == true {
//            likeButton.tintColor = .red
//            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)        }
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        
        timestampLabel.text = post.createdAt.calenderTimeSinceNow()
//        repostLabel.attributedText = viewModel.repostsAttributedString
        likesLabel.attributedText = viewModel.likesAttributedString
        commentsLabel.attributedText = viewModel.commentsAttributedString
        
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        likeButton.tintColor = viewModel.likeButtonTintColor
        
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
    
    func configureMentionHandler() {
        postTextLabel.handleMentionTap { username in
            self.delegate?.handleFetchUser(withUsername: username)
        }
    }

}
