//
//  MoodChartViewController.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 28.07.2026.
//

import UIKit
import SwiftUI

final class MoodChartViewController: UIViewController {
    
    private let viewModel: MoodChartViewModel
    
    private let emptyStateView = EmptyStateView()
    private var hostingController: UIHostingController<MoodChartView>?
    
    init(viewModel: MoodChartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchMoodData()
    }
    
    private func setupUI() {
        title = L10n.moodChartTitle
        view.backgroundColor = .systemBackground
        
        view.addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.updateChart()
            }
        }
    }
    
    private func updateChart() {
        let points = viewModel.dataPoints
        
        if points.isEmpty {
            emptyStateView.isHidden = false
            emptyStateView.updateText(L10n.moodChartEmpty)
            hostingController?.view.isHidden = true
        } else {
            emptyStateView.isHidden = true
            
            let chartView = MoodChartView(dataPoints: points)
            
            if let hostingController = hostingController {
                hostingController.rootView = chartView
                hostingController.view.isHidden = false
            } else {
                let controller = UIHostingController(rootView: chartView)
                addChild(controller)
                view.addSubview(controller.view)
                controller.view.translatesAutoresizingMaskIntoConstraints = false
                controller.view.backgroundColor = .clear
                
                NSLayoutConstraint.activate([
                    controller.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                    controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    controller.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
                ])
                
                controller.didMove(toParent: self)
                hostingController = controller
            }
        }
    }
}
