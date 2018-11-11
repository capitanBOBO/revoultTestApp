//
//  TableViewController.swift
//  revoultTestApp
//
//  Created by Иван Савин on 07/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import UIKit
import MBProgressHUD

class TableViewController: UITableViewController, ViewModelDelegate {

    lazy var viewModel:ViewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 45
        tableView.register(UINib(nibName: String(describing: TableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: "cell")
        viewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MBProgressHUD.showAdded(to: view, animated: true)
        viewModel.startDataUpdating()
    }
    
    // MARK: - View model delegate
    
    func update() {
        self.tableView.reloadData()
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        if let cellViewModel = viewModel.cellViewModelFor(indexPath) {
            cell.viewModel = cellViewModel
        }
        return cell
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MBProgressHUD.showAdded(to: view, animated: true)
        viewModel.didSelectCurrencyAt(indexPath)
    }
}
