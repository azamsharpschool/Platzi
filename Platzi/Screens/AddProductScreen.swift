//
//  AddProductScreen.swift
//  Platzi
//
//  Created by Mohammad Azam on 6/8/25.
//

import SwiftUI

struct AddProductScreen: View {
    
    private struct AddProductForm {
        
        var title: String = "New Item June 8"
        var price: Int? = 100
        var description: String = "New Item June 8 Description"
        var selectedCategory: Category?
        
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
            
            if selectedCategory == nil {
                errors.append("Category is required.")
            }
            
            return errors
        }
    }
    
    @State private var addProductForm = AddProductForm()
    @State private var errors: [String] = []
    @Environment(PlatziStore.self) private var store
    @Environment(\.showToast) private var showToast
    
    private func createProduct(_ product: Product) async {
        
        do {
            try await store.createProduct(product)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
            Form {
                TextField("Title", text: $addProductForm.title)
                TextField("Price", value: $addProductForm.price, format: .number)
                    .keyboardType(.numberPad)
                TextField("Description", text: $addProductForm.description, axis: .vertical)
                Picker("Select category", selection: $addProductForm.selectedCategory) {
                    ForEach(store.categories) { category in
                        Text(category.name)
                            .tag(category)
                    }
                }.pickerStyle(.menu)
                
            }
        .navigationTitle("Add Product")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        errors = addProductForm.validate()
                        
                        if !errors.isEmpty {
                            showToast(.error(errors.joinedWithNewlines()))
                        } else {
                            let product = Product(title: addProductForm.title, price: addProductForm.price!, description: addProductForm.description, category: addProductForm.selectedCategory!, images: [URL(string: "https://placehold.co/600x400")!])
                            
                            Task {
                                await createProduct(product)
                            }
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
