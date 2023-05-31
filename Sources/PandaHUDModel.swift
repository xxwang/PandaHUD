import UIKit

public class PandaHUDModel {
    /// 显示在哪个view
    var inView: UIView? = UIWindow.main
    /// 显示的持续时长定时器
    var timer: Timer?
    /// 当前是否在显示
    var isVisble: Bool = false
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
    var font: UIFont = .systemFont(ofSize: 14)
    /// 前景色
    var foregroundColor: UIColor = .white
    /// 背景色
    var backgroundColor: UIColor = .black.alpha(0.8)
    /// 是否显示遮罩
    var maskVisible: Bool = true
    /// 遮罩背景色
    var maskColor: UIColor = .black.alpha(0.25)
    /// 显示持续时长
    var duration: TimeInterval = 1.5
}

public extension PandaHUDModel {
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
        default:
            break
        }
        return image?.withTintColor(foregroundColor, renderingMode: .alwaysOriginal)
    }
}
