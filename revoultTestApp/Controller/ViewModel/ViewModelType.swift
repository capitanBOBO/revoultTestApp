//
//  ViewModelType.swift
//  revoultTestApp
//
//  Created by Иван Савин on 10/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import Foundation


protocol ViewModelType {
    
    func startDataUpdating()
    func countOfRowsFor(_ section: Int) -> Int
    func cellViewModelFor(_ indexPath: IndexPath) -> CellViewModel?
    func didSelectCurrencyAt(_ indexPath: IndexPath)
    
}