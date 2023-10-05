//
//  ImportedTracksViewController.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 04.06.2023.
//

import UIKit

final class ImportedTracksViewController: UIViewController {
    // MARK: Properties
    private var tracksFiles: [ImportedTrackFile] = []
    private var filterPhrase: String = ""
    private var filteredTrackFiles: [ImportedTrackFile] {
        guard !filterPhrase.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return tracksFiles
        }
        return tracksFiles.filter { ($0.info.title ?? $0.fileName).contains(filterPhrase) }
    }

    // MARK: Subviews
    private let searchController = UISearchController()
    private let tracksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        
        updateImportedFiles()
    }
}

// MARK: - ImportedTracksCollectionHeaderDelegate
extension ImportedTracksViewController: ImportedTracksCollectionHeaderDelegate {
    func didButtonTap() {
        let filePicker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: .import)
        filePicker.allowsMultipleSelection = false
        filePicker.delegate = self
        present(filePicker, animated: true)
    }
}

// MARK: - ImportedTracksCollectionCellDelegate
extension ImportedTracksViewController: ImportedTracksCollectionCellDelegate {
    func didRemoveTrackFile(_ trackFile: ImportedTrackFile) {
        do {
            try TrackFileService.shared.deleteFile(at: trackFile.url)
            updateImportedFiles()
        } catch {
            // TODO: Wirte Error Handling
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ImportedTracksViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredTrackFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImportedTracksCollectionCell = collectionView.dequeueCell(at: indexPath)
        cell.configure(trackFile: filteredTrackFiles[indexPath.item])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MainHeader", for: indexPath) as! ImportedTracksCollectionHeader
        view.delegate = self
        return view
    }
}

extension ImportedTracksViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //presentTrackEdit(trackIndex: indexPath.row, trackList: tracksFiles)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ImportedTracksViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 82)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 42)
    }
}

// MARK: - UIDocumentPickerDelegate
extension ImportedTracksViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileForImport = urls.first else {
            // TODO: Write Error Handling
            return
        }
        
        do {
            try TrackFileService.shared.importFile(at: fileForImport)
            updateImportedFiles()
        } catch {
            // TODO: Wirte Error Handling
        }
    }
}

// MARK: - UISearchResultsUpdating
extension ImportedTracksViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let input = searchController.searchBar.searchTextField.text else {
            return
        }
        filterPhrase = input
        tracksCollectionView.reloadData()
    }
}

private extension ImportedTracksViewController {
    // MARK: Internal
    func presentTrackEdit(trackIndex: Int, trackList: [URL]) {
        let trackEditViewController = TrackEditViewController(trackIndex: trackIndex, trackList: trackList)
        trackEditViewController.modalPresentationStyle = .pageSheet
        present(trackEditViewController, animated: true)
    }
    
    func updateImportedFiles() {
        do {
            tracksFiles = try TrackFileService.shared.getImportedFiles()
            tracksCollectionView.reloadData()
        } catch {
            // TODO: Write Error Handling
        }
    }
    
    // MARK: Layout
    func layout() {
        NSLayoutConstraint.activate([
            tracksCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            tracksCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tracksCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tracksCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: Setup
    func setup() {
        // Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = UIColor("#3A3A3C")
        searchController.searchBar.searchTextField.font = .systemFont(ofSize: 16, weight: .regular)
        searchController.searchBar.placeholder = "Search for track"
        
        // Tracks Collection View
        tracksCollectionView.backgroundColor = UIColor("#F5F2E9")
        tracksCollectionView.showsVerticalScrollIndicator = false
        tracksCollectionView.showsHorizontalScrollIndicator = false
        tracksCollectionView.alwaysBounceVertical = true
        tracksCollectionView.contentInset = .init(top: 13, left: 0, bottom: -13, right: 0)
        
        tracksCollectionView.dataSource = self
        tracksCollectionView.delegate = self
        tracksCollectionView.register(ImportedTracksCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MainHeader")
        tracksCollectionView.registerCell(reuseable: ImportedTracksCollectionCell.self)
        
        tracksCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tracksCollectionView)
        
        // Self
        view.backgroundColor = UIColor("#F5F2E9")
        title = "Library"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
    }
}
