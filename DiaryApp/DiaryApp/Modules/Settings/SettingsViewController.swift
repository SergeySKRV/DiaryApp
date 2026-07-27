//
//  SettingsViewController.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 22.07.2026.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    private let viewModel: SettingsViewModel
    
    private let reminderSwitch = UISwitch()
    private let timePicker = UIDatePicker()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.settingsReminders
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private let themeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.settingsTheme
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private let themeSegmentedControl: UISegmentedControl = {
        let items = AppTheme.allCases.map { $0.localizedName }
        let segmentedControl = UISegmentedControl(items: items)
        return segmentedControl
    }()
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }
    
    private func setupUI() {
        title = L10n.settingsTitle
        view.backgroundColor = .systemBackground
        
        reminderSwitch.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        
        timePicker.datePickerMode = .time
        timePicker.locale = Locale.current
        timePicker.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
        
        themeSegmentedControl.addTarget(self, action: #selector(themeChanged(_:)), for: .valueChanged)
        
        let reminderStackView = UIStackView(arrangedSubviews: [titleLabel, reminderSwitch])
        reminderStackView.axis = .horizontal
        reminderStackView.spacing = 12
        reminderStackView.alignment = .center
        
        let themeStackView = UIStackView(arrangedSubviews: [themeTitleLabel, themeSegmentedControl])
        themeStackView.axis = .horizontal
        themeStackView.spacing = 12
        themeStackView.alignment = .center
        
        let mainStackView = UIStackView(arrangedSubviews: [reminderStackView, timePicker, themeStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 24
        mainStackView.alignment = .center
        
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            reminderStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            themeStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor)
        ])
    }
    
    private func configure() {
        reminderSwitch.isOn = viewModel.isRemindersEnabled
        timePicker.date = viewModel.reminderTime
        timePicker.isEnabled = viewModel.isRemindersEnabled
        timePicker.alpha = viewModel.isRemindersEnabled ? 1.0 : 0.5
        
        themeSegmentedControl.selectedSegmentIndex = viewModel.selectedTheme.rawValue
    }
    
    @objc private func switchToggled(_ switchControl: UISwitch) {
        viewModel.toggleReminders(enabled: switchControl.isOn) { [weak self] success in
            DispatchQueue.main.async {
                self?.reminderSwitch.isOn = success
                self?.timePicker.isEnabled = success
                self?.timePicker.alpha = success ? 1.0 : 0.5
                
                if !success && switchControl.isOn {
                    let alert = UIAlertController(title: L10n.settingsNotificationsOffTitle, message: L10n.settingsNotificationsOffMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: L10n.okAction, style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc private func timeChanged(_ picker: UIDatePicker) {
        viewModel.updateReminderTime(picker.date)
    }
    
    @objc private func themeChanged(_ segmentedControl: UISegmentedControl) {
        guard let theme = AppTheme(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        viewModel.updateTheme(theme)
        
        if let window = view.window {
            window.overrideUserInterfaceStyle = theme.interfaceStyle
        }
    }
}
