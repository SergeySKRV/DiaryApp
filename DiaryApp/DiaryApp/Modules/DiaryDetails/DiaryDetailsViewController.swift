//
//  DiaryDetailsViewController.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 16.07.2026.
//

import UIKit
import PhotosUI

final class DiaryDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: DiaryDetailsViewModel
    
    // MARK: - UI Elements
    
    private let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleTextField.placeholder = L10n.detailsTitlePlaceholder
        titleTextField.borderStyle = .none
        titleTextField.returnKeyType = .next
        return titleTextField
    }()
    
    private let bodyTextView: UITextView = {
        let bodyTextView = UITextView()
        bodyTextView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        bodyTextView.backgroundColor = .clear
        bodyTextView.isScrollEnabled = true
        return bodyTextView
    }()
    
    private let placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.text = L10n.detailsBodyPlaceholder
        placeholderLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.numberOfLines = 0
        return placeholderLabel
    }()
    
    private let moodSegmentedControl: UISegmentedControl = {
        let items = MoodType.allCases.map { $0.localizedName }
        let moodSegmentedControl = UISegmentedControl(items: items)
        moodSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
        return moodSegmentedControl
    }()
    
    private let photoImageView: UIImageView = {
        let photoImageView = UIImageView()
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.backgroundColor = .secondarySystemBackground
        photoImageView.layer.cornerRadius = 12
        photoImageView.isUserInteractionEnabled = true
        return photoImageView
    }()
    
    private let addPhotoButton: UIButton = {
        let addPhotoButton = UIButton(type: .system)
        addPhotoButton.setTitle(L10n.detailsAddPhoto, for: .normal)
        addPhotoButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return addPhotoButton
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
        
        addPhotoButton.addTarget(self, action: #selector(didTapAddPhoto), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAddPhoto))
        photoImageView.addGestureRecognizer(tapGesture)
        
        view.addSubview(titleTextField)
        view.addSubview(moodSegmentedControl)
        view.addSubview(photoImageView)
        view.addSubview(addPhotoButton)
        view.addSubview(bodyTextView)
        view.addSubview(placeholderLabel)
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        moodSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            moodSegmentedControl.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            moodSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            moodSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            photoImageView.topAnchor.constraint(equalTo: moodSegmentedControl.bottomAnchor, constant: 16),
            photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: 150),
            photoImageView.heightAnchor.constraint(equalToConstant: 150),
            
            addPhotoButton.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 8),
            addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            bodyTextView.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 16),
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
            if let imageData = entry.imageData {
                photoImageView.image = UIImage(data: imageData)
                addPhotoButton.setTitle(L10n.detailsChangePhoto, for: .normal)
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
                    HapticManager.shared.success()
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    HapticManager.shared.error()
                    let alert = UIAlertController(title: L10n.detailsErrorTitle, message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: L10n.okAction, style: .default, handler: nil))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc private func didTapAddPhoto() {
        HapticManager.shared.impactLight()
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
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
    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderVisibility()
    }
}

// MARK: - PHPickerViewControllerDelegate

extension DiaryDetailsViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider else { return }
        
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                DispatchQueue.main.async {
                    if let selectedImage = image as? UIImage {
                        self?.photoImageView.image = selectedImage
                        self?.viewModel.currentImageData = selectedImage.jpegData(compressionQuality: 0.7)
                        self?.addPhotoButton.setTitle(L10n.detailsChangePhoto, for: .normal)
                    }
                }
            }
        }
    }
}
