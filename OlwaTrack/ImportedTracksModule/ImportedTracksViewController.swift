//
//  ImportedTracksViewController.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 04.06.2023.
//

import UIKit

final class ImportedTracksViewController: UIViewController {
    // MARK: Constants
    let nameOfDirectoryForImport = "OlwaTrackImported"
    
    // MARK: Properties
    private var tracksFiles: [URL] = []

    // MARK: Subviews
    private let headerContentView = UIView()
    private let addTrackButton = UIButton()
    private let tracksCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        
        getImportedFiles()
    }
}

// MARK: - UICollectionViewDataSource
extension ImportedTracksViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracksFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImportedTracksCollectionCell = collectionView.dequeueCell(at: indexPath)
        cell.configure(trackUrl: tracksFiles[indexPath.item])
        
        return cell
    }
}

extension ImportedTracksViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentTrackEdit(trackIndex: indexPath.row, trackList: tracksFiles)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ImportedTracksViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 82)
    }
}

// MARK: - UIDocumentPickerDelegate
extension ImportedTracksViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileForImport = urls.first else {
            // TODO: Write Error Handling
            return
        }
        
        importFile(at: fileForImport)
    }
}

private extension ImportedTracksViewController {
    // MARK: Internal
    func presentTrackEdit(trackIndex: Int, trackList: [URL]) {
        let trackEditViewController = TrackEditViewController(trackIndex: trackIndex, trackList: trackList)
        trackEditViewController.modalPresentationStyle = .pageSheet
        present(trackEditViewController, animated: true)
    }
    
    func importFile(at url: URL) {
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
        
        getImportedFiles()
    }
    
    func getImportedFiles() {
        guard
            let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else {
            // TODO: Write Error Handling
            return
        }
        // Get contents of directory
        let directoryForImportUrl = documentsUrl.appendingPathComponent(nameOfDirectoryForImport, isDirectory: true)
        do {
            let contentOfDirectory = try FileManager.default.contentsOfDirectory(
                at: directoryForImportUrl,
                includingPropertiesForKeys: nil
            )
            tracksFiles = contentOfDirectory
            tracksCollectionView.reloadData()
        } catch {
            // TODO: Write Error Handling
        }
    }
    
    // MARK: User Interactivity
    @objc func addTrackButtonTapped() {
        let filePicker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: .import)
        filePicker.allowsMultipleSelection = false
        filePicker.delegate = self
        present(filePicker, animated: true)
    }
    
    // MARK: Layout
    func layout() {
        NSLayoutConstraint.activate([
            tracksCollectionView.topAnchor.constraint(equalTo: headerContentView.bottomAnchor),
            tracksCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tracksCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tracksCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerContentView.topAnchor.constraint(equalTo: view.topAnchor),
            headerContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerContentView.heightAnchor.constraint(equalToConstant: 100),
            
                addTrackButton.trailingAnchor.constraint(equalTo: headerContentView.trailingAnchor, constant: -14),
                addTrackButton.bottomAnchor.constraint(equalTo: headerContentView.bottomAnchor, constant: -14),
                addTrackButton.heightAnchor.constraint(equalToConstant: 35),
                addTrackButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // MARK: Setup
    func setup() {
        // View
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        // Tracks Collection View
        tracksCollectionView.backgroundColor = .white
        tracksCollectionView.showsVerticalScrollIndicator = false
        tracksCollectionView.showsHorizontalScrollIndicator = false
        tracksCollectionView.alwaysBounceVertical = true
        tracksCollectionView.contentInset = .init(top: 13, left: 0, bottom: -13, right: 0)
        tracksCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tracksCollectionView.registerCell(reuseable: ImportedTracksCollectionCell.self)
        tracksCollectionView.dataSource = self
        tracksCollectionView.delegate = self
        view.addSubview(tracksCollectionView)
        
        // Tracks Content View
        headerContentView.backgroundColor = .white
        headerContentView.layer.shadowOffset = .init(width: 0, height: 0)
        headerContentView.layer.shadowColor = UIColor.black.cgColor
        headerContentView.layer.shadowRadius = 10
        headerContentView.layer.shadowOpacity = 0.25
        headerContentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerContentView)
        
        // Add Track Button
        addTrackButton.backgroundColor = UIColor("#3A3A3C")
        addTrackButton.layer.cornerRadius = 8
        addTrackButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        addTrackButton.setTitle("Add Track", for: [])
        addTrackButton.translatesAutoresizingMaskIntoConstraints = false
        addTrackButton.addTarget(self, action: #selector(addTrackButtonTapped), for: .touchUpInside)
        headerContentView.addSubview(addTrackButton)
    }
}
