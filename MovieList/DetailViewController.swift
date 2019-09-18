//
//  DetailViewController.swift
//  MovieList
//
//  Created by Aksorn Khantasit on 18/9/2562 BE.
//  Copyright © 2562 Aksorn. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    public var movieItem: Results!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var popularity: UILabel!
    @IBOutlet weak var popular: UILabel!
    @IBOutlet weak var overView: UILabel!
    
        override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTitle(movieItem: movieItem)
    }
    
    func setTitle(movieItem: Results) {
        txtTitle.text = movieItem.title
        popular.text = "\(movieItem.popularity)"
        overView.text = movieItem.overview
        print("title ",title)
        let baseURL = "https://image.tmdb.org/t/p/original"
        let posterPath = movieItem.posterPath
        let backdropPath = movieItem.backdropPath
        if let posterPath = posterPath {
            let url = URL(string: "\(baseURL)\(posterPath)")
            movieImage.kf.setImage(with: url)
        }

        
    }
    

}
