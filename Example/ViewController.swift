//
//  ViewController.swift
//  Example
//
//  Created by 王斌 on 2023/6/3.
//

import Panda
import PandaHUD
import UIKit

class ViewController: UIViewController {
    let backView = UIView.default().pd_frame(CGRect(origin: .zero, size: 100.toCGSize()))
    var animationLayer: CALayer?
    var isAnimation: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        backView.add2(view)
        backView.center = view.pd_middle
    }
}

extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        draw()
        if isAnimation {
            stopAnimation()
        } else {
            startAnimation()
        }
    }

    func startAnimation() {
        animationLayer?.baseBasicAnimation(
            keyPath: "transform.rotation.z",
            startValue: nil,
            endValue: 360.degreesAsRadians(),
            duration: 1,
            delay: 0,
            repeatCount: HUGE,
            removedOnCompletion: false,
            option: .linear
        )

        isAnimation = true
    }

    func stopAnimation() {
        animationLayer?.removeAllAnimations()
        isAnimation = false
    }

    func draw() {
        // 防止重复添加
        if animationLayer?.superlayer != nil {
            return
        }

        let lineWidth: CGFloat = 4
        let lineMargin: CGFloat = 4
        var radius = backView.pd_middle.x - lineWidth * 0.5

        let mutablePath = CGMutablePath.default()
        for _ in 0 ..< 5 {
            radius -= (lineWidth + lineMargin)
            let bezierPath = UIBezierPath(
                arcCenter: backView.pd_middle,
                radius: radius,
                startAngle: 0.degreesAsRadians(),
                endAngle: 340.degreesAsRadians(),
                clockwise: true
            )
            mutablePath.addPath(bezierPath.cgPath)
        }

        let animationLayer = CALayer.default()
            .pd_frame(backView.bounds)

        let gradientLayer = CAGradientLayer(
            backView.bounds,
            colors: [.clear, UIColor.black],
            locations: [0, 0.95],
            start: CGPoint(x: 1, y: 0.5),
            end: CGPoint(x: 0.5, y: 0),
            type: .conic
        )

        // 形状图层
        let shapeLayer = CAShapeLayer.default()
            .pd_frame(backView.bounds)
            .pd_path(mutablePath)
            .pd_shouldRasterize(true)
            .pd_rasterizationScale(UIScreen.main.scale)
            .pd_lineWidth(lineWidth)
            .pd_strokeColor(.green)
            .pd_fillColor(.clear)
            .pd_lineCap(.round)

        animationLayer.addSublayer(gradientLayer)
        animationLayer.addSublayer(shapeLayer)
        animationLayer.mask = shapeLayer

        animationLayer.anchorPoint = 0.5.toCGPoint()
        self.animationLayer = animationLayer

        backView.layer.addSublayer(animationLayer)
    }
}
