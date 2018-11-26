//
//  ErrorView.swift
//  revoultTestApp
//
//  Created by Иван Савин on 24/11/2018.
//  Copyright © 2018 Иван Савин. All rights reserved.
//

import UIKit

class ErrorView: UIView {
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor(white: 0, alpha: 0.45)
        isHidden = true
        alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
       let v = UILabel()
        v.numberOfLines = 0;
        v.font = UIFont.systemFont(ofSize: 20)
        v.textColor = UIColor.white
        v.textAlignment = NSTextAlignment.center
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func updateConstraints() {
        super.updateConstraints()
        if titleLabel.superview == nil {
            self.addSubview(titleLabel)
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }
    
    func showView(_ show: Bool) {
        if show {
            isHidden = false
        }
        UIView.animate(withDuration: 0.3,
                       animations: { [weak self] in
                        self?.alpha = show ? 1 : 0
        }) { [weak self] (complete) in
            if !show {
                self?.isHidden = true
            }
        }
    }
}
