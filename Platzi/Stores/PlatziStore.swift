//
//  PlatziStore.swift
//  Platzi
//
//  Created by Mohammad Azam on 6/6/25.
//

import Foundation
import Observation

@MainActor
@Observable
class PlatziStore {
    
    var categories: [Category] = []
    var products: [Product] = []
    let httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    func loadCategories() async throws {
        let resource = Resource(endpoint: .categories, modelType: [Category].self)
        categories = try await httpClient.load(resource)
    }
    
    func loadProductsBy(categoryId: Int) async throws {
        
    }
    
}
