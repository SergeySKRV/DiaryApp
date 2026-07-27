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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        
        let mainStackView = UIStackView(arrangedSubviews: [textStackView, favoriteImageView, dateLabel])
        mainStackView.axis = .horizontal
        mainStackView.spacing = 12
        mainStackView.alignment = .top
        
        contentView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        favoriteImageView.setContentHuggingPriority(.required, for: .horizontal)
        dateLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
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
        
        let imageName = model.isFavorite ? "star.fill" : "star"
        favoriteImageView.image = UIImage(systemName: imageName)
    }
}
