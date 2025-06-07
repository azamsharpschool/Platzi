//
//  Models.swift
//  Platzi
//
//  Created by Mohammad Azam on 6/6/25.
//

import Foundation

struct Category: Codable, Identifiable {
    let id: Int
    let name: String
    let image: URL
}
