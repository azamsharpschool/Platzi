//
//  CategoryListScreen.swift
//  Platzi
//
//  Created by Mohammad Azam on 6/6/25.
//

import SwiftUI

struct CategoryListScreen: View {
    
    @Environment(PlatziStore.self) private var store
    @State private var loadingState: LoadingState = .loading
    @State private var selectedCategory: Category?
    
    private enum LoadingState {
        case loading
        case success([Category])
        case failure(Error)
    }
    
    private func loadCategories() async {
        do {
            try await store.loadCategories()
            loadingState = .success(store.categories)
        } catch {
            loadingState = .failure(error)
        }
    }
      
    var body: some View {
        Group {
            switch loadingState {
            case .loading:
                ProgressView("Loading...")
                    .task {
                        await loadCategories()
                    }
            case .success(let categories):
                CategoryListView(categories: categories, selectedCategory: $selectedCategory)
            case .failure(let error):
                ToastView(type: .error(error.localizedDescription))
            }
        }
        .navigationTitle("Platzi")
        .navigationDestination(item: $selectedCategory) { selectedCategory in
            ProductListScreen(category: selectedCategory)
        }
    }
}

#Preview {
    NavigationStack {
        CategoryListScreen()
    }
    .environment(PlatziStore(httpClient: MockHTTPClient()))
}
