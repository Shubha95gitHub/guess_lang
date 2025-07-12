//
//  CodingTestViewController.swift
//  TableVwCellExpandCollapse
//
//  Created by MAC on 12/11/24.
//

import UIKit

class CodingTestViewController: UIViewController {
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var lblData: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        let secondVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        secondVC.firstData = txtField.text
        secondVC.dataHandler = { data, age in
            self.lblData.text = data + " \(age)"
        }
        navigationController?.pushViewController(secondVC, animated: true)
    }

}
