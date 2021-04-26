//
//  Constraints.swift
//  new app 3
//
//  Created by William Hinson on 4/21/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Firebase



let DB_REF = Database.database().reference()
let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")
let STORAGE_HEADER_IMAGES = STORAGE_REF.child("header_images")

let STORAGE_MESSAGE_IMAGES_REF = STORAGE_REF.child("message_images")
let STORAGE_MESSAGE_VIDEO_REF = STORAGE_REF.child("messages_videos")

let MESSAGES_REF = DB_REF.child("messages")
let USER_MESSAGES_REF = DB_REF.child("user-messages")
let UNREAD_MESSAGES_REF = DB_REF.child("unread-Messages-Count")
let UNREAD_NOTIFICATIONS_REF = DB_REF.child("unread-Notifications-Count")

let USER_MESSAGE_NOTIFICATIONS_REF = DB_REF.child("user-message-notifications")

let USER_FOLLOWER_REF = DB_REF.child("user-followers")
let USER_FOLLOWING_REF = DB_REF.child("user-following")

let POSTS_REF = DB_REF.child("posts")
let UPLOADS_REF = DB_REF.child("audio")
let GIGS_REF = DB_REF.child("gigs")

let USER_LIKES_REF = DB_REF.child("user-likes")
let POST_LIKES_REF = DB_REF.child("post-likes")
let USER_SONG_LIKES = DB_REF.child("user-audio-likes")
let AUDIO_LIKES = DB_REF.child("audio-likes")
let USER_POSTS = DB_REF.child("user-posts")
let USER_UPLOADS = DB_REF.child("user-uploads")
let SINGLE_UPLOADS = DB_REF.child("user-singles")
let ALBUM_UPLOADS = DB_REF.child("user-albums")
let NEW_ALBUM = DB_REF.child("albums")
let NEW_SINGLE = DB_REF.child("singles")
let USER_APPLICATION_REF = DB_REF.child("user-applications")
let GIG_APPLICATIONS_REF = DB_REF.child("gig-applications")

let REF_USERS = DB_REF.child("users")

let REF_POST_COMMENTS = DB_REF.child("post-comments")
let REPOSTED_POST = DB_REF.child("reposted-post")
let REF_NOTIFICATIONS = DB_REF.child("notifications")

let HASHTAGPOSTREF = DB_REF.child("hashtag-post")

let REF_USER_USERNAMES = DB_REF.child("user-usernames")

