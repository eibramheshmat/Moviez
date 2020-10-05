//
//  MoviesListViewModel.swift
//  Moviez
//
//  Created by Ibram on 10/3/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import Foundation

class MoviesListViewModel: BaseViewModel{
    
    var searchText: String = ""{
        didSet{
            filterMovies() /// when search txt didset filter method called for live search
        }
    }
    var getMoviesListObserver: (()->())?
    var moviesListRepository = MoviesListRepository()
    var customMoviesCategoryList: [SortedMovies] = [SortedMovies]()
    private var moviesCategoryList: [SortedMovies] = [SortedMovies]()
    
    func getMoviesList(){
        setRepositoryObservers()
        moviesListRepository.getLocalData()
    }
    
    private func setRepositoryObservers(){
        moviesListRepository.getLocalDataObserver = { [weak self] (response) in
            if let data = response.data{
                self?.sortMovies(movies: data)
                self?.getMoviesListObserver?()
            }
            if let error = response.error{
                self?.getErrorObserver?(error)
            }
        }
    }
    
    /* this method sort movies from db to year and movies style and use set of years to unrepated values */
    private func sortMovies(movies: MoviesModel){
        var yearsSet: Set = Set<Int>()
        movies.movies.forEach({ (movie) in
            yearsSet.insert(movie.year)
        })
        yearsSet.sorted(by: >).forEach({ (year) in
            moviesCategoryList.append(SortedMovies(year: year, movies: movies.movies.filter({$0.year == year})))
        })
        self.customMoviesCategoryList = moviesCategoryList
    }
    
    private func filterMovies(){
        guard searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            customMoviesCategoryList.removeAll()
            moviesCategoryList.forEach({(category) in
                let movies = category.movies.filter({($0.title?.lowercased().contains(searchText.lowercased())) ?? false}).sorted(by: {$0.rating > $1.rating})
                /// for each category (Year) filter movie which contain my search after that sorted it based on rating.
                guard movies.isEmpty else {
                    customMoviesCategoryList.append(SortedMovies(year: category.year, movies: movies))
                    return
                }
            })
            getMoviesListObserver?()
            return
        }
        customMoviesCategoryList = moviesCategoryList
        getMoviesListObserver?()
    }
}
