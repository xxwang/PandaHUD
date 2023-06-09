//
//  PandaHUD.swift
//  PandaHUD
//
//  Created by 王斌 on 2023/6/9.
//

import UIKit

class PandaHUD: NSObject {

    fileprivate struct Constants {
        static let sharedHUD = PandaHUD()
    }
    
    open class var sharedHUD: PandaHUD {
        return Constants.sharedHUD
    }
    
    public override init() {
        super.init()
    }
}
