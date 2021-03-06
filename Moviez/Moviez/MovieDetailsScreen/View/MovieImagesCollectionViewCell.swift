//
//  MovieImagesCollectionViewCell.swift
//  Moviez
//
//  Created by Ibram on 10/4/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import UIKit
import Kingfisher

class MovieImagesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImage.layer.cornerRadius = 8
    }
    
    func setImage(imageObject: PhotoObject){
        let imageURL = "\(Constants.imageLiveURL)\(imageObject.server ?? "")/\(imageObject.id ?? "")_\(imageObject.secret ?? "").jpg" /// for set live image url to show 
        movieImage.kf.setImage(with: URL(string: imageURL))
    }
}
