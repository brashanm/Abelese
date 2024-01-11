//
//  SongPageViewModel.swift
//  TheWeeknd
//
//  Created by Brashan Mohanakumar on 2023-12-16.
//

import Foundation
import LibreTranslate

class TranslateModel: ObservableObject {
    let translator = Translator("https://libretranslate.de")
    
    func translateSong(song: Song, language: String) async -> String {
        do {
            var translated = [String]()
            print(song.lyricsSplit.count)
            for line in song.lyricsSplit {
                let result: String
                if line.count > 900 {
                    // If the line is greater than 1000 characters, split it in half
                    let halfIndex = line.index(line.startIndex, offsetBy: line.count / 2)
                    
                    // Make two separate calls to translateText for each half
                    let firstHalf = String(line[..<halfIndex])
                    let secondHalf = String(line[halfIndex...])
                    
                    let firstResult = try await translateText(line: firstHalf, language: language)
                    let secondResult = try await translateText(line: secondHalf, language: language)
                    
                    // Merge the results
                    result = firstResult + secondResult
                } else {
                    // If the line is within the limit, make a single call to translateText
                    result = try await translateText(line: line, language: language)
                }
                translated.append(result)
            }
            return translated.joined(separator: "\n\n")
        } catch {
            return "The error is \(error)"  // Return an empty string or handle the error as needed
        }
    }

    func translateText(line: String, language: String) async throws -> String {
        do {
            let translatedText = try await translator.translate(line, from: "en", to: language)
            return translatedText
        } catch {
            throw error  // Re-throw the error to propagate it up
        }
    }
    
    func getLanguages() async -> [String: String] {
        do {
            var languages = [String: String]()
            let libreLanguages = try await translator.languages()
            for language in libreLanguages {
                languages[language.name] = language.code
            }
            print(languages)
            return languages
        } catch {
            print("Error: \(error)")
            fatalError()
        }
    }
}
