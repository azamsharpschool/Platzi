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
        let resource = Resource(endpoint: .productsByCategory(categoryId), modelType: [Product].self)
        products = try await httpClient.load(resource)
    }
    
    func createProduct(_ createProductRequest: CreateProductRequest) async throws {
        
        let body = try JSONEncoder().encode(createProductRequest)
        let resource = Resource(endpoint: .createProduct, method: .post(body), modelType: Product.self)
        let newProduct = try await httpClient.load(resource)
        print(newProduct)
        products.append(newProduct)
    }
    
}
