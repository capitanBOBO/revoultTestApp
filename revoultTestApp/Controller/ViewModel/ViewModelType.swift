//
//  ViewModelType.swift
//  revoultTestApp
//
//  Created by Иван Савин on 10/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import Foundation


protocol ViewModelType {
    
    var delegate:ViewModelDelegate? { set get }
    func downloadData()
    func countOfRowsFor(_ section: Int) -> Int
    func cellViewModelFor(_ indexPath: IndexPath) -> CellViewModel?
}
