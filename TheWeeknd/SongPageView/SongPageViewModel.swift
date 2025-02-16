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
    
    var cancellables = Set<AnyCancellable>()
    
    func translateSong(song: Song, language: String) -> AnyPublisher<String, Never> {
        let lines = song.lyricsSplit
        
    
        return Publishers.Sequence(sequence: lines)
            .flatMap { line -> AnyPublisher<String, Error> in
                if line.count > 900 {
                    let halfIndex = line.index(line.startIndex, offsetBy: line.count / 2)
                    let firstHalf = String(line[..<halfIndex])
                    let secondHalf = String(line[halfIndex...])
                    
                    return self.translateText(line: firstHalf, language: language)
                        .zip(self.translateText(line: secondHalf, language: language))
                        .map { $0 + $1 }
                        .eraseToAnyPublisher()
                } else {
                    return self.translateText(line: line, language: language)
                }
            }
            .collect()
            .map { $0.joined(separator: "\n\n") }
            .catch { error -> Just<String> in
                Just("The error is \(error)")
            }
            .eraseToAnyPublisher()
    }
    
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
                        promise(.success(()))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
