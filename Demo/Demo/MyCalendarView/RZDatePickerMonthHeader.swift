//
//  RZDatePickerMonthHeader.swift
//  RuZu
//
//  Created by Nero on 09/07/2017.
//  Copyright © 2017 Nero. All rights reserved.
//

import UIKit

class RZDatePickerMonthHeader: RZBaseCell {
    override func setupViews() {
        super.setupViews()
        addSubview(self.monthLabel)
        self.monthLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(self)
        }
    }
    
    var monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(rgb: 0x2a89cd)
        label.font = UIFont.systemFont(ofSize: 16)
        label.sizeToFit()
        return label
    }()
}
