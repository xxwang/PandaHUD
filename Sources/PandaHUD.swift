import Panda
import UIKit

public class PandaHUD: UIView {
    /// 数据模型
    private var model = PandaHUDModel()
    /// 遮罩
    private lazy var pandaMaskView = PandaHUDMaskView()

    /// 内容显示容器
    private lazy var pandaHUDView: PandaHUDView = {
        let view = PandaHUDView()
            .pd_cornerRadius(4)
            .pd_masksToBounds(true)
        return view
    }()

    public static let shared = PandaHUD()
    override private init(frame: CGRect = .zero) {
        super.init(frame: frame)
        pandaMaskView.add2(self)
        pandaHUDView.add2(self)
    }

    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 便捷方法
public extension PandaHUD {
    /// 成功
    static func showSuccess(with text: String? = nil, in view: UIView? = UIWindow.main, duration: TimeInterval = 1.0) {
        PandaHUD.setStatus(.success)
        show(with: text, in: view, duration: duration)
    }

    /// 错误
    static func showError(with text: String? = nil, in view: UIView? = UIWindow.main, duration: TimeInterval = 1.0) {
        PandaHUD.setStatus(.error)
        show(with: text, in: view, duration: duration)
    }

    /// 信息
    static func showInfo(with text: String? = nil, in view: UIView? = UIWindow.main, duration: TimeInterval = 1.0) {
        PandaHUD.setStatus(.info)
        show(with: text, in: view, duration: duration)
    }

    /// 文字
    static func showText(with text: String? = nil, in view: UIView? = UIWindow.main, duration: TimeInterval = 1.0) {
        PandaHUD.setStatus(.text)
        show(with: text, in: view, duration: duration)
    }

    /// toast样式
    static func showToast(with text: String? = nil, duration: TimeInterval = 1.0) {
        PandaHUD.setStatus(.toast)
        show(with: text, in: nil, duration: duration)
    }

    /// loading
    static func showLoading(with text: String? = nil, in view: UIView? = UIWindow.main) {
        PandaHUD.setStatus(.loading)
        show(with: text, in: view, duration: 0)
    }

    /// progress
    static func showProgress(with text: String? = nil, in view: UIView? = UIWindow.main, progress: CGFloat) {
        if isVisble(), PandaHUD.shared.model.status == .progress {
            // 处理字符串和进度值
        }
        PandaHUD.setStatus(.progress)
        show(with: text, in: view, duration: 0)
    }
}

// MARK: - 设置HUD样式
public extension PandaHUD {
    /// 设置成功图片
    static func setSuccessImage(_ image: UIImage) {
        PandaHUD.shared.model.successImage = image
    }

    /// 设置错误图片
    static func setErrorImage(_ image: UIImage) {
        PandaHUD.shared.model.errorImage = image
    }

    /// 设置提示图片
    static func setInfoImage(_ image: UIImage) {
        PandaHUD.shared.model.infoImage = image
    }

    /// 设置文字
    static func setText(_ text: String = "") {
        PandaHUD.shared.model.text = text
    }

    /// 设置文字字体
    static func setFont(_ font: UIFont) {
        PandaHUD.shared.model.font = font
    }

    /// 设置前景颜色
    static func setForegroundColor(_ foregroundColor: UIColor) {
        PandaHUD.shared.model.foregroundColor = foregroundColor
    }

    /// 设置背景景颜色
    static func setBackgroundColor(_ backgroundColor: UIColor) {
        PandaHUD.shared.model.backgroundColor = backgroundColor
    }

    /// 设置是否显示遮盖
    static func setMaskVisible(_ maskVisible: Bool) {
        PandaHUD.shared.model.maskVisible = maskVisible
    }

    /// 设置遮盖颜色
    static func setMaskColor(_ maskColor: UIColor) {
        PandaHUD.shared.model.maskColor = maskColor
    }

    /// 设置状态
    static func setStatus(_ status: PandaHUDStatus) {
        PandaHUD.shared.model.status = status
    }
}

private extension PandaHUD {
    /// 设置显示样式
    func prepareUI() {
        // 遮罩
        pandaMaskView.setup(model: model)
        // 内容容器
        pandaHUDView.setup(model: model)

        // 根据样式重新布局
        reloadLayout()

        // 设置透明
        alpha = 0.01
    }

    /// 重新布局
    func reloadLayout() {
        // HUD的整体frame
        frame = model.inView?.bounds ?? SizeUtils.screenBounds
        // 遮罩frame
        pandaMaskView.frame = bounds
        // 更新内容位置及尺寸
        pandaHUDView.layout()
    }
}

// MARK: - 显示/隐藏
public extension PandaHUD {
    /// 当前是否在显示
    static func isVisble() -> Bool {
        PandaHUD.shared.model.isVisble
    }

    /// 显示HUD
    static func show(with text: String?, in view: UIView?, duration: TimeInterval) {
        PandaHUD.shared.show(with: text, in: view, duration: duration)
    }

    /// 隐藏HUD
    static func dismiss(animated: Bool = true) {
        PandaHUD.shared.dismiss(animated: animated)
    }

    private func show(with text: String?, in view: UIView?, duration: TimeInterval) {
        model.text = text
        model.inView = view ?? UIWindow.main
        model.duration = duration

        // 如果当前正在显示,先隐藏再显示
        if model.isVisble {
            dismiss(animated: false)
        }

        // 设置整体样式
        prepareUI()

        // 添加HUD到指定view上
        if model.status == .toast {
            add2(UIWindow.main!)
        } else {
            add2(model.inView!)
        }

        // 动画显示
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        } completion: { isFinish in
            // 设置可见状态
            self.model.isVisble = true

            if self.model.status != .loading, self.model.status != .progress {
                // 开启定时器
                DispatchQueue.delay_execute(delay: self.model.duration) {
                    self.dismiss(animated: true)
                }
            }
        }
    }

    private func dismiss(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.25) {
                // 透明
                self.alpha = 0.01
            } completion: { isFinish in
                // 如果HUD正在window上,那么从window上移除
                if self.superview != nil {
                    self.removeFromSuperview()
                }
            }
        } else {
            // 透明
            alpha = 0.01
            // 如果HUD正在window上,那么从window上移除
            if superview != nil {
                removeFromSuperview()
            }
        }
        // 设置可见状态
        model.isVisble = false
    }
}
