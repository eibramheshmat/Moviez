//
//  MoviesListRepository.swift
//  Moviez
//
//  Created by Ibram on 10/4/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import Foundation

class MoviesListRepository {
    
    var getLocalDataObserver: ((_ sortedMovies: MoviesModel)->())?
    var getError: ((_ error: String)->())?
    
    func getLocalData() {
        guard let moviesData = readLocalFile(forName: "movies") else { return }
        guard let moviesParsedData = parse(jsonData: moviesData) else { return }
        getLocalDataObserver?(moviesParsedData)
        
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            getError?(error.localizedDescription)
        }
        return nil
    }
    
    private func parse(jsonData: Data) ->  MoviesModel?{
        do {
            let decodedData = try JSONDecoder().decode(MoviesModel.self,from: jsonData)
            return decodedData
        } catch {
            print("decode error")
            getError?("decode error")
        }
        return nil
    }
    
    
}
