//
//  RZDatePickerFlowLayout.swift
//  RuZu
//
//  Created by Nero on 09/07/2017.
//  Copyright © 2017 Nero. All rights reserved.
//

import UIKit

class RZDatePickerFlowLayout: UICollectionViewFlowLayout {
    let cellSpacing:CGFloat = 0
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attributes = super.layoutAttributesForElements(in: rect) {
            for (index, attribute) in attributes.enumerated() {
                if index == 0 { continue }
                let prevLayoutAttributes = attributes[index - 1]
                let origin = prevLayoutAttributes.frame.maxX
                if origin + cellSpacing + attribute.frame.size.width < self.collectionViewContentSize.width {
                    attribute.frame.origin.x = origin + cellSpacing
                }
            }
            return attributes
        }
        return nil
    }
}
