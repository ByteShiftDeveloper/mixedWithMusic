//
//  UpdatePostCollectionCell.swift
//  new app 3
//
//  Created by William Hinson on 5/16/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import ActiveLabel
import AVFoundation
import SkeletonView
import Kingfisher
import LinkPresentation


protocol PostDelegate: class {
    func handleProfileImageTapped(_ cell: UpdatedPostCollectionCell)
    func handleCommentTap(_ cell: UpdatedPostCollectionCell)
    func handleLikeTap(_ cell: UpdatedPostCollectionCell)
    func handleFetchUser(withUsername username: String)
    func handleNameTap(_ cell: UpdatedPostCollectionCell)
    func handleShareTap(_ cell: UpdatedPostCollectionCell)
    func handleImageZoom(_ cell: UpdatedPostCollectionCell)
    func handleRepostTapped(_ cell: UpdatedPostCollectionCell)
    func handlePlayTapped(_ cell: UpdatedPostCollectionCell)
    func handleActionSheet(_ cell: UpdatedPostCollectionCell)
    func handleSongTap(_ cell: UpdatedPostCollectionCell)
}

class UpdatedPostCollectionCell: UICollectionViewCell {
    
    var post: Post? {
        didSet { configureUI()
            
        }
    }
    weak var delegate: PostDelegate?
    var feedController: FeedController?
    var songPost: SongPost?
    var profileController: ProfileCollectionViewController?
    
    var stack = UIStackView()
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 50, height: 50)
        iv.layer.cornerRadius = 50 / 2
        iv.backgroundColor = .lightGray
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Peter Parker"
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleNameLabelTap))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let verifiedMark: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "checkmark.seal.fill")
        iv.tintColor = UIColor(named: "BlackColor")
        iv.setDimensions(width: 20, height: 18)
        return iv
    }()
    
    private let ADMPLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "Producer"
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
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = UIColor(named: "Black")
        label.mentionColor = Colors.activelabelblue
        label.hashtagColor = Colors.activelabelblue
        return label
    }()
    
     let postPicture: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setHeight(height: 317)
        iv.backgroundColor = .lightGray
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleImageZoom(tapGesture:)))
        iv.addGestureRecognizer(tap)
