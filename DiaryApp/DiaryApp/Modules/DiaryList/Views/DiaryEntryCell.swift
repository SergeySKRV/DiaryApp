//
//  DiaryEntryCell.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 16.07.2026.
//

import UIKit

final class DiaryEntryCell: UITableViewCell {
    
    static let reuseIdentifier = "DiaryEntryCell"
    
    // MARK: - UI Elements
    
    private let moodLabel: UILabel = {
        let moodLabel = UILabel()
        moodLabel.font = UIFont.systemFont(ofSize: 28)
        moodLabel.textAlignment = .center
        return moodLabel
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .label
        return titleLabel
    }()
    
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        dateLabel.textColor = .secondaryLabel
        return dateLabel
    }()
    
    private let previewLabel: UILabel = {
        let previewLabel = UILabel()
        previewLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        previewLabel.textColor = .secondaryLabel
        previewLabel.numberOfLines = 2
        return previewLabel
    }()
    
    private let thumbnailImageView: UIImageView = {
        let thumbnailImageView = UIImageView()
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.backgroundColor = .secondarySystemBackground
        return thumbnailImageView
    }()
    
    private let favoriteImageView: UIImageView = {
        let favoriteImageView = UIImageView()
        favoriteImageView.tintColor = .systemYellow
        favoriteImageView.contentMode = .scaleAspectFit
        return favoriteImageView
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, previewLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 4
        
        let mainStackView = UIStackView(arrangedSubviews: [moodLabel, textStackView, thumbnailImageView, favoriteImageView, dateLabel])
        mainStackView.axis = .horizontal
        mainStackView.spacing = 12
        mainStackView.alignment = .top
        
        contentView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        moodLabel.setContentHuggingPriority(.required, for: .horizontal)
        thumbnailImageView.setContentHuggingPriority(.required, for: .horizontal)
        favoriteImageView.setContentHuggingPriority(.required, for: .horizontal)
        dateLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            moodLabel.widthAnchor.constraint(equalToConstant: 32),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 50),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 50),
            favoriteImageView.widthAnchor.constraint(equalToConstant: 20),
            favoriteImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    // MARK: - Configure
    
    func configure(with model: DiaryEntryModel) {
        titleLabel.text = model.title.isEmpty ? L10n.untitled : model.title
        previewLabel.text = model.text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateLabel.text = dateFormatter.string(from: model.createdAt)
        
        moodLabel.text = model.mood?.emoji ?? ""
        
        if let imageData = model.imageData, let image = UIImage(data: imageData) {
            thumbnailImageView.image = image
            thumbnailImageView.isHidden = false
        } else {
            thumbnailImageView.image = nil
            thumbnailImageView.isHidden = true
        }
        
        let imageName = model.isFavorite ? "star.fill" : "star"
        favoriteImageView.image = UIImage(systemName: imageName)
        
        isAccessibilityElement = true
        let moodText = model.mood?.localizedName ?? L10n.moodNone
        let hasPhotoText = model.imageData != nil ? L10n.accessibilityWithPhoto : L10n.accessibilityWithoutPhoto
        accessibilityLabel = String(format: L10n.accessibilityEntryLabelFormat, titleLabel.text ?? "", moodText, hasPhotoText, dateLabel.text ?? "")
        accessibilityHint = L10n.accessibilityEntryHint
        accessibilityTraits = .button
    }
}
