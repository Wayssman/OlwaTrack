//
//  MainViewController.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 01.06.2023.
//

import UIKit

final class MainViewController: UIViewController {
    // MARK: Properties
    private var model: [FileObject] = [
    ]
    
    // MARK: Subviews
    private let trackPicker = UIDocumentPickerViewController(documentTypes: ["public.mp3", "public.midi", "public.mp3"], in: .import)
    private let trackList = UITableView()
    
    // MARK: Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        trackList.dataSource = self
        trackList.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
    }
}

// MARK: - UIDocumentPickerDelegate
extension MainViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileUrl = urls.first else {
            return
        }
        
        
        let fileNameWithExtension = fileUrl.lastPathComponent
        let fileExtension = fileUrl.pathExtension
        let fileName = String(fileUrl.lastPathComponent.prefix(fileNameWithExtension.count - fileExtension.count))
        
        model.append(.init(title: fileName, path: fileUrl))
        trackList.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = model[indexPath.row].title
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = model[indexPath.row].path
        
        if let controller = TrackViewController(trackUrl: url) {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

private extension MainViewController {
    // MARK: User Interactivity
    @objc func addTrackTapped() {
        trackPicker.delegate = self
        present(trackPicker, animated: true)
    }
    
    // MARK: Setup
    func layout() {
        NSLayoutConstraint.activate([
            trackList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            trackList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setup() {
        setupTrackList()
        setupAddTrackButton()
    }
    
    func setupTrackList() {
        trackList.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackList)
        
    }
    
    func setupAddTrackButton() {
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTrackTapped)
        )
    }
}
