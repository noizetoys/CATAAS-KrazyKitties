//
//  CatHerder.swift
//  CATAAS
//
//  Created by Majors, James -ND on 11/16/22.
//

import Foundation
import SwiftUI


// The Data Model

struct Cat: Codable, Hashable {
    let id: String
    let tags: [String]
    let owner: String
    let createdAt: String
    let updatedAt: String
    
    
    var imageURL: URL? {
        URL(string: "https://cataas.com/cat/\(id)")
    }
    
    
    func tags(contain text: String) -> Bool {
        tags.reduce(false) { contains, tag in
            contains || tag.contains(text.lowercased())
        }
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case tags, owner, createdAt, updatedAt
    }
    
}


// Data Fetching Service

class CatHerder {
    static let herder = CatHerder()
    
    // MARK: - Public -
    
    func fetchCatData(for count: Int) async throws -> [Cat]? {
        guard
            count >= 1,
            count <= 100
        else {
            throw NSError(domain: "Requested # of Cats must be between 1 & 100", code: 0)
        }
        
        let catTagTemplateURL = "https://cataas.com/api/cats?limit=\(count)&skip=0"
        
        let rawCats = await fetchData(for: [Cat].self, from: catTagTemplateURL)
        return rawCats?.filter { $0.tags.contains("gif") == false }
    }
    
    
    // MARK: - Private -
    
    private func fetchData<T: Decodable>(for dataType: T.Type, from urlString: String) async -> T? {
        guard
            let url = URL(string: urlString)
        else {
            print("Failed to Fetch Data.....")
            return nil
        }
        
        let request = URLRequest(url: url)
        let decoder = JSONDecoder()
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        }
        catch {
            print("Error: '\(error)' downloading \(url.debugDescription)")
        }
        
        return nil
        
    }
    
    
}
