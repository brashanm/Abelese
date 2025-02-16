//
//  ContentView.swift
//  TheWeeknd
//
//  Created by Brashan Mohanakumar on 2023-12-15.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ContentView: View {
    @FocusState private var clicked: Bool
    @StateObject private var viewModel = ContentViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                if !viewModel.songs.isEmpty {
                    if !viewModel.showcaseSongs {
                        Text("Abelese")
                            .font(Font.custom("Cartier", size: 130))
                            .foregroundStyle(.white)
                            .offset(y: -125)
                    }
                    HStack {
                        if viewModel.showcaseSongs {
                            Button {
                                withAnimation {
                                    viewModel.showcaseSongs = false
                                    viewModel.search = ""
                                }
                                clicked = false
                            } label: {
                                Image(systemName: "x.circle")
                                    .padding([.top, .bottom, .leading])
                                    .foregroundStyle(.black.opacity(0.5))
                            }
                        } else {
                            Image(systemName: "magnifyingglass")
                                .padding([.top, .bottom, .leading])
                                .foregroundStyle(.black.opacity(0.2))
                        }
                        
                        TextField("Search for a Weeknd song...", text: $viewModel.search)
                            .focused($clicked)
                            .padding()
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                            .onChange(of: clicked) {
                                withAnimation {
                                    viewModel.showcaseSongs = true
                                }
                            }
                        
                        if viewModel.showcaseSongs {
                            Button {
                                clicked = false
                            } label: {
                                Image(systemName: "keyboard.chevron.compact.down")
                                    .padding([.top, .bottom, .trailing])
                                    .foregroundStyle(.black.opacity(0.5))
                            }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(!clicked)
                        }
                    }
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .frame(width: 366, alignment: .center)
                    .offset(y: viewModel.toTop)
                    
                    if viewModel.showcaseSongs {
                        VStack {
                            ScrollView(showsIndicators: true) {
                                ForEach(viewModel.filteredStuff, id:\.id) { song in
                                    NavigationLink(destination: SongPageView(song: song)) {
                                        SongListView(song: song)
                                            .padding(.bottom, 4)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .padding(.bottom, 110)
                            .offset(y: 80)
                        }
                    }
                }
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(
                GeometryReader { geometry in
                    Image(.weeknd)
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                        .frame(width: geometry.size.width, alignment: .center)
                        .blur(radius: viewModel.showcaseSongs ? 5 : 0)
                        .scaleEffect(viewModel.showcaseSongs ? 1.5 : 1)
                }
            )
        }
        .onAppear {
            // Subscribe to the Combine publisher from getData()
            viewModel.getData()
                .sink { _ in
                    // You could handle completion or errors in separate closures,
                    // but for now, we’ll simply do nothing on success.
                }
                .store(in: &viewModel.cancellables)
        }
    }
}

#Preview {
    ContentView()
}
