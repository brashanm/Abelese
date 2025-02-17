//
//  PersistenceController.swift
//  TheWeeknd
//
//  Created by Brashan Mohanakumar on 2025-02-16.
//

import Foundation
import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "SongModel")

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error loading persistent stores: \(error)")
            }
        }
    }
}

extension SongEntity {
    func configure(from song: Song, in context: NSManagedObjectContext) {
        self.id = song.id
        self.name = song.name
        self.album = song.album
        self.lyrics = song.lyrics
        self.features = song.features as NSObject
    }
    
    func toSong() -> Song {
        Song(
            id: self.id,
            name: self.name ?? "",
            album: self.album ?? "",
            features: (self.features as? [String]) ?? [],
            lyrics: self.lyrics ?? ""
        )
    }
}

