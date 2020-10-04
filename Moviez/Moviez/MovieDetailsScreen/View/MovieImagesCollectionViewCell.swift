//
//  MovieImagesCollectionViewCell.swift
//  Moviez
//
//  Created by Ibram on 10/4/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import UIKit

class MovieImagesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setImage(imageObject: PhotoObject){
        let imageURL = "https://live.staticflickr.com/\(imageObject.server ?? "")/\(imageObject.id ?? "")_\(imageObject.secret ?? "").jpg"
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: URL(string: imageURL)!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.movieImage.image = image
                    }
                }
            }
        }
    }

}
