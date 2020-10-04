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
    
    var viewModel = MovieDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewModelObservers()
        registerCells()
        viewModel.getImageFromFlickr()
        fillData()
        setupUI()
    }
    
    private func setViewModelObservers(){
        
        viewModel.loading = {(isLoad) in
            DispatchQueue.main.async {
                if isLoad{
                    Loading.shared.show()
                }else{
                    Loading.shared.hide()
                }
            }
        }
        
        viewModel.getImageObserver = { [weak self] in
            DispatchQueue.main.async {
                
                self?.movieImagesCollectionView.reloadData()
            }
        }
        
        viewModel.getErrorObserver = { [weak self] (error) in
            self?.showAlert(message: "Error about get remote data")
        }
    }
    
    private func setupUI(){
        movieImagesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
    
    private func registerCells(){
        movieImagesCollectionView.register(UINib(nibName: "MovieImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieImagesCollectionViewCell")
    }
    
    private func fillData(){
        let movie = viewModel.movie
        movieTitle.text = movie.title
        movieYear.text = "Year: \(movie.year)"
        movieRating.rating = Double(movie.rating)
        movieRating.text = "\(movieRating.rating)"
        movieCast.text = movie.cast?.joined(separator:", ")
        movieGeners.text = movie.genres?.joined(separator:", ")
    }
}

//MARK:-UICollectioView DataSource
extension MovieDetailsViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.movieImages.photos.photo.isEmpty{
            collectionView.setEmptyView(title: "Sorry! No Images Found", message: "Please try it later or try another movie", image: #imageLiteral(resourceName: "nodata"))
        }else{
            collectionView.restore()
        }
        return viewModel.movieImages.photos.photo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieImagesCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieImagesCollectionViewCell", for: indexPath) as! MovieImagesCollectionViewCell
        cell.setImage(imageObject: viewModel.movieImages.photos.photo[indexPath.row])
        return cell
    }
}

//MARK:-UICollectioView DelegateFlowLayout
extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:  collectionView.bounds.width - 48, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
