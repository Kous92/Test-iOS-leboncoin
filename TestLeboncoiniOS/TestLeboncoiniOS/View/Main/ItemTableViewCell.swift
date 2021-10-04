//
//  ItemTableViewCell.swift
//  TestiOSLeboncoin
//
//  Created by Koussaïla Ben Mamar on 02/10/2021.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    var viewModel = ItemCellViewModel()
    static let identifier = "itemCell"
    
    private lazy var itemImage: CachedImageView = {
        let imageView = CachedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var itemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        // label.backgroundColor = .blue
        return label
    }()
    
    private lazy var itemCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.minimumScaleFactor = 0.5
        label.font = label.font.withSize(13)
        // label.backgroundColor = .red
        return label
    }()
    
    private lazy var itemPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .green
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        // label.backgroundColor = .green
        return label
    }()
    
    private lazy var itemUrgentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.font = label.font.withSize(10)
        label.backgroundColor = .orange
        label.layer.cornerRadius = 6
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Ici on va positionner les éléments dans la vue de la cellule (ici contentView)
        contentView.addSubview(itemImage)
        contentView.addSubview(itemLabel)
        contentView.addSubview(itemCategoryLabel)
        contentView.addSubview(itemPriceLabel)
        itemImage.addSubview(itemUrgentLabel)
        // contentView.backgroundColor = .darkGray
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // À chaque fois qu'une cellule est réutilisée (lors du scroll), cela sera utile pour avoir la bonne image à l'index associé
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImage.image = nil
        itemLabel.text = nil
    }
    
    private func setConstraints() {
        // Ajout des contraintes: Auto Layout par code
        var constraints = [NSLayoutConstraint]()
        
        // Contraintes image: format 120x120 avec 10 du haut, de la gauche et du bas
        // constraints.append(itemImage.heightAnchor.constraint(equalToConstant: 100))
        constraints.append(itemImage.widthAnchor.constraint(equalToConstant: 120))
        constraints.append(itemImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10))
        constraints.append(itemImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10))
        constraints.append(itemImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10))
        
        // Contraintes titre de l'item
        constraints.append(itemLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10))
        constraints.append(itemLabel.leadingAnchor.constraint(equalTo: itemImage.trailingAnchor, constant: 10))
        constraints.append(itemLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10))
        
        // Contraintes catégorie de l'item
        constraints.append(itemCategoryLabel.topAnchor.constraint(equalTo: itemLabel.bottomAnchor, constant: 10))
        constraints.append(itemCategoryLabel.leadingAnchor.constraint(equalTo: itemImage.trailingAnchor, constant: 10))
        constraints.append(itemCategoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10))
        
        // Contraintes prix de l'item
        constraints.append(itemPriceLabel.topAnchor.constraint(equalTo: itemCategoryLabel.bottomAnchor, constant: 10))
        constraints.append(itemPriceLabel.leadingAnchor.constraint(equalTo: itemImage.trailingAnchor, constant: 10))
        constraints.append(itemPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10))
        
        // Contraintes urgence item (dans l'image)
        constraints.append(itemUrgentLabel.topAnchor.constraint(equalTo: itemImage.topAnchor, constant: 10))
        constraints.append(itemUrgentLabel.leadingAnchor.constraint(equalTo: itemImage.leadingAnchor, constant: 10))
        // constraints.append(itemUrgentLabel.trailingAnchor.constraint(equalTo: itemImage.trailingAnchor, constant: -10))
        
        // Application des contraintes définies
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(with viewModel: ItemCellViewModel) {
        self.viewModel = viewModel
        
        itemLabel.text = viewModel.itemTitle
        itemCategoryLabel.text = viewModel.itemCategory
        itemPriceLabel.text = "\(viewModel.itemPrice) €"
        itemUrgentLabel.text = viewModel.isUrgent ? "URGENT" : "NON URGENT"
        itemUrgentLabel.isHidden = viewModel.isUrgent ? false : true
        
        if let url = URL(string: viewModel.image) {
            // Téléchargement asynchrone de l'image
            itemImage.loadImage(fromURL: url, placeholderImage: "noImage")
        } else {
            itemImage.image = UIImage(named: "noImage")
        }
    }
}
