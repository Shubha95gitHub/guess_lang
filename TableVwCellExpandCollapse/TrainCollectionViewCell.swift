//
//  TrainCollectionViewCell.swift
//  TableVwCellExpandCollapse
//
//  Created by MAC on 28/11/24.
//

import UIKit

class TrainCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblName: UILabel!
    
    func transformToLarge(){
        UIView.animate(withDuration: 0.2){
          self.transform = CGAffineTransform(scaleX: 1.07, y: 1.07)
        }
      }
      
      func transformToStandard(){
        UIView.animate(withDuration: 0.2){
          self.transform = CGAffineTransform.identity
        }
      }
}
