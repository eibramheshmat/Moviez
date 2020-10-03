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
    var didGetMovies: (()->())?
    var getError: ((_ error: String)->())?
    var moviesListRepository = MoviesListRepository()
    var customMoviesCategoryList: [SortedMovies] = [SortedMovies]()
    
    func didLoad(){
        setObservers()
        moviesListRepository.getLocalData()
    }
    
    private func setObservers(){
        moviesListRepository.didGetMoviesData = { [weak self] (sortedMovies) in
            self?.customMoviesCategoryList = sortedMovies
            self?.didGetMovies?()
        }
    }
    
    private func filterMovies(){
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            customMoviesCategoryList = moviesListRepository.moviesCategoryList
            didGetMovies?()
            return
        }
        customMoviesCategoryList.removeAll()
        moviesListRepository.moviesCategoryList.forEach({(category) in
            let movies = category.movies.filter({($0.title?.lowercased().contains(searchText.lowercased())) ?? false}).sorted(by: {$0.rating > $1.rating})
            guard !movies.isEmpty else { return }
            customMoviesCategoryList.append(SortedMovies(year: category.year, movies: movies))
        })
        didGetMovies?()
    }
}
