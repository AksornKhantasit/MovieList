//
//  ViewController.swift
//  MovieList
//
//  Created by Aksorn Khantasit on 17/9/2562 BE.
//  Copyright © 2562 Aksorn. All rights reserved.
//

import UIKit

// Rename
class MovieListViewController: UIViewController {
    
    var movies: [Results] = []
    var page = 1
    // change too enum
    var sortBy = "desc"
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bundle = Bundle(for: MovieTableViewCell.self)
        let nib = UINib(nibName: "MovieTableViewCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: "MovieTableViewCell")
        // please use attribute
        getMovies(sortBy: "desc")
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender: )), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
    }
    
    @objc func refresh(sender:AnyObject) {
        // add logic to check if page = 1, assign model instead of +=
        self.movies.removeAll()
        page = 1
        getMovies(sortBy:sortBy)
    }
    
    @IBAction func sort(_ sender: Any) {
        showAlert()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Sort", message: "you want to sort by...", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "ASC", style: .default, handler: { (_) in
            self.movies.removeAll()
            self.page = 1
            self.sortBy = "asc"
            self.getMovies(sortBy: self.sortBy)
        }))
        
        alert.addAction(UIAlertAction(title: "DESC", style: .default, handler: { (_) in
            self.movies.removeAll()
            self.page = 1
            self.sortBy = "desc"
            self.getMovies(sortBy: self.sortBy)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
            print("You've pressed the Cancel")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func getMovies(sortBy: String) {
        loadingView.isHidden = false
        
        let apiManager = APIManager()
        apiManager.getMovies(urlString: "http://api.themoviedb.org/3/discover/movie?api_key=328c283cd27bd1877d9080ccb1604c91&primary_release_date.lte=2016-12-31&sort_by=release_date.\(sortBy)&page=\(page)") { [weak self] (result: Result<Movie, APIError>) in
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
            // remove redundant logic
            if sortBy == "desc" {
                getMovies(sortBy: "desc")
            }
            else {
                getMovies(sortBy: "asc")
            }
        }
        else if(indexPath.row == 1 && loadingView.isHidden) {
            refreshControl.endRefreshing()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
            let viewController = segue.destination as? DetailViewController,
            let movieItem = sender as? Results {
            viewController.movieItem = movieItem
            viewController.delegate = self
        }
    }

}
extension MovieListViewController: UITableViewDataSource {
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
extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if movies.indices.contains(indexPath.row) {
            let movieItem = movies[indexPath.row]
            self.performSegue(withIdentifier: "showDetail", sender: movieItem)
        }
    }
}

extension MovieListViewController: ReloadTableViewDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
}
