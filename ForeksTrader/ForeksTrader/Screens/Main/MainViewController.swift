//
//  MainViewController.swift
//  ForeksTrader
//
//  Created by Murat Can ASLAN on 7.01.2023.
//

import UIKit

class MainViewController: UIViewController {

    //MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let viewModel = MainViewModel()
    lazy var headerView = MainHeaderView(frame: .init(x: 0, y: 0, width: tableView.frame.width, height: 64))
    
    var timer: Timer?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        title = "Main"
        view.backgroundColor = .dark()
        
        createTable()
        
        setBlocks()
        viewModel.getList()
    }
    
    //MARK: - Blocks
    func setBlocks() {
        viewModel.onSuccess = { [weak self] in
            self?.viewModel.initial = false

            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] message in
            //TODO: - Show error message
        }
        
        viewModel.onTimer = { [weak self] in
            self?.startTimer()
        }
        
        headerView.leftAction = { [weak self] in
            let alert = UIAlertController(title: "Seç", message: nil, preferredStyle: .actionSheet)
            var actions: [UIAlertAction] = []
            guard let self else { return }
            for item in self.viewModel.elements {
                let name = item.name
                let action = UIAlertAction(title: name, style: .default) { [weak self] action in
                    guard let self else { return }
                    guard let title = action.title else { return }
                    self.viewModel.leftTitle = item.key
                    DispatchQueue.main.async {
                        self.headerView.update(leftTitle: name)
                    }
                    self.timer?.invalidate()
                    self.startTimer()
                }
                alert.addAction(action)
                actions.append(action)
            }
            alert.addAction(.init(title: "Vazgeç", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    private func startTimer() {
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
                self?.updateData()
                })
        }
    }
    
    @objc func updateData() {
        self.viewModel.getDetails(with: viewModel.stocks)
    }
}

//MARK: - UI Helpers
extension MainViewController {
    private func createTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .systemGray3
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .dark()
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(StockCell.createXib(), forCellReuseIdentifier: StockCell.reuseIdentifier)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - TableView Delegate&DataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellVMs.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.reuseIdentifier, for: indexPath) as? StockCell else { return .init() }
        cell.configure(with: viewModel.cellVMs[indexPath.row])
        return cell
    }
}
