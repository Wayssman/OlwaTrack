//
//  ImportedTrackFile.swift
//  OlwaTrack
//
//  Created by Alexandr Zhelanov on 23.09.2023.
//

import AVFoundation

struct ImportedTrackFile {
    let url: URL
    let audioFile: AVAudioFile
    let info: ImportedTrackInfo
    
    var fileName: String {
        return url.deletingPathExtension().lastPathComponent
    }
    
    init?(url: URL) {
        self.url = url
        self.info = TrackFileService.shared.extractTrackInfo(url: url)
        do {
            self.audioFile = try AVAudioFile(forReading: url)
        } catch {
            return nil
        }
    }
}

struct ImportedTrackInfo {
    let title: String?
    let artist: String?
    let artwork: Data?
}
