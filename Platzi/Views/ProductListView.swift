//
//  ProductListView.swift
//  Platzi
//
//  Created by Mohammad Azam on 6/8/25.
//

import SwiftUI

struct ProductListView: View {
    
    let products: [Product]
    @Binding var selectedProduct: Product?
    
    var body: some View {
        List(products, selection: $selectedProduct) { product in
            NavigationLink(value: product) {
                ProductCellView(product: product)
            }
        }
    }
}

struct ProductCellView: View {
    
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                AsyncImage(url: product.heroImage) { image in
                    image
                        .rounded(width: 75, height: 75)
                } placeholder: {
                    Image(systemName: "photo")
                        .placeholder(width: 75, height: 75)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(product.title)
                        .font(.title3)
                    Text(product.price, format: .currency(code: "USD"))
                }
            }
        }
    }
}

#Preview {
    ProductListView(products: PreviewData.load("products"), selectedProduct: .constant(nil))
}
