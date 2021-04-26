//
//  AuthService.swift
//  new app 3
//
//  Created by William Hinson on 3/17/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase



struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
}
