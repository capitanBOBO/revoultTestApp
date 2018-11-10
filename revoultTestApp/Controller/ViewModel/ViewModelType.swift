//
//  ViewModelType.swift
//  revoultTestApp
//
//  Created by Иван Савин on 10/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import Foundation

typealias NotificationBlock = ()->()

protocol ViewModelType {
    
    func startDataUpdatingWith(_ notify: @escaping NotificationBlock)
    func countOfRows() -> Int
    func cellViewModelFor(_ indexPath: IndexPath) -> CellViewModel?
    func didSelectCurrencyAt(_ indexPath: IndexPath)
    
}
