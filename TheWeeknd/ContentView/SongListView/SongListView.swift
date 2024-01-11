//
//  SongListView.swift
//  TheWeeknd
//
//  Created by Brashan Mohanakumar on 2023-12-15.
//

import SwiftUI

struct SongListView: View {
    let song: Song
    var body: some View {
        HStack {
            Image(song.albumCover)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(width: 100, height: 100, alignment: .leading)
                .padding(.trailing)
    
            Spacer()
            VStack {
                Text(song.name)
                    .transition(.scale)
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .bold()
                Text(song.album)
                    .transition(.scale)
                    .multilineTextAlignment(.center)
                    .font(.title3)
            }
            Spacer()
        }
        .padding()
        .transition(.scale)
        .frame(width: 360)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    SongListView(song: Song(name: "High for This", album: "Trilogy", features: [], lyrics: ""))
}
