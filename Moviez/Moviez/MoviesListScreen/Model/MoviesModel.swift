//
//  MoviesModel.swift
//  Moviez
//
//  Created by Ibram on 10/2/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import Foundation

struct MoviesModel: Codable {
    var movies = [MovieDetails]()
}

struct MovieDetails: Codable {
    var title:  String?
    var year:   Int = 0
    var cast:   [String]?
    var genres: [String]?
    var rating: Int = 0
}

struct SortedMovies {
    var year: Int = 0
    var movies: [MovieDetails] = [MovieDetails]()
}

struct Response<T> {
    var data: T?
    var error: String?
}
