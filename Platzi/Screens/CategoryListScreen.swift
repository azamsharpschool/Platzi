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
            case .success(let categories):
                CategoryListView(categories: categories)
            case .failure(let error):
                Text(error.localizedDescription)
            }
        }.task {
            await loadCategories()
        }
    }
}

#Preview {
    NavigationStack {
        CategoryListScreen()
    }
    .environment(PlatziStore(httpClient: MockHTTPClient()))
}
