//
//  ProductListScreen.swift
//  Platzi
//
//  Created by Mohammad Azam on 6/7/25.
//

import SwiftUI

struct ProductListScreen: View {
    
    let category: Category
    
    @Environment(PlatziStore.self) private var store
    @State private var selectedProduct: Product?
    
    var body: some View {
        ProductListView(products: store.products, selectedProduct: $selectedProduct)
            .task {
                do {
                    try await store.loadProductsBy(categoryId: category.id)
                } catch {
                    print(error)
                }
            }
            .navigationDestination(item: $selectedProduct, destination: { selectedProduct in
                ProductDetailScreen(product: selectedProduct)
            })
        .navigationTitle(category.name)
    }
}

#Preview {
    let categories: [Category] = PreviewData.load("categories")
    NavigationStack {
        ProductListScreen(category: categories[0])
    }
    .environment(PlatziStore(httpClient: MockHTTPClient()))
}
