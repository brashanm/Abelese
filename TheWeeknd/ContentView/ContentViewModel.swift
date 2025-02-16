//
//  ContentViewModel.swift
//  TheWeeknd
//
//  Created by Brashan Mohanakumar on 2023-12-21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import Firebase

final class ContentViewModel: ObservableObject {
    @Published var search: String = ""
    @Published var showcaseSongs: Bool = false
    @Published var songs = [Song]()
    
    var cancellables = Set<AnyCancellable>()
    
    var toTop: CGFloat {
        showcaseSongs ? 75 : -125
    }
    
    var filteredStuff: [Song] {
        guard !search.isEmpty else {
            return songs
        }
        return songs.filter {
            $0.name.localizedCaseInsensitiveContains(search) ||
            $0.album.localizedCaseInsensitiveContains(search) ||
            $0.lyrics.localizedCaseInsensitiveContains(search)
        }
    }
    
    func getData() -> AnyPublisher<Void, Never> {
        Future { [weak self] promise in
            let db = Firestore.firestore()
            db.collection("songs").getDocuments { snapshot, error in
                if let error = error {
                    print("Error: \(error)")
                    fatalError()
                }
                guard let snapshot = snapshot else {
                    promise(.success(()))
                    return
                }
                
                DispatchQueue.main.async {
                    self?.songs = snapshot.documents.map { doc in
                        Song(
                            id: doc.documentID,
                            name: doc["name"] as? String ?? "",
                            album: doc["album"] as? String ?? "",
                            features: doc["features"] as? [String] ?? [],
                            lyrics: doc["lyrics"] as? String ?? ""
                        )
                    }
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
