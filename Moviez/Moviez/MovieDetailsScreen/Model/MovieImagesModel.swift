//
//  MovieImagesModel.swift
//  Moviez
//
//  Created by Ibram on 10/4/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import Foundation

struct MovieImagesModel: Codable {
    var photos = PhotosObject()
}

struct PhotosObject: Codable {
    var page: Int?
    var pages: Int?
    var perpage: Int?
    var total: String?
    var photo = [PhotoObject]()
}

struct PhotoObject: Codable {
    var id: String?
    var secret: String?
    var server: String?
}
