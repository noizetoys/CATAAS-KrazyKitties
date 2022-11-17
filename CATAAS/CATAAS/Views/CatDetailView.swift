//
//  CatDetailView.swift
//  CATAAS
//
//  Created by Majors, James -ND on 11/16/22.
//

import SwiftUI

struct CatDetailView: View {
    var cat: Cat
    
    var body: some View {
        ZStack {
            backgroundImage
            
            VStack {
                Spacer()
                
                ScrollView(.horizontal) {
                    tagsList
                }
                .padding(.horizontal)
            }
            
        }
        .navigationTitle("Cats Up Close!!!")
    }
    
    
    var backgroundImage: some View {
        AsyncImage(url: cat.imageURL) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            Image("Cat_Sil_Placeholder")
                .resizable()
                .scaledToFit()
        }
        .padding()
    }
    
    
    var tagsList: some View {
        HStack {
            ForEach(cat.tags, id: \.self) { tag in
               Text(tag)
                    .font(.title)
                    .fixedSize()
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.blue.opacity(0.5))
                    .clipShape( RoundedRectangle(cornerRadius: 20) )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.blue, lineWidth: 2.0)
                    )
            }
        }
        .padding(.bottom, 60)
    }
    
    
}


