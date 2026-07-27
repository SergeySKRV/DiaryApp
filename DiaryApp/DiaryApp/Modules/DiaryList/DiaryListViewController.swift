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
    private let router: DiaryRouter
    
    // MARK: - UI Elements
    
    private let tableView = UITableView()
    private let emptyStateView = EmptyStateView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let favoritesBarButtonItem = UIBarButtonItem()
    
    // MARK: = Init
    
    init(viewModel: DiaryListViewModel, router: DiaryRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchController()
        bindViewModel()
        updateFavoritesButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !viewModel.isSearching {
            viewModel.fetchEntries()
        }
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = L10n.diaryTitle
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAdd)
        )
        
        favoritesBarButtonItem.image = UIImage(systemName: "star")
        favoritesBarButtonItem.style = .plain
        favoritesBarButtonItem.target = self
        favoritesBarButtonItem.action = #selector(didTapFavoritesFilter)
        navigationItem.leftBarButtonItem = favoritesBarButtonItem
        
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
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = L10n.searchPlaceholder
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
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
            if viewModel.isSearching {
                emptyStateView.updateText(L10n.emptyNoSearchResults)
            } else if viewModel.isShowingFavoritesOnly {
                emptyStateView.updateText(L10n.emptyNoFavorites)
            } else {
                emptyStateView.updateText(L10n.emptyNoEntries)
            }
        }
    }
    
    private func updateFavoritesButton() {
        let imageName = viewModel.isShowingFavoritesOnly ? "star.fill" : "star"
        favoritesBarButtonItem.image = UIImage(systemName: imageName)
        favoritesBarButtonItem.tintColor = viewModel.isShowingFavoritesOnly ? .systemYellow : .systemBlue
    }
    
    // MARK: - Actions
    
    @objc private func didTapAdd() {
        router.showCreateEntry()
    }
    
    @objc private func didTapFavoritesFilter() {
        viewModel.toggleFavoritesFilter()
        updateFavoritesButton()
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
        let entry = viewModel.entries[indexPath.row]
        router.showEditEntry(entry)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let entry = viewModel.entries[indexPath.row]
        
        let favoriteAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completionHandler in
            self?.viewModel.toggleFavorite(id: entry.id)
            completionHandler(true)
        }
        
        let imageName = entry.isFavorite ? "star.slash.fill" : "star.fill"
        favoriteAction.image = UIImage(systemName: imageName)
        favoriteAction.backgroundColor = .systemYellow
        
        let config = UISwipeActionsConfiguration(actions: [favoriteAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
}

// MARK: - UISearchResultsUpdating

extension DiaryListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        viewModel.search(query)
    }
}
