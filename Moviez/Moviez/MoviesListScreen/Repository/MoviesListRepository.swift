//
//  MoviesListRepository.swift
//  Moviez
//
//  Created by Ibram on 10/4/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import Foundation

class MoviesListRepository {
    
    var getLocalDataObserver: ((_ response: Response<MoviesModel>)->())?
    
    func getLocalData() {
        guard let moviesData = readLocalFile(forName: "movies") else { return }
        guard let moviesParsedData = parse(jsonData: moviesData) else { return }
        getLocalDataObserver?(Response(data: moviesParsedData, error: nil))
    }
    
    /* get data from file method */
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            getLocalDataObserver?(Response(data: nil, error: error.localizedDescription))
        }
        return nil
    }
    
    /* parse data method */
    private func parse(jsonData: Data) ->  MoviesModel?{
        do {
            let decodedData = try JSONDecoder().decode(MoviesModel.self,from: jsonData)
            return decodedData
        } catch {
            getLocalDataObserver?(Response(data: nil, error: "decode error"))
        }
        return nil
    }
    
    
}
