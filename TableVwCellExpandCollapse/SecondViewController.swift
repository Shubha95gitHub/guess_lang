//
//  SecondViewController.swift
//  TableVwCellExpandCollapse
//
//  Created by MAC on 12/11/24.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var lblData: UILabel!
    
    var firstData: String?
    var dataHandler: ((String, Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        txtField.text = firstData
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        if txtField.text == "" {
            print("Enter something")
        } else {
            let thirdVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ThirdViewController") as! ThirdViewController
            thirdVC.secondText = txtField.text
            thirdVC.handler = dataHandler
            self.navigationController?.pushViewController(thirdVC, animated: true)
        }
    }
}
