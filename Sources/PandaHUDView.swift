//
//  PandaHUDView.swift
//
//
//  Created by 王斌 on 2023/5/31.
//

import UIKit
import Panda

class PandaHUDView: UIView {
    /// 数据模型
    var model: PandaHUDModel?
    /// 图标
    lazy var imageView = UIImageView.default().pd_contentMode(.scaleAspectFill)
    /// 文字
    lazy var textLabel = UILabel.default().pd_textAlignment(.center)

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.add2(self)
        textLabel.add2(self)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PandaHUDView {
    func setup(model: PandaHUDModel) {
        self.model = model

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
        backgroundColor = model.backgroundColor
        // 是否显示内容容器
        isHidden = textLabel.isHidden && imageView.isHidden
    }

    func layout() {
        guard let model else {return}
        
        // 边缘间距
        let edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        var contentWidth: CGFloat = 0
        var contentHeight: CGFloat = edgeInsets.top

        // 图片
        let imageSize = 50.toCGSize()
        if !imageView.isHidden {
            imageView.frame = CGRect(origin: CGPoint(x: 0, y: edgeInsets.top), size: imageSize)
            contentWidth = imageSize.width
            contentHeight += imageSize.height
        }

        // 文字
        if !textLabel.isHidden {
            contentHeight += (imageView.isHidden ? 0 : 10)
            let textSize = textLabel.textSize(SizeUtils.screenWidth)
            textSize.width > contentWidth ? contentWidth = textSize.width : ()
            textLabel.frame = CGRect(origin: CGPoint(x: 0, y: contentHeight), size: textSize)
            contentHeight += textSize.height
        }

        contentWidth += (edgeInsets.left + edgeInsets.right)
        contentHeight += edgeInsets.bottom
        contentHeight > contentWidth ? contentWidth = contentHeight : ()
        let contentSize = CGSize(width: contentWidth, height: contentHeight)

        // 设置容器尺寸及位置
        self.frame = CGRect(origin: .zero, size: contentSize)
        if model.status == .toast {
            self.pd_centerX(model.inView?.pd_middle.x ?? 0)
            self.pd_maxY(SizeUtils.screenHeight - (SizeUtils.indentHeight == 0
                                                   ? 20
                                                   : SizeUtils.indentHeight) - contentSize.height)
        } else {
            self.center = model.inView?.pd_middle ?? .zero
        }
        
        // 更新图片与文字的x坐标
        imageView.pd_centerX = pd_middle.x
        textLabel.pd_centerX = pd_middle.x
        
    }

}
