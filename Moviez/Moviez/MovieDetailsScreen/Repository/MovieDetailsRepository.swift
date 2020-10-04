//
//  MovieDetailsRepository.swift
//  Moviez
//
//  Created by Ibram on 10/4/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import Foundation

class MovieDetailsRepository {
    var getImageFromAPIObserver: ((_ movieImagesData: MovieImagesModel)->())?
    var getErrorObserver: ((_ error: String)->())?
    
    func getDataFromAPI(movieName: String){
        Network.shared.makeHttpRequest(model: MovieImagesModel(), method: .get, APIName: "", parameters: ["api_key":Constants.app_key,"method":"flickr.photos.search","format":"json","nojsoncallback":"1","text":movieName]) { (result) in
            switch result{
            case .success(let response):
                self.getImageFromAPIObserver?(response)
            case .failure(let error):
                self.getErrorObserver?(error.errorDescription ?? "Network Error")
            }
        }
    }
    
}
