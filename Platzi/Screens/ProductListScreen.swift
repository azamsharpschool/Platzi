//
//  ProductListScreen.swift
//  Platzi
//
//  Created by Mohammad Azam on 6/7/25.
//

import SwiftUI

struct ProductListScreen: View {
    
    let category: Category
    
    private enum LoadingState {
        case loading
        case success([Product])
        case failure(Error)
    }
    
    @Environment(PlatziStore.self) private var store
    @State private var selectedProduct: Product?
    @State private var showAddProductScreen: Bool = false
    @Environment(\.showToast) private var showToast
    @State private var loadingState: LoadingState = .loading
    
    private func loadProductsByCategory() async {
        
        do {
            loadingState = .loading
            try await store.loadProductsBy(categoryId: category.id)
            loadingState = .success(store.products)
        } catch {
            loadingState = .failure(error)
        }
    }
    
    private func deleteProduct(product: Product) async {
        do {
            try await store.deleteProduct(productId: product.id!)
            loadingState = .success(store.products)
        } catch {
            loadingState = .failure(error)
        }
    }
    
    var body: some View {
        Group {
            switch loadingState {
            case .loading:
                ProgressView("Loading products...")
            case .success(let products):
                    ProductListView(products: products, selectedProduct: $selectedProduct, onDelete: deleteProduct)
            case .failure(let error):
                ToastView(type: .error(error.localizedDescription))
            }
        }
        .task(id: store.products) {
            if store.products.isEmpty {
                await loadProductsByCategory()
            } else {
                loadingState = .success(store.products)
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
