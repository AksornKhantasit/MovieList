//
//  ViewController.swift
//  MovieList
//
//  Created by Aksorn Khantasit on 17/9/2562 BE.
//  Copyright © 2562 Aksorn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var movies: [Results] = []
    var page = 1
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bundle = Bundle(for: MovieTableViewCell.self)
        let nib = UINib(nibName: "MovieTableViewCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: "MovieTableViewCell")
        getMovies()
        
    }
    
    func getMovies() {
        loadingView.isHidden = false
        
        let apiManager = APIManager()
        apiManager.getMovies(urlString: "http://api.themoviedb.org/3/discover/movie?api_key=328c283cd27bd1877d9080ccb1604c91&primary_release_date.lte=2016-12-31&sort_by=release_date.desc&page=\(page)") { [weak self] (result: Result<Movie, APIError>) in
            switch result {
            case .success(let movies):
                self?.movies += movies.results
                DispatchQueue.main.sync {
                    self?.loadingView.isHidden = true
                    self?.tableView.reloadData()
                    self?.page += 1
                }
            case .failure(let error):
                print(error.localizedDescription)
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .destructive)
                alert.addAction(action)
                DispatchQueue.main.sync {
                    self?.loadingView.isHidden = true
                    self?.present(alert, animated: true)
                }
            }
        }
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 1 && loadingView.isHidden {
            getMovies()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
            let viewController = segue.destination as? DetailViewController,
            let movieItem = sender as? Results {
            viewController.movieItem = movieItem
        }
    }

}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        let movie = movies[indexPath.row]
        cell.setupUI(movie: movie)
        return cell
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if movies.indices.contains(indexPath.row) {
            let movieItem = movies[indexPath.row]
            self.performSegue(withIdentifier: "showDetail", sender: movieItem)
        }
    }
}
