//
//  MovieDetailsViewController.swift
//  Moviez
//
//  Created by Ibram on 10/2/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import UIKit
import Cosmos

class MovieDetailsViewController: BaseViewController {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieRating: CosmosView!
    @IBOutlet weak var movieCast: UILabel!
    @IBOutlet weak var movieGeners: UILabel!
    @IBOutlet weak var movieImagesCollectionView: UICollectionView!
    
    var movie = MovieDetails()
    var viewModel = MovieDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Loading.shared.show()
        setViewModelObservers()
        if let movieName = movie.title{
            viewModel.getImageFromFlickr(movieName: movieName)
        }
        setupUI()
        registerCells()
        fillData()
    }
    
    private func setViewModelObservers(){
        viewModel.getImageObserver = { [weak self] in
            DispatchQueue.main.async {
                Loading.shared.hide()
                self?.movieImagesCollectionView.reloadData()
            }
            
        }
        
        viewModel.getErrorObserver = { [weak self] (error) in
            self?.showAlert()
        }
    }
    
    private func registerCells(){
        movieImagesCollectionView.register(UINib(nibName: "MovieImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieImagesCollectionViewCell")
    }
    
    private func fillData(){
        movieTitle.text = movie.title
        movieYear.text = "Year: \(movie.year)"
        movieRating.rating = Double(movie.rating)
        movieRating.text = "\(movieRating.rating)"
        movieCast.text = movie.cast?.joined(separator:", ")
        movieGeners.text = movie.genres?.joined(separator:", ")
    }
    
    private func setupUI(){
    }
    
}

//MARK:-UICollectioView DataSource
extension MovieDetailsViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movieImages.photos.photo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieImagesCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieImagesCollectionViewCell", for: indexPath) as! MovieImagesCollectionViewCell
        cell.setImage(imageObject: viewModel.movieImages.photos.photo[indexPath.row])
        return cell
    }
    
    
}

//MARK:-UICollectioView Delegate
extension MovieDetailsViewController: UICollectionViewDelegate{
    
}
