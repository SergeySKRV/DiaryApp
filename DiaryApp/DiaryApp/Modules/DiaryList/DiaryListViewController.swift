//
//  DiaryListViewController.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 16.07.2026.
//

import UIKit

final class DiaryListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: DiaryListViewModel
    
    // MARK: - UI Elements
    
    private let tableView = UITableView()
    private let emptyStateView = EmptyStateView()
    
    // MARK: = Init
    
    init(viewModel: DiaryListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchEntries()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "Дневник"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAdd)
        )
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DiaryEntryCell.self, forCellReuseIdentifier: DiaryEntryCell.reuseIdentifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Binding
    
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.updateEmptyState()
            }
        }
    }
    
    private func updateEmptyState() {
        let isEmpty = viewModel.entries.isEmpty
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        if isEmpty {
            emptyStateView.updateText("Пока нет записей. \nНажмите+, чтобы добавить первую!")
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapAdd() {
        print("Navigate to create entry")
    }
}

// MARK: - UITableViewDataSource

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryEntryCell.reuseIdentifier, for: indexPath) as? DiaryEntryCell else {
            return UITableViewCell()
        }
        let entry = viewModel.entries[indexPath.row]
        cell.configure(with: entry)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Navigate to edit entry: \(viewModel.entries[indexPath.row].title)")
    }
}
