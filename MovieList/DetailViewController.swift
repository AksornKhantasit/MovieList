//
//  DetailViewController.swift
//  MovieList
//
//  Created by Aksorn Khantasit on 18/9/2562 BE.
//  Copyright © 2562 Aksorn. All rights reserved.
//

import UIKit
import Cosmos

protocol ReloadTableViewDelegate: class {
    func reloadTableView()
}

class DetailViewController: UIViewController {
    
    public var movieItem: Results!
    var delegate: ReloadTableViewDelegate?
    var avg = 0.0
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var popularity: UILabel!
    @IBOutlet weak var popular: UILabel!
    @IBOutlet weak var overView: UILabel!
    @IBOutlet weak var CategoryLable: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var LanguageLable: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var cosmos: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovieDetail()
        getcosmos()
    }
    func getcosmos()  {
        cosmos.didTouchCosmos = { rating in
            print("Rated: \(rating)")
            if !self.cosmos.rating.isNaN {
                self.calculatorAvg(rated: rating)
            }
            UserDefaults.standard.set( rating , forKey: "rating\(self.movieItem.id)")
            self.delegate?.reloadTableView()
        }
        let rated = UserDefaults.standard.double(forKey: "rating\(self.movieItem.id)")
        print("getRating : \(rated)")
        self.cosmos.rating = rated
    }
    func calculatorAvg(rated: Double) {
            avg = ((movieItem.voteAverage * movieItem.voteCount) + rated)/(movieItem.voteCount + 1)
            UserDefaults.standard.set( avg , forKey: "avg\(self.movieItem.id)")
            print(avg)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTitle(movieItem: movieItem)
    }
    
    func setTitle(movieItem: Results) {
        txtTitle.text = movieItem.title
        popular.text = String(format: "%.2f", movieItem.popularity)
        overView.text = movieItem.overview
        
        let baseURL = "https://image.tmdb.org/t/p/original"
        let posterPath = movieItem.posterPath
        if let posterPath = posterPath {
            let url = URL(string: "\(baseURL)\(posterPath)")
            movieImage.kf.setImage(with: url)
        }
    }
    
    func setDetail(moviesdetail: MovieDetail) {
        if !moviesdetail.genres.isEmpty {
            // change for loop
            for element in moviesdetail.genres {
                print(element)
            }
            let nam = moviesdetail.genres.count - 1
            var strCategory: [String] = []
            for index in  (0...nam) {
                strCategory.append(moviesdetail.genres[index].name)
            }
            
            category.text = strCategory.joined(separator: " , ")
        } else {
            category.text = "-"
        }
        language.text = moviesdetail.Language
    }
   
    func getMovieDetail() {
        let apiManager = APIManager()
        // url
        apiManager.getMovies(urlString: "https://api.themoviedb.org/3/movie/\(movieItem.id)?api_key=328c283cd27bd1877d9080ccb1604c91") { [weak self] (result: Result<MovieDetail, APIError>) in
            switch result {
            case .success(let moviesdetail):
                DispatchQueue.main.sync {
                    self?.setDetail(moviesdetail: moviesdetail)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .destructive)
                alert.addAction(action)
                DispatchQueue.main.sync {
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}
