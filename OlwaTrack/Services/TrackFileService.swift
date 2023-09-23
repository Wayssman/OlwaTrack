//
//  TrackFileService.swift
//  OlwaTrack
//
//  Created by Alexandr Zhelanov on 23.09.2023.
//

import AVFoundation

enum TrackFileServiceError: Error {
    case defaultError
}

final class TrackFileService {
    // MARK: Constants
    let nameOfDirectoryForImport = "OlwaTrackImported"
    
    // MARK: Static
    static let shared = TrackFileService()
    
    // MARK: Initializers
    private init() {}
    
    // MARK: Interface
    func extractTrackInfo(url: URL) -> ImportedTrackInfo {
        let asset = AVAsset(url: url)
        let metadataItems = asset.metadata
        
        var titleAssetValue: String?
        var artistAssetValue: String?
        var artworkAssetValue: Data?
        
        for item in metadataItems {
            guard
                let key = item.commonKey?.rawValue,
                let value = item.value
            else { continue }
            
            switch key {
            case "title":
                titleAssetValue = value as? String
            case "artist":
                artistAssetValue = value as? String
            case "artwork":
                artworkAssetValue = value as? Data
            default:
                break
            }
        }
        
        return .init(
            title: titleAssetValue,
            artist: artistAssetValue,
            artwork: artworkAssetValue
        )
    }
    
    func importFile(at url: URL) throws {
        guard
            let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else {
            // TODO: Write Error Handling
            return
        }
        
        // Creates new directory
        // Miss error handling if directory already exists
        let newDirectoryUrl = documentsUrl.appendingPathComponent(nameOfDirectoryForImport, isDirectory: true)
        try? FileManager.default.createDirectory(at: newDirectoryUrl, withIntermediateDirectories: false)
        
        // Creates new file
        let newFileUrl = newDirectoryUrl.appendingPathComponent(url.lastPathComponent, isDirectory: false)
        do {
            try FileManager.default.copyItem(at: url, to: newFileUrl)
        } catch {
            // TODO: Write Error Handling
        }
    }
    
    func getImportedFiles() throws -> [ImportedTrackFile] {
        guard
            let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else {
            // TODO: Write Error Handling
            throw TrackFileServiceError.defaultError
        }
        // Get contents of directory
        let directoryForImportUrl = documentsUrl.appendingPathComponent(nameOfDirectoryForImport, isDirectory: true)
        do {
            let contentOfDirectory = try FileManager.default.contentsOfDirectory(
                at: directoryForImportUrl,
                includingPropertiesForKeys: nil
            )
            return contentOfDirectory.compactMap { ImportedTrackFile(url: $0) }
            
        } catch {
            // TODO: Write Error Handling
            throw TrackFileServiceError.defaultError
        }
    }
}
