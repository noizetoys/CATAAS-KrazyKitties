//
//  CatGridView.swift
//  CATAAS
//
//  Created by Majors, James -ND on 11/16/22.
//

import SwiftUI


struct CatGridView: View {
    @StateObject private var litterBox = Litterbox()
    
    let columnLayout = Array(repeating: GridItem(), count: 3)
    private let maxCats = 30
    private let shareURL = URL(string: "https://www.apple.com")
    
    @State private var searchString: String = ""
    @State private var selectingToShare = false
    @State private var path = NavigationPath()
    @State private var catsToShare: Set<Cat> = []
    
    
    var body: some View {
        NavigationStack(path: $path) {
            
            ScrollView {
                LazyVGrid(columns: columnLayout, alignment: .center, spacing: 5.0) {
                    
                    ForEach(litterBox.cats, id: \.self) { cat in
                        catCell(for: cat)
                            .onTapGesture {
                                if selectingToShare {
                                    if catsToShare.contains(cat) { catsToShare.remove(cat) }
                                    else { catsToShare.insert(cat) }
                                }
                                else { path.append(cat) }
                            }
                    }
                    
                }
                .navigationDestination(for: Cat.self) { cat in
                    CatDetailView(cat: cat)
                }
            }
            .onAppear() {
                Task {
                    await self.litterBox.gatherCatData()
                }
                selectingToShare = false
                self.catsToShare = []
            }
            .onChange(of: searchString) { newString in
                litterBox.searchTextChanged(newString)
            }
        }
        .navigationViewStyle(.stack)
        .navigationBarTitleDisplayMode(.automatic)
        .navigationTitle("Cat Pictures!!!!!")
        .searchable(text: $searchString, placement: .toolbar, prompt: "Search Tags...")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Select Cats to Share") {
                    self.selectingToShare.toggle()
                    if selectingToShare == false {
                        self.catsToShare = []
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if selectingToShare {
                    ShareLink(item: self.shareURL!) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share Cats!")
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    
    private func catCell(for cat: Cat) -> some View {
        ZStack {
            AsyncImage(url: cat.imageURL) { image in
                image
                    .resizable()
            } placeholder: {
                Image("Cat_Sil_Placeholder")
                    .resizable()
            }
            
            tagView(for: cat.tags)
            
            if selectingToShare && catsToShare.contains(cat) == false {
                Color.white.opacity(0.7)
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    if catsToShare.contains(cat) {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 40.0, height: 40)
                            .foregroundColor(.blue)
                    }
                    else {
                        EmptyView()
                    }
                }
                .padding(30.0)
                
                Spacer()
            }
            
            Spacer()
        }
        .frame(width: 300.0, height: 300.0)
        .clipShape( RoundedRectangle(cornerRadius: 20) )
        .scaledToFit()
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.blue, lineWidth: 6.0)
        )
        .padding()

    }
    
    
    private func tagView(for tags: [String]) -> some View {
        VStack {
            Spacer()
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(tags, id: \.self) { tag in
                        
                        Text(tag)
                            .padding(10)
                            .background(Color.white)
                            .clipShape( RoundedRectangle(cornerRadius: 20) )
                            .scaledToFit()
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.blue, lineWidth: 2.0)
                            )
                        
                    }
                }
            }
            .padding(.bottom, 30)
            .padding(.horizontal, 20)
        }
    }
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CatGridView()
    }
}
