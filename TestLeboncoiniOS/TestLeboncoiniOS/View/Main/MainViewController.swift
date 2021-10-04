//
//  ViewController.swift
//  TestLeboncoiniOS
//
//  Created by Koussaïla Ben Mamar on 02/10/2021.
//

import UIKit

class MainViewController: UIViewController {

    private var selectedIndex = 0
    let viewModel = ItemsViewModel()
    
    private lazy var searchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var filterButton: UIButton = {
        // Préciser le type .system, sinon l'action au tap ne fonctionnera pas.
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.white.cgColor
        button.setBackgroundImage(UIImage(named: "filterLogo"), for: .normal)
        button.addTarget(self, action: #selector(onFilterButtonTap(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundImage = UIImage() // Supprimer le fond par défaut
        bar.placeholder = "Rechercher"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Annuler"
        return bar
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(ItemTableViewCell.self, forCellReuseIdentifier: ItemTableViewCell.identifier)
        table.separatorStyle = .none
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        view.addSubview(searchView)
        searchView.addSubview(filterButton)
        searchView.addSubview(searchBar)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        setConstraints()
        
        // Le data binding de la vue modèle, la vue se met à jour en temps réel par rapport à la vue modèle
        viewModel.callback = { type in
            switch type {
            case .reload:
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                // Alerte: message
                let dialogMessage = UIAlertController(title: "Erreur", message: error, preferredStyle: .alert)
                 
                // Création du bouton OK
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                 
                // Ajout du bouton OK dans le message de dialogue
                dialogMessage.addAction(ok)
                 
                // Afficher l'alerte
                self.present(dialogMessage, animated: true, completion: nil)
            }
        }
        
        viewModel.getItems()
    }
    
    private func setConstraints() {
        // Ajout des contraintes: Auto Layout manuel par code
        var constraints = [NSLayoutConstraint]()
        
        // Vue du haut (barre de recherche + bouton filtre)
        constraints.append(searchView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
        constraints.append(searchView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10))
        constraints.append(searchView.heightAnchor.constraint(equalToConstant: 40))
        
        // Placement du bouton filtre dans la vue du haut
        constraints.append(filterButton.topAnchor.constraint(equalTo: searchView.topAnchor))
        constraints.append(filterButton.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -10))
        constraints.append(filterButton.bottomAnchor.constraint(equalTo: searchView.bottomAnchor))
        constraints.append(filterButton.heightAnchor.constraint(equalToConstant: 40))
        constraints.append(filterButton.widthAnchor.constraint(equalToConstant: 40))
        
        // Placement de la barre de recherche dans la vue du haut
        constraints.append(searchBar.topAnchor.constraint(equalTo: searchView.topAnchor))
        constraints.append(searchBar.bottomAnchor.constraint(equalTo: searchView.bottomAnchor))
        constraints.append(searchBar.leadingAnchor.constraint(equalTo: searchView.leadingAnchor))
        constraints.append(searchBar.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: -10))
        constraints.append(searchBar.heightAnchor.constraint(equalToConstant: 40))
        
        constraints.append(tableView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 10))
        constraints.append(tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
        constraints.append(tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        
        // Application des contraintes
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func onFilterButtonTap(sender: UIButton!) {
        // Afficher la vue pour les options de filtres.
        let filterVC = FilterViewController()
        filterVC.filterDelegate = self // Délégation
        filterVC.viewModel = viewModel
        filterVC.modalPresentationStyle = .fullScreen
        
        present(filterVC, animated: true, completion: nil)
    }
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        
        guard let searchText = searchBar.text else {
            print("Erreur recherche")
            
            return
        }
        
        viewModel.searchItems(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.resetList()
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // On affiche les détails de l'annonce
        let vc = DetailViewController()
        vc.viewModel = viewModel.itemCellsViewModels[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCellsViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier, for: indexPath) as? ItemTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: viewModel.itemCellsViewModels[indexPath.row])
        
        return cell
    }
}

extension MainViewController: FilterDelegate {
    // Délégation: on récupère les données de la vue des filtres
    func filterItemCategory(itemCategory: String) {
        dismiss(animated: true) { [weak self] in
            guard !itemCategory.isEmpty && itemCategory != "Toutes catégories" else {
                if let vm = self?.viewModel, vm.isFiltered {
                    vm.resetList()
                }
                return
            }
            
            self?.viewModel.filterItems(category: itemCategory)
        }
    }
}
