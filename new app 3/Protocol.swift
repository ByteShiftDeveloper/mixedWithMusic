//
//  Protocol.swift
//  new app 3
//
//  Created by William Hinson on 4/16/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Foundation


protocol UpdatedFeedCellDelegate {
    func handleCommentTapped(for cell: UpdatedPostCollectionCell)
    func handleLikeTapped(for cell: UpdatedPostCollectionCell)
    func handleConfigureLikeButton(for cell: UpdatedPostCollectionCell)
    func handleShowLikes(for cell: UpdatedPostCollectionCell)
    func handleProfileImageTap(for cell: UpdatedPostCollectionCell)
}



protocol MessageInputAccesoryViewDelegate {
    func handleUploadMessage(message: String)
    func handleSelectImage()
}

protocol MessageCellDelegate {
    func configureUserData(for cell: MessageCellTVC)
}

