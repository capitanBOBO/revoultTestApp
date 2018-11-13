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

    lazy var viewModel:ViewModelType = ViewModel()
    
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
    
    func updateNotificationWithBlock(_ viewModelUpdateBlock: ViewModeUpdateBlock) {
        MBProgressHUD.hide(for: self.view, animated: true)
        viewModelUpdateBlock()
        self.tableView.beginUpdates()
        self.tableView.reloadSections(viewModel.sectionsForUpdate(), with: .none)
        self.tableView.endUpdates()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countOfRowsFor(section)
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
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TableViewCell {
            cell.valueTextField.resignFirstResponder()
        }
    }
}
