//
//  PandaHUDView.swift
//  PandaHUD
//
//  Created by 王斌 on 2023/6/5.
//

import Panda
import UIKit

public class PandaHUDView: UIView {
    private var style: PandaHUDStyle?
    internal var data = PandaHUDData()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension PandaHUDView {
    /// 当前HUDView是否处理显示中
    var isVisble: Bool {
        superview != nil
    }

    /// 更新状态及进度值
    /// - Parameters:
    ///   - status: 状态文字
    ///   - progress: 进度值
    /// - Returns: PandaHUDView
    @discardableResult
    func update(status: String? = nil, progress: CGFloat? = nil) -> Self {
        if let status {
            data.status = status
        }

        if data.mode == .progress, progress != nil {
            data.progress = progress ?? 0
        }

        // 更新

        return self
    }
}

extension PandaHUD {
    /// 设置显示样式
    func prepareUI() {
        // 遮罩
        pandaMaskView.setup(model: model)
        // 内容容器
        hudView.setup(model: model)
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
        hudView.layout()
    }
}

extension PandaHUDView {
    /// 初始化PandaHUDView并添加到指定容器中
    /// - Parameters:
    ///   - view: 容器
    ///   - mode: 模式
    ///   - status: 状态文字
    ///   - duration: 持续显示时间
    static func showHUD(to view: UIView?, mode: PandaHUDMode, status: String?, duration: TimeInterval?) -> Self {
        // 初始化HUD
        let hud = PandaHUDView(frame: view?.bounds ?? SizeUtils.screenBounds)
        hud.data.inView = view
        hud.data.mode = mode
        hud.data.status = status
        hud.data.duration = duration ?? 0
        hud.add2(view!)

        // 显示HUD
        hud.show()
    }

    func show() {}

    func showHUD(to view: UIView?, status: String?, duration: TimeInterval) {
        model.text = text
        model.inView = view ?? UIWindow.main
        model.duration = duration

        // 如果当前正在显示,先隐藏再显示
        if model.isVisble {
            dismiss(animated: false)
        }

        // 设置整体样式
        prepareUI()

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

    func hiddenHUD(animated: Bool = true) {
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

extension PandaHUDView {
    /// 根据状态获取图片,并渲染成前景色
    func render_image() -> UIImage? {
        var image: UIImage?
        switch mode {
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
