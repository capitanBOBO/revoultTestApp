//
//  TableViewCell.swift
//  revoultTestApp
//
//  Created by Иван Савин on 10/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var viewModel:CellViewModelType! {
        didSet {
            self.titleLabel.text = viewModel.currencyName
            self.valueTextField.text = viewModel.currencyValue
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        valueTextField.delegate = self
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected, !viewModel.isBaseCurrency {
            viewModel.setCurrencyAsBase()
        }
    }
    
    //MARK: UITextFiled delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if !viewModel.isBaseCurrency {
            viewModel.setCurrencyAsBase()
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldString = textField.text {
            let newString = oldString.replacingCharacters(in: Range(range, in: oldString)!,
                                                          with: string)
            
            viewModel.changeCurrencyValueOn(Float(newString) ?? 0)
            return true
        }
        return false
    }
    
}
