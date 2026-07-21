//
//  DiaryRouter.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 21.07.2026.
//

import UIKit

final class DiaryRouter {
    
    private weak var navigationController: UINavigationController?
    private let repository: DiaryRepositoryProtocol
    
    init(navigationController: UINavigationController, repository: DiaryRepositoryProtocol) {
        self.navigationController = navigationController
        self.repository = repository
    }
    
    // MARK: - Navigation Methods
    
    func showCreateEntry() {
        let viewModel = DiaryDetailsViewModel(repository: repository, entry: nil)
        let viewController = DiaryDetailsViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showEditEntry(_ entry: DiaryEntryModel) {
        let viewModel = DiaryDetailsViewModel(repository: repository, entry: entry)
        let viewController = DiaryDetailsViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func popToRoot() {
        navigationController?.popViewController(animated: true)
    }
}
