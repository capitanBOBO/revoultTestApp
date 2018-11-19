//
//  CellViewModelType.swift
//  revoultTestApp
//
//  Created by Иван Савин on 10/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import Foundation

protocol CellViewModelType {
    var currencyName:String { get }
    var currencyValue:String { get }
    var isBaseCurrency:Bool { get }
    func changeCurrencyValueOn(_ value: Float)
    func setCurrencyAsBase()
}
