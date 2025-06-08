//
//  ProductDetailScreen.swift
//  Platzi
//
//  Created by Mohammad Azam on 6/8/25.
//

import SwiftUI

struct ProductDetailScreen: View {
    
    let product: Product
    
    var body: some View {
        List {
            Text(product.price, format: .currency(code: "USD"))
                .priceTag()
                
            ScrollView(.horizontal) {
                HStack {
                    ForEach(product.images, id: \.self) { url in
                        AsyncImage(url: url) { img in
                            img.rounded(width: 100, height: 100)
                        } placeholder: {
                            Image(systemName: "photo")
                                .placeholder(width: 100, height: 100)
                        }
                    }
                }
            }
            Text(product.description)
                .listRowSeparator(.hidden)
            Spacer()
        }
        
        .listStyle(.plain)
        .padding()
        .navigationTitle(product.title)
    }
}

#Preview {
    
    let products: [Product] = PreviewData.load("products")
    NavigationStack {
        ProductDetailScreen(product: products[0])
    }
}
