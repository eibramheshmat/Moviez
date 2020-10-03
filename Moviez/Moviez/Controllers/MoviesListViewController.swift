//
//  MoviesListViewController.swift
//  Moviez
//
//  Created by Ibram on 10/2/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import UIKit

class MoviesListViewController: UIViewController {
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    var moviesCategoryList: [SortedMovies] = [SortedMovies]()
    var customMoviesCategoryList: [SortedMovies] = [SortedMovies]()
    let searchController = UISearchController(searchResultsController: nil)
    
    var searchText: String = ""{
        didSet{
            filterMovies()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovies()
        setupUI()
        setupSearchBar()
    }
    
    private func getMovies(){
        guard let moviesData = readLocalFile(forName: "movies") else { return }
        parse(jsonData: moviesData)
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
    
    private func sortMovies(movies: MoviesModel){
        var yearsSet: Set = Set<Int>()
        movies.movies.forEach({ (movie) in
            yearsSet.insert(movie.year)
        })
        yearsSet.sorted(by: >).forEach({ (year) in
            moviesCategoryList.append(SortedMovies(year: year, movies: movies.movies.filter({$0.year == year})))
        })
        customMoviesCategoryList = moviesCategoryList
        moviesTableView.reloadData()
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
        }
        
        return nil
    }
    
    private func parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode(MoviesModel.self,from: jsonData)
            sortMovies(movies: decodedData)
        } catch {
            print("decode error")
        }
    }
    
    
    private func filterMovies(){
        customMoviesCategoryList.removeAll()
        moviesCategoryList.forEach({(category) in
            let movies = category.movies.filter({($0.title?.lowercased().contains(searchText.lowercased())) ?? false}).sorted(by: {$0.rating > $1.rating})
            guard !movies.isEmpty else { return }
            customMoviesCategoryList.append(SortedMovies(year: category.year, movies: movies))
        })
        moviesTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goDetailsFromMain":
            if let viewControllerDestination = segue.destination as? MovieDetailsViewController, let index = sender as? Int {
                //                viewControllerDestination.movie = self.moviesList.movies[index]
            }
        default:
            break
        }
    }
}

//MARK:- TableViewDataSource of Movies
extension MoviesListViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if customMoviesCategoryList.isEmpty{
            tableView.setEmptyView(title: "No Movies", message: "Please enter another title", image: #imageLiteral(resourceName: "icons8-no-data-availible-96"))
        }else{
            tableView.restore()
        }
        return customMoviesCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customMoviesCategoryList[section].movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "movieCell")
        cell.textLabel?.text = customMoviesCategoryList[indexPath.section].movies[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

//MARK:- TableViewDelegate of Movies
extension MoviesListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(customMoviesCategoryList[section].year)"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goDetailsFromMain", sender: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

//MARK:- Actions
extension MoviesListViewController{
    
    @IBAction func didStartSearch(_ sender: UIBarButtonItem) {
        if (!searchText.trimmingCharacters(in: .whitespaces).isEmpty){
            searchController.searchBar.text = searchText
        }
        self.present(searchController,animated: true, completion: nil)
    }
}

extension MoviesListViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (!searchText.trimmingCharacters(in: .whitespaces).isEmpty){
            self.searchText = searchText
        }
        else {
            self.searchText = ""
            customMoviesCategoryList = moviesCategoryList
            moviesTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.dismiss(animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchText = ""
        customMoviesCategoryList = moviesCategoryList
        moviesTableView.reloadData()
    }
}
