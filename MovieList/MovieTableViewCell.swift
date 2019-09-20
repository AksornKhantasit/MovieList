//
//  MovieTableViewCell.swift
//  MovieList
//
//  Created by Aksorn Khantasit on 17/9/2562 BE.
//  Copyright © 2562 Aksorn. All rights reserved.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var popular: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var backdropImage: UIImageView!
    
    func setupUI(movie: Results) {
        title.text = movie.title
        popular.text = String(format: "%.2f", movie.popularity)
        
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
        // userdefault can get double
        let getavg = UserDefaults.standard.double(forKey: "avg\(movie.id)") ?? 0.0
        if getavg == 0.0 {
            rating.text = String(format: "%.1f", movie.voteAverage)
        }
        else {
            rating.text = String(format: "%.1f", getavg ?? 0.0)
        }
    }
}
