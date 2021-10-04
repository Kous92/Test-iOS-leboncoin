//
//  DetailViewController.swift
//  TestLeboncoiniOS
//
//  Created by Koussaïla Ben Mamar on 03/10/2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    weak var viewModel: ItemCellViewModel?
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    private lazy var productImage: CachedImageView = {
        let imageView = CachedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityIdentifier = "productImage" // Pour les tests UI
        return imageView
    }()
    
    private lazy var closeButton: UIButton = {
        // Préciser le type .system, sinon l'action au tap ne fonctionnera pas.
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "closeButton"), for: .normal)
        button.addTarget(self, action: #selector(onCloseTap(sender:)), for: .touchUpInside)
        button.accessibilityIdentifier = "closeButton" // Pour les tests UI
        return button
    }()
    
    private lazy var productTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "productTitle" // Pour les tests UI
        return label
    }()
    
    private lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 1
        label.sizeToFit()
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "productPrice" // Pour les tests UI
        return label
    }()
    
    private lazy var postedDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 1
        label.sizeToFit()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "productDate" // Pour les tests UI
        return label
    }()
    
    private lazy var productDescriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        label.numberOfLines = 1
        label.sizeToFit()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var productDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "productDescription" // Pour les tests UI
        return label
    }()
    
    private lazy var professionalSellerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "productPro" // Pour les tests UI
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupScrollView()
        setupViews()
        setData()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.accessibilityIdentifier = "scrollView"
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    private func setupViews(){
        contentView.addSubview(productImage)
        productImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        productImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        productImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        productImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2).isActive = true
        
        view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        contentView.addSubview(productTitleLabel)
        productTitleLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 20).isActive = true
        productTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        productTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        contentView.addSubview(productPriceLabel)
        productPriceLabel.topAnchor.constraint(equalTo: productTitleLabel.bottomAnchor, constant: 10).isActive = true
        productPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        productPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        contentView.addSubview(postedDateLabel)
        postedDateLabel.topAnchor.constraint(equalTo: productPriceLabel.bottomAnchor, constant: 15).isActive = true
        postedDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        postedDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        contentView.addSubview(productDescriptionTitleLabel)
        productDescriptionTitleLabel.topAnchor.constraint(equalTo: postedDateLabel.bottomAnchor, constant: 30).isActive = true
        productDescriptionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        productDescriptionTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        contentView.addSubview(productDescriptionLabel)
        productDescriptionLabel.topAnchor.constraint(equalTo: productDescriptionTitleLabel.bottomAnchor, constant: 10).isActive = true
        productDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        productDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        contentView.addSubview(professionalSellerLabel)
        professionalSellerLabel.topAnchor.constraint(equalTo: productDescriptionLabel.bottomAnchor, constant: 30).isActive = true
        professionalSellerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        professionalSellerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        // Ne pas oublier la contrainte du dernier élément en bas de la vue, afin que ça scrolle. Sinon ça ne scrollera pas.
        professionalSellerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
    }
    
    private func setData() {
        guard viewModel != nil else {
            print("ERREUR")
            return
        }
        
        productTitleLabel.text = viewModel?.itemTitle ?? "Titre indisponible"
        productPriceLabel.text = "\(viewModel?.itemPrice ?? 0) €"
        postedDateLabel.text = viewModel?.itemAddedDate ?? "Date inconnue"
        productDescriptionLabel.text = viewModel?.itemDescription ?? "Pas de description."
        
        if let professionalSeller = viewModel?.siret {
            professionalSellerLabel.text = "VENDEUR PROFESSIONNEL, SIRET: \(professionalSeller)"
        } else {
            professionalSellerLabel.isHidden = true
        }
        
        
        if let url = URL(string: viewModel?.image ?? "") {
            // Téléchargement asynchrone de l'image
            productImage.loadImage(fromURL: url, placeholderImage: "noImage")
        } else {
            productImage.image = UIImage(named: "noImage")
        }
    }
    
    @objc func onCloseTap(sender: UIButton!) {
        dismiss(animated: true, completion: nil)
    }
}
