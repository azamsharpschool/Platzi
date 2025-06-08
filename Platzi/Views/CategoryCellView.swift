//
//  CategoryListView.swift
//  Platzi
//
//  Created by Mohammad Azam on 6/7/25.
//

import SwiftUI

struct CategoryCellView: View {
    
    let category: Category
    
    var body: some View {
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
    }
}
