//
//  PandaHUDView.swift
//
//
//  Created by 王斌 on 2023/5/31.
//

import Panda
import UIKit

/// 图片大小
let kImageSize = 50.toCGSize()

class PandaHUDView1: UIView {
    /// 数据模型
    var model: PandaHUDModel?
    /// 图标
    lazy var animationView = PandaAnimationView(frame: CGRect(origin: .zero, size: kImageSize))
        .pd_contentMode(.scaleAspectFill)
    /// 文字
    lazy var tipLabel = UILabel.default().pd_textAlignment(.center)

    override init(frame: CGRect) {
        super.init(frame: frame)

        animationView.add2(self)
        tipLabel.add2(self)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PandaHUDView1 {
    func setup(model: PandaHUDModel) {
        self.model = model

        // 如果没有对应图片,隐藏UIanimationView
        animationView.isHidden = model.render_image() == nil
        // 设置对应状态的图片
        animationView.image = model.render_image()

        // 如果文字为空, 隐藏Label
        tipLabel.isHidden = model.text == nil || model.text == ""
        // 设置文字
        tipLabel.text = model.text
        // 文字字体
        tipLabel.font = model.font
        // 文字颜色
        tipLabel.textColor = model.foregroundColor

        // 内容容器背景色
        backgroundColor = model.backgroundColor
        // 是否显示内容容器
        isHidden = tipLabel.isHidden && animationView.isHidden
    }

    func layout() {
        guard let model else { return }

        // 边缘间距
        let edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        var contentWidth: CGFloat = 0
        var contentHeight: CGFloat = edgeInsets.top

        // 图片
        if !animationView.isHidden {
            animationView.frame = CGRect(origin: CGPoint(x: 0, y: edgeInsets.top), size: kImageSize)
            contentWidth = kImageSize.width
            contentHeight += kImageSize.height
        }

        // 文字
        if !tipLabel.isHidden {
            contentHeight += (animationView.isHidden ? 0 : 10)
            let textSize = tipLabel.textSize(SizeUtils.screenWidth)
            textSize.width > contentWidth ? contentWidth = textSize.width : ()
            tipLabel.frame = CGRect(origin: CGPoint(x: 0, y: contentHeight), size: textSize)
            contentHeight += textSize.height
        }

        contentWidth += (edgeInsets.left + edgeInsets.right)
        contentHeight += edgeInsets.bottom
        contentHeight > contentWidth ? contentWidth = contentHeight : ()
        let contentSize = CGSize(width: contentWidth, height: contentHeight)

        // 设置容器尺寸及位置
        frame = CGRect(origin: .zero, size: contentSize)
        if model.status == .toast {
            pd_centerX(model.inView?.pd_middle.x ?? 0)
            pd_maxY(SizeUtils.screenHeight - (SizeUtils.indentHeight == 0
                    ? 20
                    : SizeUtils.indentHeight) - contentSize.height)
        } else {
            center = model.inView?.pd_middle ?? .zero
        }

        // 更新图片与文字的x坐标
        animationView.pd_centerX = pd_middle.x
        tipLabel.pd_centerX = pd_middle.x
    }
}
