//
//  CategoryListScreen.swift
//  Platzi
//
//  Created by Mohammad Azam on 6/6/25.
//

import SwiftUI

struct CategoryListScreen: View {
    
    @Environment(PlatziStore.self) private var store
    
    private func loadCategories() async {
        do {
            try await store.loadCategories()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        List(store.categories) { category in
            HStack {
                AsyncImage(url: category.image) { image in
                    image.resizable()
                        .frame(width: 75, height: 75)
                } placeholder: {
                    Image(systemName: "photo")
                        .placeholder(width: 75, height: 75)
                }

                Text(category.name)
            }
        }.task {
            await loadCategories()
        }.navigationTitle("Categories")
    }
}

#Preview {
    NavigationStack {
        CategoryListScreen()
    }
    .environment(PlatziStore(httpClient: MockHTTPClient()))
}
