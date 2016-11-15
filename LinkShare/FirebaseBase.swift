//
//  FirebaseBase.swift
//  LinkShare
//
//  Created by Aaron on 11/15/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import Foundation
import Firebase


class FirebaseBase {
    private let database: FIRDatabase
    init() {
        self.database = FIRDatabase.database()
    }
}
