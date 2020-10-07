//
//  RealmModel.swift
//  HapplyNews
//
//  Created by koneti santhosh kumar on 02/07/19.
//  Copyright © 2019 sp. All rights reserved.
//

import UIKit
import RealmSwift

class NewsListRealmDB :Object {
    @objc dynamic var author = ""
    @objc dynamic var title = ""
    @objc dynamic var urlToImage = ""
    @objc dynamic var url = ""
    
}


