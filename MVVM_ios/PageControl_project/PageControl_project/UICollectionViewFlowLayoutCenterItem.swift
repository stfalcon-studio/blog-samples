//
//  UICollectionViewFlowLayoutCenterItem.swift
//  Keepsnap
//
//  Created by Victor Amelin on 2/28/16.
//  Copyright © 2016 Victor Amelin. All rights reserved.
//

import UIKit

class UICollectionViewFlowLayoutCenterItem: UICollectionViewFlowLayout {
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        if let cv = self.collectionView {

            let cvBounds = cv.bounds
            let halfWidth = cvBounds.size.width * 0.5;
            let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth;

            if let attributesForVisibleCells = self.layoutAttributesForElementsInRect(cvBounds) {

                var candidateAttributes : UICollectionViewLayoutAttributes?
                for attributes in attributesForVisibleCells {

                    if attributes.representedElementCategory != UICollectionElementCategory.Cell {
                        continue
                    }
                    if let candAttrs = candidateAttributes {
                        let a = attributes.center.x - proposedContentOffsetCenterX
                        let b = candAttrs.center.x - proposedContentOffsetCenterX
                        if fabsf(Float(a)) < fabsf(Float(b)) {
                            candidateAttributes = attributes;
                        }
                        
                    } else {
                        candidateAttributes = attributes;
                        continue;
                    }
                }
                
                return CGPoint(x: round(candidateAttributes!.center.x - halfWidth), y: proposedContentOffset.y)
            }
        }
        
        return super.targetContentOffsetForProposedContentOffset(proposedContentOffset)
    }
}




