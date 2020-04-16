//
//  GenreModel.swift
//  movcom
//
//  Created by Ivan on 14/04/20.
//  Copyright © 2020 ivan. All rights reserved.
//

import Foundation

struct Genre: Codable {
    let genres: [GenreElement]
}

// MARK: - GenreElement
struct GenreElement: Codable {
    let id: Int
    let name: String
}
