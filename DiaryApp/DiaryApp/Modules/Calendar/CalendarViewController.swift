//
//  CalendarViewController.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 21.07.2026.
//

import UIKit

final class CalendarViewController: UIViewController {
    
    private let viewModel: CalendarViewModel
    private let router: DiaryRouter
    
    private var calendarView: UICalendarView!
    private var selectedDate: DateComponents?
    
    init(viewModel: CalendarViewModel, router: DiaryRouter) {
        self.viewModel = viewModel
        self.router = router
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
        viewModel.fetchDatesWithEntries()
    }
    
    private func setupUI() {
        title = L10n.calendarTitle
        view.backgroundColor = .systemBackground
        
        calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.calendar = Calendar.current
        calendarView.locale = Locale.current
        calendarView.fontDesign = .default
        calendarView.delegate = self
        
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.calendarView.reloadDecorations(forDateComponents: Array(self?.viewModel.visibleDates ?? []), animated: true)
            }
        }
    }
}

// MARK: - UICalendarView Delegate

extension CalendarViewController: UICalendarViewDelegate {
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if viewModel.visibleDates.contains(dateComponents) {
            return UICalendarView.Decoration.default(color: .systemBlue, size: .medium)
        }
        return nil
    }
}

// MARK: - Date Selection Delegate

extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents,
              let date = Calendar.current.date(from: dateComponents) else { return }
        
        let dayKey = date.dayKey()
        router.showDayEntries(dayKey: dayKey, date: date)
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        return true
    }
}

