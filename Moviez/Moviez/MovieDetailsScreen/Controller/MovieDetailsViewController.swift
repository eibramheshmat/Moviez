//
//  MovieDetailsViewController.swift
//  Moviez
//
//  Created by Ibram on 10/2/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieCast: UILabel!
    @IBOutlet weak var movieGeners: UILabel!
    
    var movie = SortedMovies()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
