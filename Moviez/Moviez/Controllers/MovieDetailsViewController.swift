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
    
    var movie = MoviesDetails()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillData()
        // Do any additional setup after loading the view.
    }
    
    private func fillData(){
        self.movieTitle.text = movie.title
        self.movieYear.text = "Year: "+"\(movie.year ?? 0)"
        self.movieCast.text = returnStringFromArr(arrString: movie.cast ?? [])
        self.movieGeners.text = returnStringFromArr(arrString: movie.genres ?? [])
    }

    func returnStringFromArr(arrString: [String]) -> String{
        if arrString.count > 0{
            var returnString = ""
            for index in 0..<arrString.count{
                if returnString == ""{
                    returnString =  arrString[index]
                }else{
                    returnString = returnString + ", " + arrString[index]
                }
            }
            return returnString
        }else{
            return "No Data available"
        }
    }
    
    
}
