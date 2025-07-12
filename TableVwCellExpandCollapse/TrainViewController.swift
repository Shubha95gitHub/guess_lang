//
//  TrainViewController.swift
//  TableVwCellExpandCollapse
//
//  Created by MAC on 28/11/24.
//

import UIKit
import SDWebImage
import AVKit

class TrainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionVw: UICollectionView!
    @IBOutlet weak var reverseCollectionVw: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    
    var arrText = ["Jeet da", "Shubha", "Dip", "Avinash", "Rahul"]
    var arrReverseText = ["Jeet da", "Shubha", "Dip", "Avinash", "Rahul"]
    var infiniteData: [String] = []
    var infiniteReverseData: [String] = []
    var timer: Timer?
    var centerCell: TrainCollectionViewCell?
//    var currentIndex = 0
    let numberOfItems = 100
    let carouselItems = [("1", UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
                         ("2", UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
                         ("3", UIColor(red: 0, green: 0, blue: 1, alpha: 1))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create infinite data by duplicating original data
//        infiniteData = Array(repeating: arrText, count: 100).flatMap { $0 }
//        infiniteReverseData = Array(repeating: arrReverseText, count: 100).flatMap { $0 }
//        collectionVw.delegate = self
//        collectionVw.dataSource = self
        reverseCollectionVw.delegate = self
        reverseCollectionVw.dataSource = self
        
//        if let videoID = extractYouTubeID(from: "https://www.youtube.com/watch?v=YkFsf-vaLkI") {
//            let thumbnailURL = "https://img.youtube.com/vi/\(videoID)/hqdefault.jpg"
//            imageView.sd_setImage(with: URL(string: thumbnailURL))
//        }
//        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playYouTubeVideo))
//        imageView.isUserInteractionEnabled = true
//        imageView.addGestureRecognizer(tapGesture)
//        
//        DispatchQueue.main.async {
//            let middleIndex = self.arrText.count
//            self.collectionVw.scrollToItem(at: IndexPath(item: middleIndex, section: 0), at: .centeredHorizontally, animated: false)
//            let middleReverseIndex = self.arrReverseText.count
//            self.reverseCollectionVw.scrollToItem(at: IndexPath(item: middleReverseIndex, section: 0), at: .centeredHorizontally, animated: false)
//            self.startAutoScroll()
//        }
    }
    
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        self.present(playerVC, animated: true) {
            player.play()
        }
    }
    
    @objc func playYouTubeVideo() {
        if let videoURL = URL(string: "https://www.youtube.com/watch?v=YkFsf-vaLkI") {
            UIApplication.shared.open(videoURL)
        }
    }
    
    func startAutoScroll() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(reverseAutoScroll), userInfo: nil, repeats: true)
    }
    
    @objc func autoScroll() {
            let contentOffset = collectionVw.contentOffset
            let newOffset = CGPoint(x: contentOffset.x + 1, y: contentOffset.y)
        collectionVw.setContentOffset(newOffset, animated: false)
            
            // Handle resetting to simulate infinite scrolling
            let totalWidth = collectionVw.contentSize.width
            let middleOffset = CGFloat(infiniteData.count / 2) * 110 // Cell width + spacing
            
            if newOffset.x >= totalWidth - collectionVw.bounds.width {
                collectionVw.setContentOffset(CGPoint(x: middleOffset, y: contentOffset.y), animated: false)
            } else if newOffset.x <= 0 {
                collectionVw.setContentOffset(CGPoint(x: middleOffset, y: contentOffset.y), animated: false)
            }
        }
    
    func extractYouTubeID(from url: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: "((?<=(v=)|(/v/)|(/embed/)|(/youtu.be/)|(/shorts/))[\\w-]{11})") else { return nil }
        let range = NSRange(location: 0, length: url.count)
        let result = regex.firstMatch(in: url, options: [], range: range)
        return result.map { String(url[Range($0.range, in: url)!]) }
    }
    
    @objc func reverseAutoScroll() {
            let contentOffset = reverseCollectionVw.contentOffset
            let newOffset = CGPoint(x: contentOffset.x - 1, y: contentOffset.y) // Move left to right
        reverseCollectionVw.setContentOffset(newOffset, animated: false)
            
            // Handle resetting to simulate infinite scrolling
            let totalWidth = reverseCollectionVw.contentSize.width
            let middleOffset = CGFloat(infiniteReverseData.count / 2) * 110 // Cell width + spacing
            
            if newOffset.x <= 0 {
                reverseCollectionVw.setContentOffset(CGPoint(x: middleOffset, y: contentOffset.y), animated: false)
            } else if newOffset.x >= totalWidth - reverseCollectionVw.bounds.width {
                reverseCollectionVw.setContentOffset(CGPoint(x: middleOffset, y: contentOffset.y), animated: false)
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == collectionVw {
//            return infiniteData.count
//        } else {
            return arrReverseText.count
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == collectionVw {
//            let cell = collectionVw.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TrainCollectionViewCell
//            cell.lblName.text = infiniteData[indexPath.item % arrText.count]
//            return cell
//        } else {
            let cell = reverseCollectionVw.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ReverseCollectionViewCell
            cell.lblTextName.text = arrReverseText[indexPath.item]
            return cell
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == collectionVw {
//            let widthSize = (collectionVw.frame.size.width) / 2
//            let heightSize = collectionVw.frame.size.height - 10
//            return(CGSize(width: widthSize, height: heightSize))
//        } else {
            let widthSize = (reverseCollectionVw.frame.size.width) / 2
            let heightSize = reverseCollectionVw.frame.size.height - 10
            return(CGSize(width: widthSize, height: heightSize))
//        }
        
    }
}

