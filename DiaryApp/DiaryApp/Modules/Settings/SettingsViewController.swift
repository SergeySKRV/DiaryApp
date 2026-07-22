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
        label.text = "Ежедневные напоминания"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
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
        title = "Настройки"
        view.backgroundColor = .systemBackground
        
        reminderSwitch.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        
        timePicker.datePickerMode = .time
        timePicker.locale = Locale.current
        timePicker.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, reminderSwitch])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        
        view.addSubview(stackView)
        view.addSubview(timePicker)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            timePicker.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            timePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configure() {
        reminderSwitch.isOn = viewModel.isRemindersEnabled
        timePicker.date = viewModel.reminderTime
        timePicker.isEnabled = viewModel.isRemindersEnabled
        timePicker.alpha = viewModel.isRemindersEnabled ? 1.0 : 0.5
    }
    
    @objc private func switchToggled(_ sw: UISwitch) {
        viewModel.toggleReminders(enabled: sw.isOn) { [weak self] success in
            DispatchQueue.main.async {
                self?.reminderSwitch.isOn = success
                self?.timePicker.isEnabled = success
                self?.timePicker.alpha = success ? 1.0 : 0.5
                
                if !success && sw.isOn {
                    let alert = UIAlertController(title: "Уведомления отключены", message: "Пожалуйста, разрешите уведомления в настройках устройства", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc private func timeChanged(_ picker: UIDatePicker) {
        viewModel.updateReminderTime(picker.date)
    }
}
