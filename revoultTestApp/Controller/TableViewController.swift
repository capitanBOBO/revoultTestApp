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
    private var didLayout = false
    private var canUpdate = true
    
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
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
            self?.viewModel.downloadData()
        }
    }
    
    //MARK: Helper
    
    func textFieldBecomeFirstResponder(_ becomes:Bool) {
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TableViewCell {
            cell.textFieldBecomeFirstResponder(becomes)
        }
    }
    
    // MARK: View model delegate
    
    func updateCurrenciesList(isNeedUpdateBaseCurrency: Bool) {
        guard canUpdate else {
            return
        }
        guard didLayout else {
            MBProgressHUD.hide(for: view, animated: true)
            tableView.reloadData()
            didLayout = true
            return
        }
        self.tableView.performBatchUpdates({ [weak self] in
            let sections = isNeedUpdateBaseCurrency ? IndexSet(arrayLiteral: 0, 1) : IndexSet(arrayLiteral: 1)
            self?.tableView.reloadSections(sections, with: .none)
            
        }) { [weak self] (complete) in
            if isNeedUpdateBaseCurrency {
                self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                self?.textFieldBecomeFirstResponder(true)
            }
        }
    }
    
    func updateError(_ errorDescription: String) {
        
    }
    
    // MARK: Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
    
    //MARK: Table view delegate
    

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        canUpdate = false
        self.textFieldBecomeFirstResponder(false)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            canUpdate = true
        }
    }
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        canUpdate = false
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        canUpdate = true
    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.textFieldBecomeFirstResponder(true)
    }
}
