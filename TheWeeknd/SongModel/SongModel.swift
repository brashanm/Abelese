//
//  Song.swift
//  TheWeeknd
//
//  Created by Brashan Mohanakumar on 2023-12-15.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Song: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var album: String
    var features: [String]
    var lyrics: String
    
    var albumCover: String {
        switch album {
        case "Trilogy":
            return "Trilogy"
        case "Kiss Land":
            return "KissLand"
        case "Beauty Behind the Madness":
            return "Bbtm"
        case "Starboy":
            return "Starboy"
        case "My Dear Melancholy,":
            return "Mdm"
        case "After Hours":
            return "AfterHours"
        default:
            return "DawnFM"
        }
    }
    
    var multilineLyrics: String {
        lyrics.replacingOccurrences(of: "\\n", with: "\n")
    }
    
    var lyricsSplit: [String] {
        multilineLyrics.components(separatedBy: "\n\n")
    }
}
