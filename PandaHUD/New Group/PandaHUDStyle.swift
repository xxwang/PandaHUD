import UIKit

public class PandaHUDStyle {
    /// 是否显示遮罩
    var maskVisible: Bool = true

    /// 成功图片
    var successImage: UIImage? = UIImage(systemName: "checkmark.circle")
    /// 失败图片
    var errorImage: UIImage? = UIImage(systemName: "xmark.circle")
    /// 信息图片
    var infoImage: UIImage? = UIImage(systemName: "info.circle")

    /// 字体
    var font: UIFont = .systemFont(ofSize: 14)
    /// 前景色
    var foregroundColor: UIColor = .white
    /// 背景色
    var backgroundColor: UIColor = .black.alpha(0.8)
    /// 遮罩背景色
    var maskColor: UIColor = .black.alpha(0.25)
}
