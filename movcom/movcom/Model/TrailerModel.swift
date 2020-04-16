//
//  TrailerModel.swift
//  movcom
//
//  Created by Ivan on 14/04/20.
//  Copyright © 2020 ivan. All rights reserved.
//

import Foundation

// MARK: - Trailer
struct Trailer: Codable {
    let id: Int
    let results: [TResult]
}

// MARK: - Result
struct TResult: Codable {
    let id, iso639_1, iso3166_1, key: String
    let name, site: String
    let size: Int
    let type: String

    enum CodingKeys: String, CodingKey {
        case id
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case key, name, site, size, type
    }
}
