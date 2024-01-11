//
//  SongPageView.swift
//  TheWeeknd
//
//  Created by Brashan Mohanakumar on 2023-12-15.
//

import SwiftUI

struct SongPageView: View {
    let song: Song
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SongPageViewModel()
    
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.backward")
                        Text("Back")
                    }
                    .padding(.horizontal)
                    Spacer()
                }
                VStack {
                    HStack {
                        Image(song.albumCover)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(width: 150, height: 150, alignment: .leading)
                            .padding([.horizontal, .top])
                            .padding(.leading, 10)
                        
                        Spacer()
                        VStack {
                            Spacer()
                            Text(song.name)
                                .multilineTextAlignment(.center)
                                .font(.title2)
                                .bold()
                                .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .bottom)
                            if !song.features.isEmpty {
                                Text("(feat. \(song.features[0]))")
                                    .multilineTextAlignment(.center)
                                Spacer()
                                Spacer()
                            }
                            Text(song.album)
                                .multilineTextAlignment(.center)
                                .font(.title3)
                                .fontWeight(.medium)
                                .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .top)
                            Spacer()
                        }
                        Spacer()
                        Spacer()
                    }
                    .frame(width: 375, height: 175)
                    
                    Divider().frame(width: 325)
                    HStack {
                        Text("Translation")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Picker(selection: $viewModel.selection) {
                            ForEach(Array(viewModel.languages.keys), id: \.self) {
                                Text($0)
                            }
                        } label: {
                            Text("Translation")
                        }
                        .tint(.black)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .onChange(of: viewModel.selection) { oldValue, newValue in
                            if let code = viewModel.languages[newValue] {
                                Task {
                                    viewModel.translatedSong = await viewModel.translateSong(song: song, language: code)
                                }
                                print(viewModel.languages.count)
                            }
                        }
                    }
                    .frame(maxWidth: 350)
                    .padding([.horizontal, .bottom])
                }
                .frame(width: 375)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                
                ScrollView(showsIndicators: false) {
                    Text(viewModel.selection == "English" ? song.multilineLyrics : viewModel.translatedSong)
                }
                .padding()
                .padding(.bottom)
                .font(.headline)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .ignoresSafeArea()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image(song.albumCover)
                    .renderingMode(.original)
                    .resizable()
                    .opacity(0.2)
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            )
        }
        .task {
            await viewModel.getLanguages()
        }
    }
}

#Preview {
    SongPageView(song: Song(name: "The Zone", album: "Trilogy", features: ["Drake"], lyrics: lyrics))
}

let lyrics = """
[Verse 1]\nYou don't know what's in store\nBut you know what you're here for\nClose your eyes, lay yourself beside me (Ooh)\nHold tight for this ride\nWe don't need no protection\nCome alone, we don't need attention[Verse 1]\nYou don't know what's in store\nBut you know what you're here for\nClose your eyes, lay yourself beside me (Ooh)\nHold tight for this ride\nWe don't need no protection\nCome alone, we don't need attention[Verse 1]\nYou don't know what's in store\nBut you know what you're here for\nClose your eyes, lay yourself beside me (Ooh)\nHold tight for this ride\nWe don't need no protection\nCome alone, we don't need attention[Verse 1]\nYou don't know what's in store\nBut you know what you're here for\nClose your eyes, lay yourself beside me (Ooh)\nHold tight for this ride\nWe don't need no protection\nCome alone, we don't need attention[Verse 1]\nYou don't know what's in stonYou don't know what's in store\nBut you know what you're here for
"""
