//
//  MovieTableViewCell.swift
//  MovieList
//
//  Created by Aksorn Khantasit on 17/9/2562 BE.
//  Copyright © 2562 Aksorn. All rights reserved.
//

import UIKit
import Kingfisher

var imageCache: [String: UIImage] = [:]

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var popular: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var backdropImage: UIImageView!
    
    
    func setupUI(movie: Results) {
        title.text = movie.title
        popular.text = "\(movie.popularity)"
        
        let baseURL = "https://image.tmdb.org/t/p/original"
        let posterPath = movie.posterPath
        let backdropPath = movie.backdropPath
        if let posterPath = posterPath {
            let url = URL(string: "\(baseURL)\(posterPath)")
            movieImage.kf.setImage(with: url)
        }
        if let backdropPath = backdropPath {
            let url = URL(string: "\(baseURL)\(backdropPath)")
            backdropImage.kf.setImage(with: url)

        }
        
        rating.text = "\(movie.voteAverage)"
    }
}
