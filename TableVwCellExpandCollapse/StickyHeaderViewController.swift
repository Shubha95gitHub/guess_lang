//
//  StickyHeaderViewController.swift
//  TableVwCellExpandCollapse
//
//  Created by MAC on 16/12/24.
//

import UIKit

class StickyHeaderViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var collectionVw: UICollectionView!
    @IBOutlet weak var scrollVw: UIScrollView!
    @IBOutlet weak var heiightCollectionvw: NSLayoutConstraint!
    @IBOutlet weak var stickyVw: UIView!
    
    var arr = ["splashOne", "splashThree", "splashFour", "splashfive", "splashSix", "splashOne", "splashThree", "splashFour", "splashfive", "splashSix", "splashOne", "splashThree", "splashFour", "splashfive", "splashSix", "splashOne", "splashThree", "splashFour", "splashfive", "splashSix", "splashOne", "splashThree", "splashFour", "splashfive", "splashSix", "splashOne", "splashThree", "splashFour", "splashfive", "splashSix"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionVw.delegate = self
        collectionVw.dataSource = self
        scrollVw.delegate = self
        stickyVw.isHidden = true
    }
    
    // MARK: - UIScrollViewDelegate
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
         // Track only the outer scrollView
         if scrollView == self.scrollVw {
             let offsetY = scrollVw.contentOffset.y
             let contentHeight = scrollVw.contentSize.height
             let visibleHeight = scrollVw.frame.size.height
             
             // Avoid division by zero
             guard contentHeight > visibleHeight else { return }
             
             // Calculate scroll percentage
             let scrollPercentage = (offsetY / (contentHeight - visibleHeight)) * 100
             print("Scroll Percentage: \(Int(scrollPercentage))%")
             
             if Int(scrollPercentage) > 16 {
                 print("Scrolled to 16%!")
                 stickyVw.isHidden = false
             } else {
                 stickyVw.isHidden = true
             }
         }
     }

}

extension StickyHeaderViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionVw.dequeueReusableCell(withReuseIdentifier: "testcell", for: indexPath) as! ReverseCollectionViewCell
        cell.imageVw.image = UIImage(named: arr[indexPath.item])
        cell.imageVw.layer.borderColor = UIColor.black.cgColor
        cell.imageVw.layer.borderWidth = 1
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthSize = (collectionVw.frame.size.width - 15) / 3
        let heightSize = widthSize * 1.25
        return CGSize(width: widthSize, height: heightSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        heiightCollectionvw.constant = collectionVw.contentSize.height
    }
}
