//
//  AddProductScreen.swift
//  Platzi
//
//  Created by Mohammad Azam on 6/8/25.
//

import SwiftUI

struct AddProductScreen: View {
    
    let category: Category
    
    @State private var addProductForm = AddProductForm()
    @State private var errors: [String] = []
    @Environment(PlatziStore.self) private var store
    @Environment(\.showToast) private var showToast
    @Environment(\.dismiss) private var dismiss
    
    private func createProduct(_ createProductRequest: CreateProductRequest) async {
        do {
            try await store.createProduct(createProductRequest)
            dismiss()
        } catch {
            showToast(.error(error.localizedDescription))
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
            .onAppear(perform: {
                addProductForm.selectedCategory = category
            })
        .navigationTitle("Add Product")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        
                        errors = addProductForm.validate()
                        
                        if !errors.isEmpty {
                            showToast(.error(errors.joinedWithNewlines()))
                        } else {
                            
                            let createProductRequest = CreateProductRequest(title: addProductForm.title, price: addProductForm.price!, description: addProductForm.description, categoryId: addProductForm.selectedCategory!.id, images: addProductForm.images)
                            
                            Task { await createProduct(createProductRequest) }
                        }
                    }
                }
            }
    }
}


extension AddProductScreen {
    
    private struct AddProductForm {
        
        var title: String = "New Item June 8"
        var price: Int? = 100
        var description: String = "New Item June 8 Description"
        var selectedCategory: Category?
        var images: [URL] = [URL(string: "https://placehold.co/600x400")!]
        
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
    
}


#Preview {
    
    let categories: [Category] = PreviewData.load("categories")
    
    NavigationStack {
        AddProductScreen(category: categories[0])
    }
    .withToast()
    .environment(PlatziStore(httpClient: MockHTTPClient()))
   
}
