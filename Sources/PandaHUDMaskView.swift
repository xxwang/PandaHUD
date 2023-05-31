import Panda
import UIKit

class PandaHUDMaskView: UIView {
    /// 数据模型
    var model: PandaHUDModel?
    /// 背景渐变颜色
    var maskColor: UIColor?
    /// 背景渐变图层
    var background: CAGradientLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PandaHUDMaskView {
    func setup(model: PandaHUDModel) {
        self.model = model
        setupBackground()
        isHidden = !model.maskVisible
    }

    /// 绘制渐变图层
    func setupBackground() {
        guard let model else { return }
        background?.removeFromSuperlayer()

        // 镜像渐变
        let frame = model.inView?.bounds ?? SizeUtils.screenBounds
        background = CAGradientLayer(frame,
                                     colors: [model.maskColor.alpha(0.3),
                                              model.maskColor],
                                     locations: [0, 1],
                                     start: CGPoint(x: 0.5, y: 0.5),
                                     end: CGPoint(x: 1, y: 1),
                                     type: .radial)
        layer.addSublayer(background!)
    }
}
