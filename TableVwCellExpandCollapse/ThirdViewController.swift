//
//  ThirdViewController.swift
//  TableVwCellExpandCollapse
//
//  Created by MAC on 12/11/24.
//

import UIKit

class ThirdViewController: UIViewController {
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var lblData: UILabel!
    
    var secondText: String?
    var handler: ((String, Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        txtField.text = secondText
    }
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
            if let viewControllers = self.navigationController?.viewControllers {
                for vc in viewControllers {
                    if vc.isKind(of: ofClass) {
                        print("It is in stack")
                        self.navigationController?.popToViewController(vc, animated: animated)
                        return
                    }
                }
            }
        }
    
    @IBAction func btnClick(_ sender: UIButton) {
        handler?(txtField.text!, 28)
        popToViewController(ofClass: CodingTestViewController.classForCoder(), animated: true)
    }
}
