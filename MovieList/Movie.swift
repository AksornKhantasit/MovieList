//
//  Movie.swift
//  MovieList
//
//  Created by Aksorn Khantasit on 17/9/2562 BE.
//  Copyright © 2562 Aksorn. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let page: Int
    let results: [Results]
}

struct Results: Codable {
    let id: Double
    let popularity: Double
    let voteCount: Double
    let voteAverage: Double
    let title: String
    let overview: String
    let backdropPath: String?
    let posterPath: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case popularity
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case title
        case overview
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
    }
}

struct MovieDetail: Codable {
    let genres: [Genres]
    let Language: String
    
    private enum CodingKeys: String, CodingKey {
        case genres
        case Language = "original_language"
    }
}

struct Genres: Codable {
    //let id: Int
    let name: String
}
