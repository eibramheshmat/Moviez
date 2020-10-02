//
//  ViewController.swift
//  Moviez
//
//  Created by Ibram on 10/2/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var moviesList = MoviesModel()
    var itemSelecter = 0
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCell()
        if let moviesData = readLocalFile(forName: "movies"){
            parse(jsonData: moviesData)
            DispatchQueue.main.async {
                self.moviesTableView.reloadData()
            }
        }
    }

    private func registerCell(){
        self.moviesTableView.register(UINib(nibName: "MoviesTableViewCell", bundle: nil), forCellReuseIdentifier: "MoviesTableViewCell")
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
               self.moviesList = decodedData
           } catch {
               print("decode error")
           }
       }
}

//MARK:- TableView of Movies

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.moviesList.movies.count > 0{
            return self.moviesList.movies.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: "MoviesTableViewCell", for: indexPath) as! MoviesTableViewCell
        cell.setData(movieName: moviesList.movies[indexPath.row].title ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.itemSelecter = indexPath.row
        performSegue(withIdentifier: "goDetailsFromMain", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goDetailsFromMain":
            if let viewControllerDestination = segue.destination as? MovieDetailsViewController{
                viewControllerDestination.movie = self.moviesList.movies[itemSelecter]
            }
        default:
            break
        }
    }
}
