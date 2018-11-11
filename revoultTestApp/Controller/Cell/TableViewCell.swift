//
//  TableViewCell.swift
//  revoultTestApp
//
//  Created by Иван Савин on 10/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var viewModel:CellViewModel! {
        didSet {
            self.titleLabel.text = viewModel.currencyName
            self.valueTextField.text = viewModel.currencyValue
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
