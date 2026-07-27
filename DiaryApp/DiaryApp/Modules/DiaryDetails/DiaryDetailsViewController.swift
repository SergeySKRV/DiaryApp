//
//  DiaryDetailsViewController.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 16.07.2026.
//

import UIKit

final class DiaryDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: DiaryDetailsViewModel
    
    // MARK: - UI Elements
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        textField.placeholder = L10n.detailsTitlePlaceholder
        textField.borderStyle = .none
        textField.returnKeyType = .next
        return textField
    }()
    
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textView.backgroundColor = .clear
        textView.isScrollEnabled = true
        return textView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.detailsBodyPlaceholder
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .tertiaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let moodSegmentedControl: UISegmentedControl = {
        let items = MoodType.allCases.map { $0.localizedName }
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
        return segmentedControl
    }()
    
    // MARK: - Init
    
    init(viewModel: DiaryDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureView()
        setupNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(didTapSave)
        )
        
        titleTextField.delegate = self
        bodyTextView.delegate = self
        
        view.addSubview(titleTextField)
        view.addSubview(bodyTextView)
        view.addSubview(moodSegmentedControl)
        view.addSubview(placeholderLabel)
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        moodSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            moodSegmentedControl.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            moodSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            moodSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            bodyTextView.topAnchor.constraint(equalTo: moodSegmentedControl.bottomAnchor, constant: 16),
            bodyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            bodyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            bodyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            placeholderLabel.topAnchor.constraint(equalTo: bodyTextView.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: bodyTextView.leadingAnchor, constant: 5),
            placeholderLabel.trailingAnchor.constraint(equalTo: bodyTextView.trailingAnchor, constant: -5)
        ])
    }
    
    private func configureView() {
        if let entry = viewModel.existingEntry {
            title = L10n.detailsEditTitle
            titleTextField.text = entry.title
            bodyTextView.text = entry.text
            if let mood = entry.mood, let index = MoodType.allCases.firstIndex(of: mood) {
                moodSegmentedControl.selectedSegmentIndex = index
            }
        } else {
            title = L10n.detailsCreateTitle
            bodyTextView.text = ""
            bodyTextView.becomeFirstResponder()
        }
        updatePlaceholderVisibility()
    }
    
    private func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !bodyTextView.text.isEmpty
    }
    
    // MARK: - Keyboard Handling
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        bodyTextView.contentInset.bottom = keyboardHeight + 20
        bodyTextView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        bodyTextView.contentInset.bottom = 0
        bodyTextView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    // MARK: - Actions
    
    @objc private func didTapSave() {
        view.endEditing(true)
        
        let title = titleTextField.text ?? ""
        let text = bodyTextView.text ?? ""
        var selectedMood: MoodType?
        
        if moodSegmentedControl.selectedSegmentIndex != UISegmentedControl.noSegment {
            selectedMood = MoodType.allCases[moodSegmentedControl.selectedSegmentIndex]
        }
        
        viewModel.save(title: title, text: text, mood: selectedMood) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    let alert = UIAlertController(title: L10n.detailsErrorTitle, message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: L10n.okAction, style: .default, handler: nil))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension DiaryDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        bodyTextView.becomeFirstResponder()
        return true
    }
}

// MARK: - UITextViewDelegate

extension DiaryDetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        updatePlaceholderVisibility()
    }
}
