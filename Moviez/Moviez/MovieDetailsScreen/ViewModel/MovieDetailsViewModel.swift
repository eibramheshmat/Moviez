//
//  MovieDetailsViewModel.swift
//  Moviez
//
//  Created by Ibram on 10/4/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import Foundation

class MovieDetailsViewModel: BaseViewModel{
    
    var movie: MovieDetails
    var getImageObserver: (()->())?
    var movieDetailsRepository = MovieDetailsRepository()
    var movieImages = MovieImagesModel(){
        didSet{
            getImageObserver?()
            loading?(false)
        }
    }
    /// dependency injection
    init(movie: MovieDetails) {
        self.movie = movie
    }
    
    func getImageFromFlickr(){
        guard let movieName = movie.title else { return }
        setRepositoryObserver()
        loading?(true)
        movieDetailsRepository.getDataFromAPI(movieName: movieName)
    }
    
    private func setRepositoryObserver(){
        movieDetailsRepository.getImageFromAPIObserver = { [weak self] (response) in
            if let data = response.data{
                self?.movieImages = data
            }
            if let error = response.error{
                self?.getErrorObserver?(error)
                self?.loading?(false)
            }
        }
    }
}
