//
//  PandaHUD.swift
//  PandaHUD
//
//  Created by 王斌 on 2023/5/18.
//

import Panda
import UIKit

public class PandaHUD: UIView {
    fileprivate var model = PandaHUDModel()

    /// 遮罩
    lazy var backgroundView: UIView = {
        let view = UIView()
        return view
    }()

    /// 内容容器
    lazy var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()

    /// 图标
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    /// 文字
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    public static let shared = PandaHUD()

    override private init(frame: CGRect = .zero) {
        super.init(frame: frame)
        alpha = 0.01

        addSubview(backgroundView)
        addSubview(contentView)

        contentView.addSubview(imageView)
        contentView.addSubview(textLabel)
    }

    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置HUD样式
public extension PandaHUD {
    /// 当前是否在显示
    static func isVisble() -> Bool {
        PandaHUD.shared.model.isVisble
    }
}

// MARK: - 设置HUD样式
public extension PandaHUD {
    /// 设置成功图片
    static func setSuccessIamge(_ image: UIImage) {
        PandaHUD.shared.model.successImage = image
    }

    /// 设置错误图片
    static func setErrorIamge(_ image: UIImage) {
        PandaHUD.shared.model.errorImage = image
    }

    /// 设置信息图片
    static func setInfoIamge(_ image: UIImage) {
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
    static func setIsShowMaskView(_ isShowMaskView: Bool) {
        PandaHUD.shared.model.isShowMaskView = isShowMaskView
    }

    /// 设置遮盖颜色
    static func setMaskViewBackgroundColor(_ maskViewBackgroundColor: UIColor) {
        PandaHUD.shared.model.maskViewBackgroundColor = maskViewBackgroundColor
    }

    /// 设置状态
    static func setStatus(_ status: PandaHUDStatus) {
        PandaHUD.shared.model.status = status
    }
}

private extension PandaHUD {
    /// 设置显示样式
    func setup() {
        // 设置对应状态的图片
        imageView.image = model.render_image()
        // 如果没有对应图片,隐藏UIImageView
        imageView.isHidden = imageView.image == nil

        // 设置文字
        textLabel.text = model.text
        // 文字字体
        textLabel.font = model.font
        // 文字颜色
        textLabel.textColor = model.foregroundColor
        // 如果文字为空, 隐藏Label
        textLabel.isHidden = model.text == nil

        // 内容容器背景色
        contentView.backgroundColor = model.backgroundColor

        // 是否显示遮罩
        backgroundView.isHidden = !model.isShowMaskView
        // 遮罩背景色
        backgroundView.backgroundColor = model.maskViewBackgroundColor

        // 是否显示内容容器
        contentView.isHidden = textLabel.isHidden && imageView.isHidden
    }

    /// 重新布局
    func reloadLayout() {
        // HUD的整体frame
        frame = model.inView?.bounds ?? .zero
        // 遮罩frame
        backgroundView.frame = bounds

        // 间距
        let margin: CGFloat = 10
        // 顶部间距
        var top: CGFloat = margin
        // 图片Size
        let imageSize = 46.toCGSize()

        if !imageView.isHidden {
            imageView.frame = CGRect(origin: CGPoint(x: 0, y: top), size: imageSize)
            top += imageSize.height
        }

        // 容器宽度
        var contentWidth: CGFloat = imageSize.width + margin * 2
        if !textLabel.isHidden {
            // 与图标之间的间距
            let topMargin: CGFloat = (imageView.isHidden ? 0 : margin)
            // 文字尺寸
            let textSize = textLabel.textSize()
            // 计算容器宽度
            textSize.width > contentWidth ? contentWidth = (textSize.width + margin * 2) : ()

            textLabel.frame = CGRect(origin: CGPoint(x: 0, y: top + topMargin), size: textSize)
            top += (textSize.height + topMargin)
        }

        // 容器高度
        let contentHeight: CGFloat = top + margin
        // 如果容器高度大于容器的宽度, 就调整为一样(为了显示美观)
        contentHeight > contentWidth ? contentWidth = contentHeight : ()

        // 设置容器尺寸
        contentView.frame = CGRect(center: backgroundView.center, size: CGSize(width: contentWidth, height: contentHeight))

        // 更新图片与文字的x坐标
        imageView.pd_centerX = contentView.pd_width / 2
        textLabel.pd_centerX = contentView.pd_width / 2
    }
}

// MARK: - 定时器
private extension PandaHUD {
    /// 开启定时器
    func startTimer() {
        model.timer = Timer(timeInterval: model.duration, repeats: false, forMode: .common, block: { [weak self] tm in
            self?.stopTimer()
        })
    }

    /// 关闭定时器
    @objc func stopTimer() {
        model.timer?.invalidate()
        model.timer = nil
        dismiss(animated: true)
    }
}

// MARK: - 操作方法
public extension PandaHUD {
    /// 显示HUD
    static func show(with text: String?, in view: UIView?, duration: TimeInterval) {
        PandaHUD.shared.model.text = text
        PandaHUD.shared.model.inView = view
        PandaHUD.shared.model.duration = duration
        PandaHUD.shared.show()
    }

    private func show() {
        // 如果当前正在显示,先隐藏再显示
        if model.isVisble {
            dismiss(animated: false)
        }

        // 设置整体样式
        setup()

        // 根据样式重新布局
        reloadLayout()

        // 添加HUD到当前的Window上
        UIWindow.main?.addSubview(self)

        // 动画显示
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        } completion: { isFinish in
            // 设置可见状态
            self.model.isVisble = true

            // 开启定时器
            self.startTimer()
        }
    }

    /// 隐藏HUD
    static func dismiss() {
        PandaHUD.shared.dismiss(animated: true)
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
}
