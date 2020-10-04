//
//  MoviesListViewModel.swift
//  Moviez
//
//  Created by Ibram on 10/3/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import Foundation

class MoviesListViewModel {
    
    var searchText: String = ""{
        didSet{
            filterMovies()
        }
    }
    var getMoviesListObserver: (()->())?
    var getError: ((_ error: String)->())?
    var moviesListRepository = MoviesListRepository()
    var customMoviesCategoryList: [SortedMovies] = [SortedMovies]()
    private var moviesCategoryList: [SortedMovies] = [SortedMovies]()
    
    func getMoviesList(){
        setRepositoryObservers()
        moviesListRepository.getLocalData()
    }
    
    private func setRepositoryObservers(){
        moviesListRepository.getLocalDataObserver = { [weak self] (movieList) in
            self?.sortMovies(movies: movieList)
            self?.getMoviesListObserver?()
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
        self.customMoviesCategoryList = moviesCategoryList
    }
    
    private func filterMovies(){
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            customMoviesCategoryList = moviesCategoryList
            getMoviesListObserver?()
            return
        }
        customMoviesCategoryList.removeAll()
        moviesCategoryList.forEach({(category) in
            let movies = category.movies.filter({($0.title?.lowercased().contains(searchText.lowercased())) ?? false}).sorted(by: {$0.rating > $1.rating})
            guard !movies.isEmpty else { return }
            customMoviesCategoryList.append(SortedMovies(year: category.year, movies: movies))
        })
        getMoviesListObserver?()
    }
}
