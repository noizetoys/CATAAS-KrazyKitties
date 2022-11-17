//
//  Litterbox.swift
//  CATAAS
//
//  Created by Majors, James -ND on 11/16/22.
//

import Foundation


// View Model

class Litterbox: ObservableObject {
    private let herder = CatHerder.herder
    
    @Published var cats: [Cat] = []
    
    // For search
    private var allCats: [Cat] = [] {
        didSet {
            DispatchQueue.main.async {
                self.cats = self.allCats
            }
        }
    }
    
    
    // MARK: - Public -
    
    func gatherCatData() async {
        await preLoadCats(max: 50)
    }
    
    
    func imageURL(for id: String) -> URL? {
        URL(string: "https://cataas.com/cat/\(id)")
    }
    
    
    func searchTextChanged(_ text: String) {
        DispatchQueue.main.async {
            
            guard
                text.isEmpty != true
            else {
                self.cats = self.allCats
                return
            }
            
            self.cats = self.allCats.filter { cat in
                cat.tags(contain: text)
            }
        }
    }
    
    
    // MARK: - Private -
    
    private func preLoadCats(max: Int) async {
        do {
            if let theCats = try await herder.fetchCatData(for: max) {
                DispatchQueue.main.async {
                    self.allCats = theCats
                }
            }
        }
        catch {
            print("Error: '\(error)' preloading Cat data")
        }
    }
    
}
