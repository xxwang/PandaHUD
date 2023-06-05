//
//  PandaHUDData.swift
//  PandaHUD
//
//  Created by 王斌 on 2023/6/5.
//

import UIKit

class PandaHUDData {
    /// 显示在哪个view
    var inView: UIView? = UIWindow.main
    /// HUD 模式
    var mode: PandaHUDMode = .text
    /// 状态文字
    var status: String?
    /// 进度值
    var progress: CGFloat = 0
    /// 显示持续时长
    var duration: TimeInterval = 1.5
}
