//
//  ViewController.swift
//  TableVwCellExpandCollapse
//
//  Created by MAC on 07/11/24.
//

import UIKit

struct Section {
    let title: String
    let content: String
}

class ViewController: UIViewController {
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var tableVw: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var isOpened = false
    
    var sections = [
        Section(title: "Description", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
        Section(title: "Redeem Instructions", content: "HPCL believes in fueling happiness through their myriad products. Starting from energy required to cook food to running cars, HPCL offers seamless and trustable energy solutions to millions in India on an everyday basis. Be it the food we eat, the ironed clothes we put on, or the cosmetics we beautify ourselves with, there is a touch of HP in everything. HPCL invests not only in offering energy in all sectors of life but also focuses on the preservation of nature and the environment. HPCL emphasizes the health and safety of consumers and conducts several welfare and safety workshops and events.HPCL Petro Card Gift Vouchers are one of the ways in which you can benefit while consuming HPCL energy. This card helps in getting a myriad of discounts on several occasions."),
        Section(title: "Terms & Conditions", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
    ]
    
    var expandedSections: [Bool] = [true, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableVw.delegate = self
        tableVw.dataSource = self
        navView.backgroundColor = UIColor(hex: "#3498db")
        tableVw.isScrollEnabled = false
        tableVw.register(TVCell.self, forCellReuseIdentifier: "cell")
        tableVw.rowHeight = UITableView.automaticDimension
        tableVw.estimatedRowHeight = 44
        tableVw.reloadData()
        adjustTableViewHeight()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustTableViewHeight()
    }
    
    func adjustTableViewHeight() {
        tableVw.layoutIfNeeded() // Ensures layout is up to date
        tableViewHeightConstraint.constant = tableVw.contentSize.height + 20
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expandedSections[section] ? 1 : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableVw.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TVCell
        cell.selectionStyle = .none
        cell.contentLabel.text = sections[indexPath.section].content
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //        let header = UILabel()
        
        let header = UIView()
        header.backgroundColor = .white  // Optional background color for the header
        
        // Create and configure the header label
        let headerLabel = UILabel()
        headerLabel.text = sections[section].title
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Create and configure the arrow image view
        let arrowImageView = UIImageView()
        let arrowImage = expandedSections[section] ? UIImage(systemName: "arrow.up") : UIImage(systemName: "arrow.down")
        arrowImageView.image = arrowImage
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the label and image view to the header view
        header.addSubview(headerLabel)
        header.addSubview(arrowImageView)
        
        // Add constraints to align headerLabel to the left and arrowImageView to the right
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 20),
            headerLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -20),
            arrowImageView.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        header.isUserInteractionEnabled = true
        header.tag = section
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapHeader(_:)))
        header.addGestureRecognizer(tapGesture)
        return header
    }
    
    @objc func didTapHeader(_ gesture: UITapGestureRecognizer) {
        guard let section = gesture.view?.tag else { return }
        expandedSections[section].toggle()
        tableVw.reloadSections([section], with: .automatic)
        adjustTableViewHeight()
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
