//
//  PreviewData.swift
//  Platzi
//
//  Created by Mohammad Azam on 6/6/25.
//

import Foundation

struct PreviewData {
    
    static func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
        let data: Data

        // Locate file in bundle
        guard let file = Bundle.main.url(forResource: filename, withExtension: "json") else {
            fatalError("❌ Couldn't find \(filename).json in main bundle.")
        }

        // Load data
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("❌ Couldn't load data from \(filename).json: \(error)")
        }

        // Decode JSON
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("❌ Couldn't decode \(filename).json as \(T.self): \(error)")
        }
    }
}

