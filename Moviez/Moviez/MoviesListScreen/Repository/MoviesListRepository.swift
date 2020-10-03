//
//  MoviesListRepository.swift
//  Moviez
//
//  Created by Ibram on 10/4/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import Foundation

class MoviesListRepository {
    
    var didGetMoviesData: ((_ sortedMovies: [SortedMovies])->())?
    var getError: ((_ error: String)->())?
    var moviesCategoryList: [SortedMovies] = [SortedMovies]()
    
    func getLocalData() {
        guard let moviesData = readLocalFile(forName: "movies") else { return }
        parse(jsonData: moviesData)
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
            getError?(error.localizedDescription)
        }
        
        return nil
    }
    
    private func parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode(MoviesModel.self,from: jsonData)
            sortMovies(movies: decodedData)
        } catch {
            print("decode error")
            getError?("decode error")
        }
    }
    
    private func sortMovies(movies: MoviesModel){
        var yearsSet: Set = Set<Int>()
        movies.movies.forEach({ (movie) in
            yearsSet.insert(movie.year)
        })
        yearsSet.sorted(by: >).forEach({ (year) in
            moviesCategoryList.append(SortedMovies(year: year, movies: movies.movies.filter({$0.year == year})))
        })
        didGetMoviesData?(moviesCategoryList)
    }
}
