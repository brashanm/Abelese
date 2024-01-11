//
//  ContentViewModel.swift
//  TheWeeknd
//
//  Created by Brashan Mohanakumar on 2023-12-21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ContentViewModel: ObservableObject {
    @Published var search: String = "" // String-type variable in search bar
    @Published var showcaseSongs: Bool = false // Decides when to show all The Weeknd songs
    @Published var songs = [Song]() // Array of Song objects from Cloud Firestore
    
    // Used to determine offset of views
    var toTop: CGFloat {
        showcaseSongs ? 75 : -125
    }
    
    // Used to allow search bar to work properly
    var filteredStuff: [Song] {
        guard !search.isEmpty else { // If there's nothing in the search bar, all songs should be shown
            return songs
        }
        return songs.filter { // If user inputs something in the search bar, see if that term is recognized in any of the names or album names
            $0.name.localizedCaseInsensitiveContains(search) ||
            $0.album.localizedCaseInsensitiveContains(search) ||
            $0.lyrics.localizedCaseInsensitiveContains(search)
        }
    }
    
    // Function that retrieves the data from the Cloud Firestore database and fills the songs Array
    func getData() async {
        Task {
            let db = Firestore.firestore()
            do {
                let snapshot = try await db.collection("songs").getDocuments()
                
                // Parse the data and update UI on the main thread
                DispatchQueue.main.async {
                    self.songs = snapshot.documents.map { doc in
                        return Song(
                            id: doc.documentID,
                            name: doc["name"] as? String ?? "",
                            album: doc["album"] as? String ?? "",
                            features: doc["features"] as? [String] ?? [],
                            lyrics: doc["lyrics"] as? String ?? ""
                        )
                    }
                }
            } catch {
                // Handle errors
                print("Error: \(error)")
                fatalError()
            }
        }
    }
}

