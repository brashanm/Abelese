//
//  SongPageViewModel.swift
//  TheWeeknd
//
//  Created by Brashan Mohanakumar on 2023-12-16.
//

import Foundation
import LibreTranslate
import Combine

class SongPageViewModel: ObservableObject {
    @Published var selection: String = "English"
    @Published var languages = [String: String]()
    @Published var translatedSong: String = ""
    
    let translator = Translator("https://libretranslate.com")
    
    // You need a place to store your Combine subscriptions.
    var cancellables = Set<AnyCancellable>()
    
    // Translate a song to a given language, returning a publisher that outputs a String (the translated lyrics) or a handled error string.
    func translateSong(song: Song, language: String) -> AnyPublisher<String, Never> {
        let lines = song.lyricsSplit
        
        // We use a publisher-of-sequence, then flatMap each line's translation,
        // collect all translations, and finally join them with newlines.
        return Publishers.Sequence(sequence: lines)
            .flatMap { line -> AnyPublisher<String, Error> in
                if line.count > 900 {
                    // If the line is > 900 characters, split it and combine two translations.
                    let halfIndex = line.index(line.startIndex, offsetBy: line.count / 2)
                    let firstHalf = String(line[..<halfIndex])
                    let secondHalf = String(line[halfIndex...])
                    
                    return self.translateText(line: firstHalf, language: language)
                        .zip(self.translateText(line: secondHalf, language: language))
                        .map { $0 + $1 }  // Combine the two halves
                        .eraseToAnyPublisher()
                } else {
                    // If the line is short, just do a single translation.
                    return self.translateText(line: line, language: language)
                }
            }
            .collect() // collect all the line translations into an array
            .map { $0.joined(separator: "\n\n") }
            // In case of error, return a user-friendly string instead of failing.
            .catch { error -> Just<String> in
                Just("The error is \(error)")
            }
            .eraseToAnyPublisher()
    }
    
    // Translate a single line and return a publisher with the result (or an error).
    func translateText(line: String, language: String) -> AnyPublisher<String, Error> {
        Deferred {
            Future { promise in
                Task {
                    do {
                        let translatedText = try await self.translator.translate(line, from: "en", to: language)
                        promise(.success(translatedText))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Get all supported languages from the LibreTranslate API as a Combine publisher.
    func getLanguages() -> AnyPublisher<Void, Never> {
        Deferred {
            Future { [weak self] promise in
                Task {
                    do {
                        let libreLanguages = try await self?.translator.languages() ?? []
                        DispatchQueue.main.async {
                            for language in libreLanguages {
                                self?.languages[language.name] = language.code
                            }
                            promise(.success(()))
                        }
                    } catch {
                        print("Error: \(error)")
                        promise(.success(())) // Treat it as success but no languages
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
