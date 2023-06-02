//
//  AnimationView.swift
//
//
//  Created by 王斌 on 2023/6/1.
//

import UIKit

class PandaAnimationView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - loading
extension PandaAnimationView {
    /// 开始动画
    func startAnimation() {
        
    }
    
    /// 停止动画
    func stopAnimation() {
        
    }
    
    func drawShape() {
        
    }
}

//MARK: - progress
extension PandaAnimationView {
    
}
