//
//  RZDatePickerCell.swift
//  RuZu
//
//  Created by Nero on 09/07/2017.
//  Copyright © 2017 Nero. All rights reserved.
//

import UIKit

class RZDatePickerCell: RZBaseCell {
    var type: AirbnbDatePickerCellType! = []
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.init(rgb: 0x666666)
        return label
    }()
    
    var highlightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        self.addSubview(self.highlightView)
        self.highlightView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(self)
        }
        self.highlightView.addSubview(dateLabel)
        self.dateLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: self.bounds.size.width-3, height: self.bounds.size.width-3))
        }
    }
    
    func configureCell() {
        if type.contains(.Selected) || type.contains(.SelectedStartDate) || type.contains(.SelectedEndDate) || type.contains(.InBetweenDate) {
            
            dateLabel.layer.cornerRadius = 0
            dateLabel.layer.borderColor = UIColor.white.cgColor
            dateLabel.layer.borderWidth = 1
            dateLabel.layer.backgroundColor = ThemeNavColor().cgColor
            dateLabel.layer.mask = nil
            dateLabel.textColor = UIColor.white
            
            if type.contains(.SelectedStartDate) {
                dateLabel.textColor = ThemeNavColor()
                dateLabel.backgroundColor = UIColor.white
                dateLabel.layer.cornerRadius = (self.bounds.size.width-3)/2
            } else if type.contains(.SelectedEndDate) {
                let side = frame.size.width / 2
                let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: side, height: side))
                let shape = CAShapeLayer()
                shape.path = maskPath.cgPath
                dateLabel.layer.mask = shape
                dateLabel.textColor = UIColor.white
            } else if !type.contains(.InBetweenDate) {
                dateLabel.layer.cornerRadius = frame.size.width / 2
            }
        } else if type.contains(.PastDate) {
            dateLabel.layer.cornerRadius = 0
            dateLabel.layer.borderColor = UIColor.clear.cgColor
            dateLabel.layer.borderWidth = 0
            dateLabel.layer.backgroundColor = UIColor.clear.cgColor
            dateLabel.layer.mask = nil
            dateLabel.textColor = UIColor.red
        } else if type.contains(.Today) {
            dateLabel.layer.cornerRadius = 20
            dateLabel.layer.borderColor = UIColor.orange.cgColor
            dateLabel.layer.borderWidth = 1
            dateLabel.layer.backgroundColor = UIColor.clear.cgColor
            dateLabel.layer.mask = nil
            dateLabel.textColor = UIColor.orange
        }else {
            dateLabel.layer.cornerRadius = 0
            dateLabel.layer.borderColor = UIColor.clear.cgColor
            dateLabel.layer.borderWidth = 0
            dateLabel.layer.backgroundColor = UIColor.clear.cgColor
            dateLabel.layer.mask = nil
            dateLabel.textColor = ThemeNavColor()
        }
        
        if type.contains(.SelectedStartDate){
            let side = self.bounds.size.width / 2
            let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: side, height: side))
            let shape = CAShapeLayer()
            shape.path = maskPath.cgPath
            highlightView.layer.mask = shape
            highlightView.backgroundColor = ThemeNavColor()
            
        }else if type.contains(.SelectedEndDate){
            highlightView.backgroundColor = UIColor.green
        }else if type.contains(.InBetweenDate){
            highlightView.backgroundColor = ThemeNavColor()
        }  else{
            highlightView.backgroundColor = UIColor.clear
        }
        
//        if type.contains(.Highlighted) {
//            highlightView.backgroundColor = UIColor.red
//            highlightView.layer.cornerRadius = frame.size.width / 2
//        } else {
//            highlightView.backgroundColor = UIColor.clear
//        }
    }
}

struct AirbnbDatePickerCellType: OptionSet {
    let rawValue: Int
    static let Date = AirbnbDatePickerCellType(rawValue: 1 << 0)                    // has number
    static let Empty = AirbnbDatePickerCellType(rawValue: 1 << 1)                   // has no number
    static let PastDate = AirbnbDatePickerCellType(rawValue: 1 << 2)                // disabled
    static let Today = AirbnbDatePickerCellType(rawValue: 1 << 3)                   // has circle
    static let Selected = AirbnbDatePickerCellType(rawValue: 1 << 4)                // has filled circle
    static let SelectedStartDate = AirbnbDatePickerCellType(rawValue: 1 << 5)       // has half filled circle on the left
    static let SelectedEndDate = AirbnbDatePickerCellType(rawValue: 1 << 6)         // has half filled circle on the right
    static let InBetweenDate = AirbnbDatePickerCellType(rawValue: 1 << 7)           // has filled square
    static let Highlighted = AirbnbDatePickerCellType(rawValue: 1 << 8)             // has
}
