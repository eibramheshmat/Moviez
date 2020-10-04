//
//  MovieDetailsViewModel.swift
//  Moviez
//
//  Created by Ibram on 10/4/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import Foundation

class MovieDetailsViewModel: BaseViewModel{
    
    var movie = MovieDetails()
    var getImageObserver: (()->())?
    var getErrorObserver: ((_ error: String)->())?
    var movieDetailsRepository = MovieDetailsRepository()
    var movieImages = MovieImagesModel(){
        didSet{
            getImageObserver?()
            loading?(false)
        }
    }
    
    func getImageFromFlickr(){
        guard let movieName = movie.title else { return }
        setRepositoryObserver()
        loading?(true)
        movieDetailsRepository.getDataFromAPI(movieName: movieName)
    }
    
    private func setRepositoryObserver(){
        movieDetailsRepository.getImageFromAPIObserver = { [weak self] (movieImagesData) in
            self?.movieImages = movieImagesData
        }
    }
}
