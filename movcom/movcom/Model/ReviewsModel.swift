//
//  ReviewsModel.swift
//  movcom
//
//  Created by Ivan on 14/04/20.
//  Copyright © 2020 ivan. All rights reserved.
//

import Foundation

// MARK: - Reviews
struct Reviews: Codable {
    let id      : Int
    let page    : Int?
    let results: [ResultReviews]
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct ResultReviews: Codable {
    let author, content, id: String
    let url: String
}
