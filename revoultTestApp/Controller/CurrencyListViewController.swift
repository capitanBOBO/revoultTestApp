//
//  CurrencyListViewController.swift
//  revoultTestApp
//
//  Created by Иван Савин on 25/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import UIKit
import MBProgressHUD

class CurrencyListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewModelDelegate {
    
    //MARK: Objects init
    
    var canUpdateBase = true
    let viewModel = ViewModel()
    var downloadTimer:Timer!
    
    lazy var tableView: UITableView = {
        let v = UITableView()
        v.rowHeight = 45
        v.register(UINib(nibName: String(describing: TableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: "cell")
        v.delegate = self
        v.dataSource = self
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var errorView: ErrorView = {
        let v = ErrorView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        view.addSubview(tableView)
        view.addSubview(errorView)
        updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        errorView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        errorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        errorView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        super.updateViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
            self?.viewModel.downloadData()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        downloadTimer.invalidate()
    }
    
    //MARK: Helper
    
    func textFieldBecomeFirstResponder(_ becomes:Bool) {
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TableViewCell {
            cell.textFieldBecomeFirstResponder(becomes)
            canUpdateBase = !becomes
        }
    }
    
    //MARK: ViewModel Delegate
    
    func updateError(_ errorDescription: String) {
        errorView.titleLabel.text = errorDescription
        errorView.showView(true)
    }
    
    func updateCurrenciesListAt(_ indexPaths: [IndexPath]?) {
        errorView.showView(false)
        guard let indexPaths = indexPaths else {
            MBProgressHUD.hide(for: view, animated: true)
            tableView.reloadData()
            return
        }
        tableView.performBatchUpdates({ [weak self] in
            self?.tableView.reloadRows(at: indexPaths, with: .none)
        }) { [weak self] (complete) in
            if let indexPath = indexPaths.first(where: {$0.row == 0}) {
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                self?.textFieldBecomeFirstResponder(true)
            }
        }
    }
    
    //MARK: TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.viewModel = viewModel.cellViewModelFor(indexPath)
        return cell
    }
    
    //MARK: TableView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textFieldBecomeFirstResponder(false)
    }
    
}
