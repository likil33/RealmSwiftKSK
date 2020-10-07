//
//  NewListStruct.swift
//  HapplyNews
//
//  Created by koneti santhosh kumar on 02/07/19.
//  Copyright © 2019 sp. All rights reserved.
//

import Foundation
import UIKit



struct NewsListStruct:Codable {
    var status :String?
    var articles: [NewsListArticlesStruct]?
}

struct NewsListArticlesStruct:Codable {
    let author, title,urlToImage,url:String?
    
}
