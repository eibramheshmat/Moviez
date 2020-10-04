//
//  MovieDetailsViewModel.swift
//  Moviez
//
//  Created by Ibram on 10/4/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import Foundation

class MovieDetailsViewModel {
    
    var getImageObserver: (()->())?
    var getErrorObserver: ((_ error: String)->())?
    var movieDetailsRepository = MovieDetailsRepository()
    var movieImages = MovieImagesModel()

    func getImageFromFlickr(movieName: String){
        setRepositoryObserver()
        movieDetailsRepository.getDataFromAPI(movieName: movieName)
    }

    private func setRepositoryObserver(){
        movieDetailsRepository.getImageFromAPIObserver = { [weak self] (movieImagesData) in
            self?.movieImages = movieImagesData
            self?.getImageObserver?()
        }
    }
}
