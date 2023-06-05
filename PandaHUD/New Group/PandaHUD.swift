import Panda
import UIKit

public class PandaHUD: NSObject {
    private var style = PandaHUDStyle()
    private static let shared = PandaHUD()
    override private init() { super.init() }
}

public extension PandaHUD {
    /// 在指定容器中是否有显示HUDView
    /// - Parameter view: HUDView所在容器
    /// - Returns: 是否有HUDView在显示
    static func isVisble(in view: UIView? = UIWindow.main) -> Bool {
        visbleHUDs(in: view).count > 0
    }

    /// 从指定容器中查询有哪些正在显示的HUDView
    /// - Parameters:
    ///   - view: 容器
    ///   - mode: 模式
    /// - Returns: HUDView数组
    private static func visbleHUDs(in view: UIView?, mode: PandaHUDMode? = nil) -> [PandaHUDView] {
        let result = (view?.subviews ?? []).filter { $0 is PandaHUDView }.map { $0 as! PandaHUDView }.filter(\.isVisble)
        if let mode {
            return result.filter { $0.data.mode == mode }
        }
        return result
    }
}

// MARK: - 便捷方法
public extension PandaHUD {
    /// 成功
    /// - Parameters:
    ///   - view: 容器
    ///   - status: 状态文字
    ///   - duration: 持续显示时间
    /// - Returns: PandaHUDView
    @discardableResult
    static func showSuccess(to view: UIView? = UIWindow.main, status: String?, duration: TimeInterval = 1.0) -> PandaHUDView {
        PandaHUDView.showHUD(to: view, mode: .success, status: status, duration: duration)
    }

    /// 错误
    /// - Parameters:
    ///   - view: 容器
    ///   - status: 状态文字
    ///   - duration: 持续显示时间
    /// - Returns: PandaHUDView
    @discardableResult
    static func showError(to view: UIView? = UIWindow.main, status: String?, duration: TimeInterval = 1.0) -> PandaHUDView {
        PandaHUDView.showHUD(to: view, mode: .error, status: status, duration: duration)
    }

    /// 信息
    /// - Parameters:
    ///   - view: 容器
    ///   - status: 状态文字
    ///   - duration: 持续显示时间
    /// - Returns: PandaHUDView
    @discardableResult
    static func showInfo(to view: UIView? = UIWindow.main, status: String?, duration: TimeInterval = 1.0) -> PandaHUDView {
        PandaHUDView.showHUD(to: view, mode: .info, status: status, duration: duration)
    }

    /// 文字
    /// - Parameters:
    ///   - view: 容器
    ///   - status: 状态文字
    ///   - duration: 持续显示时间
    /// - Returns: PandaHUDView
    @discardableResult
    static func showText(to view: UIView? = UIWindow.main, status: String?, duration: TimeInterval = 1.0) -> PandaHUDView {
        PandaHUDView.showHUD(to: view, mode: .text, status: status, duration: duration)
    }

    /// toast样式
    /// - Parameters:
    ///   - view: 容器
    ///   - duration: 持续显示时间
    /// - Returns: PandaHUDView
    @discardableResult
    static func showToast(with status: String?, duration: TimeInterval = 1.0) -> PandaHUDView {
        PandaHUDView.showHUD(to: UIWindow.main, mode: .toast, status: status, duration: duration)
    }

    /// 加载中
    /// - Parameters:
    ///   - view: 容器
    ///   - status: 状态文字
    /// - Returns: PandaHUDView
    @discardableResult
    static func showLoading(to view: UIView? = UIWindow.main, status: String?) -> PandaHUDView {
        PandaHUDView.showHUD(to: UIWindow.main, mode: .loading, status: status, duration: nil)
    }

    /// 进度
    /// - Parameters:
    ///   - view: 容器
    ///   - status: 状态文字
    ///   - progress: 进度值
    /// - Returns: PandaHUDView
    @discardableResult
    static func showProgress(to view: UIView? = UIWindow.main, status: String?, progress: CGFloat) -> PandaHUDView {
        let visbleHUD = visbleHUDs(in: view, mode: .progress).last
        if let visbleHUD {
            return visbleHUD.update(status: status, progress: progress)
        } else {
            return PandaHUDView.showHUD(to: UIWindow.main, mode: .progress, status: status, duration: nil)
        }
    }

    /// 隐藏指定容器中的HUDView
    /// - Parameter view: 容器
    static func hiddenHUD(for view: UIView?) {
        (view?.subviews ?? [])
            .filter { $0 is PandaHUDView }
            .map { $0 as! PandaHUDView }
            .filter(\.isVisble)
            .forEach { $0.hiddenHUD() }
    }
}

// MARK: - HUD设置
public extension PandaHUD {
    /// 设置样式
    static func setStyle(_ style: PandaHUDStyle) {
        PandaHUD.shared.style = style
    }

    /// 设置成功图片
    static func setSuccessImage(_ image: UIImage) {
        PandaHUD.shared.style.successImage = image
    }

    /// 设置错误图片
    static func setErrorImage(_ image: UIImage) {
        PandaHUD.shared.style.errorImage = image
    }

    /// 设置提示图片
    static func setInfoImage(_ image: UIImage) {
        PandaHUD.shared.style.infoImage = image
    }

    /// 设置状态文字字体
    static func setStatusFont(_ font: UIFont) {
        PandaHUD.shared.style.font = font
    }

    /// 设置前景颜色
    static func setForegroundColor(_ foregroundColor: UIColor) {
        PandaHUD.shared.style.foregroundColor = foregroundColor
    }

    /// 设置背景景颜色
    static func setBackgroundColor(_ backgroundColor: UIColor) {
        PandaHUD.shared.style.backgroundColor = backgroundColor
    }

    /// 设置是否显示遮盖
    static func setMaskVisible(_ maskVisible: Bool) {
        PandaHUD.shared.style.maskVisible = maskVisible
    }

    /// 设置遮盖颜色
    static func setMaskColor(_ maskColor: UIColor) {
        PandaHUD.shared.style.maskColor = maskColor
    }
}
