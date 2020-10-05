//
//  MovieDetailsRepository.swift
//  Moviez
//
//  Created by Ibram on 10/4/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import Foundation

class MovieDetailsRepository {
    var getImageFromAPIObserver: ((_ movieImagesData: Response<MovieImagesModel>)->())?

    func getDataFromAPI(movieName: String){
        Network.shared.request(router: Router.getMovieImages(movieName: movieName), model: MovieImagesModel()) { (result) in
            switch result{
            case .success(let responseData):
                self.getImageFromAPIObserver?(Response(data: responseData, error: nil))
            case .failure(let error):
                self.getImageFromAPIObserver?(Response(data: nil, error: error.errorDescription))
            }
        }
    }
}
