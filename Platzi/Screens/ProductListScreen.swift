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
    @State private var showAddProductScreen: Bool = false
    
    @Environment(\.showToast) private var showToast
    
    var body: some View {
        ProductListView(products: store.products, selectedProduct: $selectedProduct)
            .task {
                do {
                    try await store.loadProductsBy(categoryId: category.id)
                } catch {
                    showToast(.error(error.localizedDescription))
                }
            }
            .navigationDestination(item: $selectedProduct, destination: { selectedProduct in
                ProductDetailScreen(product: selectedProduct)
            })
        .navigationTitle(category.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Product") {
                    showAddProductScreen = true
                }
            }
        }
        .sheet(isPresented: $showAddProductScreen) {
            NavigationStack {
                AddProductScreen(category: category)
                    .withToast()
            }
        }
    }
}

#Preview {
    let categories: [Category] = PreviewData.load("categories")
    NavigationStack {
        ProductListScreen(category: categories[0])
    }
    .environment(PlatziStore(httpClient: MockHTTPClient()))
    .withToast()
}
