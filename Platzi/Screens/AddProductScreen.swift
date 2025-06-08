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
        
        func validate() -> [String] {
            
            var errors: [String] = []
            
            if title.isEmpty {
                errors.append("Title is required.")
            }
            
            if let price {
                if price < 0 {
                    errors.append("Price should be greater than 0.")
                }
            } else {
                errors.append("Price is required.")
            }
            
            if description.isEmpty {
                errors.append("Description is required.")
            }
            
            return errors
        }
    }
    
    @State private var addProductForm = AddProductForm()
    @State private var errors: [String] = []
    @Environment(\.showToast) private var showToast
    
    var body: some View {
            Form {
                TextField("Title", text: $addProductForm.title)
                TextField("Price", value: $addProductForm.price, format: .number)
                    .keyboardType(.numberPad)
                TextField("Description", text: $addProductForm.description, axis: .vertical)
                
            }
        .navigationTitle("Add Product")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        errors = addProductForm.validate()
                        
                        if !errors.isEmpty {
                            showToast(.error(errors.joinedWithNewlines()))
                        } else {
                            // add the product
                        }
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
