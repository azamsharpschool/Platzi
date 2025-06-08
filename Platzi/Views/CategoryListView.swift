//
//  CategoryListView.swift
//  Platzi
//
//  Created by Mohammad Azam on 6/7/25.
//

import SwiftUI

struct CategoryListView: View {
    
    let categories: [Category]
    @Binding var selectedCategory: Category?
    
    var body: some View {
        List(categories, selection: $selectedCategory) { category in
            NavigationLink(value: category) {
                CategoryCellView(category: category)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CategoryListView(categories: PreviewData.load("categories"), selectedCategory: .constant(nil))
    }
}
