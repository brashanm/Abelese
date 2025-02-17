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
import CoreData

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
                    let fetchedSongs = snapshot.documents.map { doc in
                        Song(
                            id: doc.documentID,
                            name: doc["name"] as? String ?? "",
                            album: doc["album"] as? String ?? "",
                            features: doc["features"] as? [String] ?? [],
                            lyrics: doc["lyrics"] as? String ?? ""
                        )
                    }

                    // 1) Update your in-memory array if desired
                    self?.songs = fetchedSongs
                    
                    // 2) Persist these songs to Core Data
                    self?.saveSongsToCoreData(songs: fetchedSongs)

                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func loadSongsFromCoreData() {
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<SongEntity> = SongEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            // Convert each SongEntity into a Song struct
            self.songs = entities.map { $0.toSong() }
        } catch {
            print("Error fetching songs from Core Data: \(error)")
        }
    }

    
    func saveSongsToCoreData(songs: [Song]) {
        let context = PersistenceController.shared.container.viewContext

        for song in songs {
            // 1) Check if this song already exists in Core Data (by `id`)
            let request: NSFetchRequest<SongEntity> = SongEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", song.id ?? "")

            let existingEntity: SongEntity?
            do {
                existingEntity = try context.fetch(request).first
            } catch {
                print("Error fetching existing song: \(error)")
                existingEntity = nil
            }

            // 2) If it exists, update it; otherwise create a new one
            if let entity = existingEntity {
                entity.configure(from: song, in: context)
            } else {
                let newEntity = SongEntity(context: context)
                newEntity.configure(from: song, in: context)
            }
        }

        // 3) Save the context
        do {
            try context.save()
        } catch {
            print("Error saving to Core Data: \(error)")
        }
    }

}
