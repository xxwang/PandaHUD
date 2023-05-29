//
//  PandaHUDStyle.swift
//  panda-todo
//
//  Created by 王斌 on 2023/5/18.
//

import UIKit

/// HUD状态
public enum PandaHUDStatus {
    /// 成功
    case success
    /// 错误
    case error
    /// 信息
    case info
    /// 文字
    case text
}

public class PandaHUDViewModel {
    /// 显示的持续时长定时器
    var timer: Timer?
    /// 当前是否在显示
    var isVisble: Bool = false

    /// 显示在哪个view
    var inView: UIView?

    /// HUD状态
    var status: PandaHUDStatus = .text

    /// 成功图片
    var successImage: UIImage? = UIImage(systemName: "checkmark.circle")
    /// 失败图片
    var errorImage: UIImage? = UIImage(systemName: "xmark.circle")
    /// 信息图片
    var infoImage: UIImage? = UIImage(systemName: "info.circle")

    /// 文字
    var text: String?
    /// 字体
    var font: UIFont = .systemFont(ofSize: 13)

    /// 前景色
    var foregroundColor: UIColor = .white
    /// 背景色
    var backgroundColor: UIColor = .black.alpha(0.8)

    /// 是否显示遮罩
    var isShowMaskView: Bool = true
    /// 遮罩背景色
    var maskViewBackgroundColor: UIColor = .black.alpha(0.25)
    /// 显示持续时长
    var duration: TimeInterval = 1.5
}

public extension PandaHUDViewModel {
    /// 根据状态获取图片,并渲染成前景色
    func render_image() -> UIImage? {
        var image: UIImage?
        switch status {
        case .success:
            image = successImage
        case .error:
            image = errorImage
        case .info:
            image = infoImage
        case .text:
            break
        }
        return image?.withTintColor(foregroundColor, renderingMode: .alwaysOriginal)
    }
}