//        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 5
        return iv
    }()
    
    let linkView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 15
        return view
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
        label.text = "This is the song name"
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
//        iv.translatesAutoresizingMaskIntoConstraints = false
       iv.isUserInteractionEnabled = true
       iv.layer.cornerRadius = 10
       iv.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]


       return iv
   }()
    
    private let postVideo: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        //        iv.setHeight(height: 317)
        iv.backgroundColor = .lightGray
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleImageZoom(tapGesture:)))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 5
        
        return iv
    }()
    
    
    let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play 5.png"), for: .normal)
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
        button.addTarget(self, action: #selector(handleActionSheet), for: .touchUpInside)
        return button
    }()
    
    private lazy var statsView: UIView = {
        let view = UIView()
        
        let divider1 = UIView()
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        divider1.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 8, paddingRight: 8, height: 1.0)
        
        let stack = UIStackView(arrangedSubviews: [likesLabel, repostLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left: view.leftAnchor, paddingLeft: 16)
        
        let divider2 = UIView()
        divider2.backgroundColor = .systemGroupedBackground
        view.addSubview(divider2)
        divider2.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingRight: 8, height: 1.0)
        
        return view
    }()
    
    
    
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.text = " likes"
        return label
    }()
    
    lazy var likesCount: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.text = "0"
        return label
    }()

    
    private lazy var commentsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.text = " comments"
        return label
    }()
    
    private lazy var commentsCount: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.text = "0"
        return label
    }()
    
    private lazy var repostLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = .lightGray
        label.text = "1"
        return label
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.tintColor = UIColor(named: "BlackColor")
        button.setTitle("Comments", for: .normal)
        button.setDimensions(width: 22, height: 20)
        button.addTarget(self, action: #selector(handleCommentTap), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var repostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.2.squarepath"), for: .normal)
        button.tintColor = .black
        button.setDimensions(width: 22, height: 16)
        button.addTarget(self, action: #selector(handleRepostTap), for: .touchUpInside)
        return button
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//        button.pulsate()
        button.tintColor = .black
        button.setTitle("Like", for: .normal)
        button.setDimensions(width: 22, height: 20)
//        button.addTarget(self, action: #selector(handleLikeTap), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        button.tintColor = UIColor(named: "BlackColor")
        button.setDimensions(width: 24, height: 20)
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.isSkeletonable = true
        
        configureMentionHandler()
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(handleImageZoom))
        imageTap.numberOfTouchesRequired = 1
        postPicture.isUserInteractionEnabled = true
        postPicture.addGestureRecognizer(imageTap)
        
        
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(handleNameLabelTap))
        nameTap.numberOfTouchesRequired = 1
        fullnameLabel.isUserInteractionEnabled = true
        fullnameLabel.addGestureRecognizer(nameTap)
        
        let stack2 = UIStackView(arrangedSubviews: [fullnameLabel, verifiedMark, ADMPLabel])
        stack2.spacing = 8
        stack2.distribution = .equalSpacing
        self.contentView.addSubview(stack2)
        stack2.anchor(top: topAnchor, paddingTop: 0)
        
        let labelStack = UIStackView(arrangedSubviews: [stack2, timestampLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -8
        
        stack = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        stack.spacing = 12
        
        self.contentView.addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        
        self.contentView.addSubview(postTextLabel)
        postTextLabel.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16)
        
        self.contentView.addSubview(postPicture)
        postPicture.anchor(top: postTextLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 16, paddingRight: 16, width: frame.width, height: 317)
        
        self.contentView.addSubview(linkView)
        linkView.anchor(top: postTextLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 16, paddingRight: 16, width: frame.width, height: 317)
        
        self.contentView.addSubview(songView)
        songView.anchor(top: postTextLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 16, paddingRight: 16, width: frame.width / 2, height: 100)
        let songTap = UITapGestureRecognizer(target: self, action: #selector(handleSongTap))
        songTap.numberOfTouchesRequired = 1
        songView.isUserInteractionEnabled = true
        songView.addGestureRecognizer(songTap)
        
        
        
        self.contentView.addSubview(postVideo)
        postVideo.anchor(top: postTextLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 16, paddingRight: 16, width: frame.width, height: 317)
        
        postVideo.addSubview(playButton)
        playButton.centerX(inView: postVideo)
        playButton.centerY(inView: postVideo)
        playButton.anchor(width: 50, height: 50)
        playButton.setGradientBackground(colorOne: .black, colorTwo: .black)
        playButton.addTarget(self, action: #selector(handlePlayTapped), for: .touchUpInside)
        
        songView.addSubview(coverImage)
        coverImage.anchor(top: songView.topAnchor, left: songView.leftAnchor, paddingLeft: 0, width: 100, height: 100)
        
        
        songView.addSubview(infoView)
        infoView.anchor(left: coverImage.rightAnchor, right: songView.rightAnchor, height: 100)
        
        infoView.addSubview(songInfoLabel)
        songInfoLabel.centerX(inView: infoView)
        songInfoLabel.anchor(top: infoView.topAnchor, paddingTop: 32)
        
        infoView.addSubview(artistLabel)
        artistLabel.centerX(inView: infoView)
        artistLabel.anchor(top: songInfoLabel.bottomAnchor, paddingTop: 6)
        
        
        coverImage.addSubview(songPlayButton)
        songPlayButton.centerX(inView: coverImage)
        songPlayButton.centerY(inView: coverImage)
        songPlayButton.anchor(width: 30, height: 30)
        songPlayButton.addTarget(self, action: #selector(handleSongTap), for: .touchUpInside)
        
        
        //            addSubview(repostView)
        //            repostView.anchor(top: postPicture.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 20, paddingRight: 20)
        
                    addSubview(optionsButton)
                    optionsButton.centerY(inView: stack)
                    optionsButton.anchor(right: rightAnchor, paddingRight: 16)
        //
        //            addSubview(statsView)
        //            statsView.anchor(top: postPicture.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, height: 40)
        
        
        let buttonStack = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        buttonStack.spacing = 100
        
        likeButton.addTarget(self, action: #selector(handleLikeTap), for: .touchUpInside)
        
        self.contentView.addSubview(buttonStack)
        buttonStack.centerX(inView: self)
        buttonStack.anchor(bottom: bottomAnchor, paddingBottom: 8)
        
        let divider = UIView()
        divider.backgroundColor = .tertiarySystemGroupedBackground
        self.contentView.addSubview(divider)
        divider.anchor(left: leftAnchor, bottom: buttonStack.topAnchor,
                       right: rightAnchor, paddingLeft: 16, paddingBottom: 8, paddingRight: 16, height: 1)
        
//        self.contentView.addSubview(likesCount)
//        //            likesLabel.anchor(left: likeButton.rightAnchor, bottom: bottomAnchor , paddingLeft: 1, paddingBottom: 11)
//        likesCount.anchor(left: leftAnchor, bottom: divider.topAnchor, paddingLeft: 16, paddingBottom: 2)
        
        let likesStack = UIStackView(arrangedSubviews: [likesCount, likesLabel])
        likesStack.spacing = 0
        
        self.contentView.addSubview(likesStack)
        likesStack.anchor(left: leftAnchor, bottom: divider.topAnchor, paddingLeft: 16, paddingBottom: 2)
        
        
        let commentsStack = UIStackView(arrangedSubviews: [commentsCount, commentsLabel])
        commentsStack.spacing = 0
        
        self.contentView.addSubview(commentsStack)
        commentsStack.anchor(bottom: divider.topAnchor, right: rightAnchor, paddingBottom: 2, paddingRight: 16)

        
        
//        self.contentView.addSubview(commentsLabel)
//        //            commentsLabel.anchor(left: commentButton.rightAnchor, bottom: bottomAnchor , paddingLeft: 1, paddingBottom: 11)
//
////        commentsLabel.anchor(top: postPicture.bottomAnchor, right: rightAnchor, paddingTop: 2, paddingRight: 16)
//        commentsLabel.anchor(bottom: divider.topAnchor, right: rightAnchor, paddingBottom: 2, paddingRight: 16)
        //
        //
        //            addSubview(repostLabel)
        //            repostLabel.anchor(left: repostButton.rightAnchor, bottom: bottomAnchor , paddingLeft: 1, paddingBottom: 11)
        
//        labelStack.isSkeletonable = true
//        labelStack.showAnimatedGradientSkeleton()
//        
////        timestampLabel.isSkeletonable = true
////        timestampLabel.showAnimatedGradientSkeleton()
//
//        stack2.isSkeletonable = true
//        stack2.showAnimatedGradientSkeleton()
//
//        profileImageView.isSkeletonable = true
//        profileImageView.showAnimatedGradientSkeleton()
//
//        postTextLabel.isSkeletonable = true
//        postTextLabel.showAnimatedGradientSkeleton()
//
//        postPicture.isSkeletonable = true
//        postPicture.showAnimatedGradientSkeleton()
//
//        coverImage.isSkeletonable = true
//        coverImage.showAnimatedGradientSkeleton()
//
//        likesLabel.isSkeletonable = true
//        likesLabel.showAnimatedGradientSkeleton()
//
//        commentsLabel.isSkeletonable = true
//        commentsLabel.showAnimatedGradientSkeleton()
//
//        postVideo.isSkeletonable = true
//        postVideo.showAnimatedGradientSkeleton()
//
//        optionsButton.isSkeletonable = true
//        optionsButton.showAnimatedGradientSkeleton()
//
//        buttonStack.isSkeletonable = true
//        buttonStack.showAnimatedGradientSkeleton()
//
//
////
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            labelStack.hideSkeleton()
//            stack2.hideSkeleton()
//            self.profileImageView.hideSkeleton()
//            self.postTextLabel.hideSkeleton()
//            self.postPicture.hideSkeleton()
//            self.coverImage.hideSkeleton()
//            self.likesLabel.hideSkeleton()
//            self.commentsLabel.hideSkeleton()
//            self.postVideo.hideSkeleton()
//            self.optionsButton.hideSkeleton()
//            buttonStack.hideSkeleton()
//        }



        
        
     
        
        let underlineView = UIView()
        underlineView.backgroundColor = .tertiarySystemGroupedBackground
        self.contentView.addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor,
                             right: rightAnchor, height: 1)
        
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
    
    @objc func handlePlayTapped() {
        delegate?.handlePlayTapped(self)
    }
    
    @objc func handleCommentTap() {
        delegate?.handleCommentTap(self)
    }
    
    @objc func handleLikeTap() {
        delegate?.handleLikeTap(self)
    }
    
    @objc func handleShowLikes() {
        
    }
    
    func configureLikeButton() {
    }
    
    @objc func handleProfileImageTapped() {
        delegate?.handleProfileImageTapped(self)
    }
    
    @objc func handleNameLabelTap() {
        delegate?.handleNameTap(self)
    }
    
    @objc func handleShareTapped() {
        delegate?.handleShareTap(self)
    }
    
    @objc func handleActionSheet() {
        delegate?.handleActionSheet(self)
    }
    
    @objc func handleRepostTap() {
        delegate?.handleRepostTapped(self)
    }
    
    @objc func handleImageZoom(tapGesture: UITapGestureRecognizer) {
        delegate?.handleImageZoom(self)
        let imageView = tapGesture.view as? UIImageView
        self.feedController?.performZoomInForStartingImageView(startingImageView: imageView!)
    }
    
    @objc func handleSongTap() {
        delegate?.handleSongTap(self)
        feedController?.song = songPost
    }
    
    public func fliplikedState() {
        post?.didLike = !post!.didLike
    }
    
    private var linkPreview : LPLinkView = LPLinkView(metadata: LPLinkMetadata())

    
    private func addLinkViewToContainer() {
        self.linkPreview.frame = self.linkView.bounds
        self.linkView.addSubview(linkPreview)
        self.linkView.sizeToFit()
    }
    
    func previewURL(string: String) {
        guard let url = URL(string: string) else { return }

        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url) { (metaData, error) in
            guard let data = metaData, error == nil else {
                return
            }

            DispatchQueue.main.async {
                self.linkPreview.metadata = data
//                self.linkPreview.anchor(top: self.postTextLabel.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 5, paddingLeft: 16, paddingRight: 16, height : 317)
            }
        }
    }
    
//    private let unlikedScale: CGFloat = 0.7
//    private let likedScale: CGFloat = 1.3
//
//    private func animate() {
//        UIButton.animate(withDuration: 0.1, animations: {
//            let newImage = self.post!.didLike ? UIImage(named: "heart") : UIImage(named: "heart_unfilled")
//            let newScale = self.post!.didLike ? self.likedScale : self.unlikedScale
//            self.transform = self.transform.scaledBy(x: newScale, y: newScale)
//            self.likeButton.setImage(newImage, for: .normal)
//        }, completion: { _ in
//          // Step 2
//          UIButton.animate(withDuration: 0.1, animations: {
//            self.transform = CGAffineTransform.identity
//          })
//        })
//      }
    
    func configureUI() {
        addLinkViewToContainer()
        guard let post = post else { return }
        let viewModel = PostViewModel(post: post)
        let profileurl = URL(string: (post.user.profileImageURL)!)
        profileImageView.kf.setImage(with: profileurl)
        postTextLabel.text = post.text
        fullnameLabel.text = post.user.fullname
        ADMPLabel.text = post.user.artistBand
        print("text: \(post.text)\n picture: \(post.picture)\n \(post.postID)")
        if post.picture != "" {
            let postimageurl = URL(string: post.picture)
            postPicture.kf.setImage(with: postimageurl, placeholder: nil, options: nil, completionHandler: { (result) in
                let img = try! result.get().image.imageWithoutBaseline()
                print(img)
            })
            for constraint in postPicture.constraints {
                if constraint.firstAnchor == postPicture.heightAnchor {
                    constraint.isActive = false
                    
                }
                
            }
            
            postPicture.setHeight(height: 317)
            
        }
        else {
            for constraint in postPicture.constraints {
                if constraint.firstAnchor == postPicture.heightAnchor {
                    constraint.isActive = false
                    
                }
                
            }
            postPicture.setHeight(height: 0)
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
        
        
        if post.songID != "" {

            
            Service.shared.fetchUpload(withSongID: post.songID) { (song) in
                let coverimageurl = URL(string: song.coverImage.absoluteString)
                self.coverImage.kf.setImage(with: coverimageurl, placeholder: nil, options: nil) { (result) in
                    let image =  try! result.get().image.imageWithoutBaseline()
                    
                }
                self.songInfoLabel.text = song.title
                self.artistLabel.text = song.author.fullname
            }
            
            
   
            for constraint in coverImage.constraints {
                if constraint.firstAnchor == coverImage.heightAnchor {
                    constraint.isActive = false
                    
                }
                
            }
            
            songView.setHeight(height: 100)
            coverImage.setHeight(height: 100)
            infoView.setHeight(height: 100)
            artistLabel.isHidden = false
            songInfoLabel.isHidden = false
            
        }
        else {
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
        
//        self.reloadInputViews()
        
        if post.video != "" {
            guard let videoURL = URL(string: post.video) else { return }
            
            thumbnailImageForVideoURL2(fileURL: videoURL) { image in
                self.postVideo.image = image
            }
//
//            if let thumbnail = self.thumbnailImageForVideoURL(fileURL: videoURL) {
//                self.postVideo.image = thumbnail
//            }
            
            for constraint in postVideo.constraints {
                if constraint.firstAnchor == postVideo.heightAnchor {
                    constraint.isActive = false
                    
                }
                
            }
            postVideo.setHeight(height: 317)
        } else {
            
            for constraint in postVideo.constraints {
                if constraint.firstAnchor == postVideo.heightAnchor {
                    constraint.isActive = false
                    
                }
                
            }

            postVideo.setHeight(height: 0)
        }
        
        
        if post.text == "" {
            postTextLabel.setHeight(height: 0)
        }
        else {
            //postTextLabel.translatesAutoresizingMaskIntoConstraints = true
            postTextLabel.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16)
        }
        

        
        //        if post.repostedPost != nil  {
        //            repostView.isHidden = false
        //        } else {
        //            repostView.isHidden = true
        //        }
        timestampLabel.text = post.createdAt.calenderTimeSinceNow()
//        if post.didLike == false {
//            likeButton.tintColor = UIColor(named: "BlackColor")
//            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
//        } else if post.didLike == true {
//            likeButton.tintColor = UIColor(named: "HeartColor")
//            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//        }
        
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        
        guard let likes = post.likes else { return }
        if likes != 0 {
            likesCount.text = "\(likes)"
        } else {
            likesCount.text = "0"
        }
        
        guard let comments = post.comments else { return }
        if comments != 0 {
            commentsCount.text = "\(comments)"
        } else if comments == 1 {
            commentsCount.text = "\(comments)"
        } else {
            commentsCount.text = "0"
        }
        
        
        //            configureLikeButton()
        //            let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleShowLikes))
        //            likeTap.numberOfTouchesRequired = 1
        //            likeCountLabel.isUserInteractionEnabled = true
        //            likeCountLabel.addGestureRecognizer(likeTap)
    }
    
    private func thumbnailImageForVideoURL(fileURL: URL) -> UIImage? {
        DispatchQueue.global(qos: .background).async {
            
        }
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
    
    
    private func thumbnailImageForVideoURL2(fileURL: URL,completion: @escaping ((_ image: UIImage?)->Void)){
        
        
        DispatchQueue.global().async { //1
               let asset = AVAsset(url: fileURL) //2
               let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
               avAssetImageGenerator.appliesPreferredTrackTransform = true //4
               let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
               do {
                   let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                   let thumbImage = UIImage(cgImage: cgThumbImage) //7
                   DispatchQueue.main.async { //8
                       completion(thumbImage) //9
                   }
               } catch {
                   print(error.localizedDescription) //10
                   DispatchQueue.main.async {
                       completion(nil) //11
                   }
               }
           }
        
    }
    
    func configureMentionHandler() {
        postTextLabel.handleMentionTap { username in
            self.delegate?.handleFetchUser(withUsername: username)
        }
    }
}
