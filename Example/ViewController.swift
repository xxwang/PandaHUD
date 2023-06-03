//
//  ViewController.swift
//  Example
//
//  Created by 王斌 on 2023/6/3.
//

import UIKit
import PandaHUD

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        PandaHUD.showLoading(with: "123...")
        PandaHUD.showToast(with: "123123123123")
    }
}

