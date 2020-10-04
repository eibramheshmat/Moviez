//
//  MoviesListViewController.swift
//  Moviez
//
//  Created by Ibram on 10/2/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import UIKit

class MoviesListViewController: BaseViewController {
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    private var viewModel = MoviesListViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewModelObservers()
        viewModel.getMoviesList()
        setupUI()
        setupSearchBar()
    }
    
    private func setViewModelObservers(){
        viewModel.getMoviesListObserver = { [weak self] in
            self?.moviesTableView.reloadData()
        }
        
        viewModel.getError = { [weak self] (error) in
            self?.showAlert(message: "Error about get local data")
        }
    }
    
    private func setupUI(){
        moviesTableView.tableFooterView = UIView()
    }
    
    private func setupSearchBar(){
        
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .black
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.searchTextField.backgroundColor = UIColor(red: 228/255, green: 229/255, blue: 224/255, alpha: 1.0)
        searchController.searchBar.searchTextField.tintColor = .black
        searchController.searchBar.placeholder = "Search about movie ..."
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goDetailsFromMain":
            if let viewControllerDestination = segue.destination as? MovieDetailsViewController, let movie = sender as? MovieDetails {
                viewControllerDestination.viewModel.movie = movie
            }
        default:
            break
        }
    }
}

//MARK:- TableViewDataSource of Movies
extension MoviesListViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.customMoviesCategoryList.isEmpty{
            tableView.setEmptyView(title: "Sorry! No Movies Found", message: "Please enter another movie name", image: #imageLiteral(resourceName: "nodata"))
        }else{
            tableView.restore()
        }
        return viewModel.customMoviesCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.customMoviesCategoryList[section].movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "movieCell")
        cell.textLabel?.text = viewModel.customMoviesCategoryList[indexPath.section].movies[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

//MARK:- TableViewDelegate of Movies
extension MoviesListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(viewModel.customMoviesCategoryList[section].year)"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goDetailsFromMain", sender: viewModel.customMoviesCategoryList[indexPath.section].movies[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

////MARK:- Actions
extension MoviesListViewController{
    
    @IBAction func didStartSearch(_ sender: UIBarButtonItem) {
        if (!viewModel.searchText.trimmingCharacters(in: .whitespaces).isEmpty){
            searchController.searchBar.text = viewModel.searchText
        }
        self.present(searchController,animated: true, completion: nil)
    }
}

extension MoviesListViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText.trimmingCharacters(in: .whitespaces).isEmpty ? "" : searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.dismiss(animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchText = ""
    }
}
