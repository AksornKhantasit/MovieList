//
//  ViewController.swift
//  MovieList
//
//  Created by Aksorn Khantasit on 17/9/2562 BE.
//  Copyright © 2562 Aksorn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bundle = Bundle(for: MovieTableViewCell.self)
        let nib = UINib(nibName: "MovieTableViewCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: "MovieTableViewCell")
    }

}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
//        let mobile = mobiles[indexPath.row]
//        cell.setupUI(mobile: mobile)
        return cell
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if mobiles.indices.contains(indexPath.row) {
//            let mobileItem = mobiles[indexPath.row]
//            self.performSegue(withIdentifier: "showDetail", sender: mobileItem)
//
//        }
    }
}
