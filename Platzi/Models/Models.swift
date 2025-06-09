//
//  Models.swift
//  Platzi
//
//  Created by Mohammad Azam on 6/6/25.
//

import Foundation

struct Category: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let image: URL
}

struct Product: Codable, Identifiable, Hashable {
    var id: Int?
    let title: String
    let price: Int
    let description: String
    let category: Category
    let images: [URL]
    
    var heroImage: URL? {
        images.first
    }
}

struct ErrorResponse: Codable {
    let message: String?
}

struct CreateProductRequest: Encodable {
    let title: String
    let price: Int
    let description: String
    let categoryId: Int
    let images: [URL]
}





