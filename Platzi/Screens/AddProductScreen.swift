//
//  AddProductScreen.swift
//  Platzi
//
//  Created by Mohammad Azam on 6/8/25.
//

import SwiftUI

struct AddProductScreen: View {
    
    private struct AddProductForm {
        var title: String = ""
        var price: Double?
        var description: String = ""
    }
    
    @State private var addProductForm = AddProductForm()
    @Environment(\.showToast) private var showToast
    
    var body: some View {
        Form {
            TextField("Title", text: $addProductForm.title)
            TextField("Price", value: $addProductForm.price, format: .number)
                .keyboardType(.numberPad)
            TextField("Description", text: $addProductForm.description, axis: .vertical)
        }.navigationTitle("Add Product")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        
                    }
                }
            }
    }
}

#Preview {
    NavigationStack {
        AddProductScreen()
    }
    .environment(PlatziStore(httpClient: MockHTTPClient()))
    .withToast()
}
