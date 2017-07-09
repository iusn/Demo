//
//  RZBaseCell.swift
//  RuZu
//
//  Created by Nero on 09/07/2017.
//  Copyright © 2017 Nero. All rights reserved.
//

import UIKit

class RZBaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}
