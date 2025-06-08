//
//  ProductListScreen.swift
//  Platzi
//
//  Created by Mohammad Azam on 6/7/25.
//

import SwiftUI

struct ProductListScreen: View {
    
    let category: Category
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .navigationTitle(category.name)
    }
}

#Preview {
    let categories: [Category] = PreviewData.load("categories")
    NavigationStack {
        ProductListScreen(category: categories[0])
    }
}
