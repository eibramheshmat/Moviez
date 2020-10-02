//
//  MoviesModel.swift
//  Moviez
//
//  Created by Ibram on 10/2/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import Foundation

struct MoviesModel: Codable {
    var movies = [MoviesDetails]()
}

struct MoviesDetails: Codable {
    var title:  String?
    var year:   Int?
    var cast:   [String]?
    var genres: [String]?
    var rating: Int?
}
