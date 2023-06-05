import Panda
import UIKit

public class PandaHUD1: UIView {
    /// 数据模型
    private var model = PandaHUDModel()
    /// 遮罩
    private lazy var pandaMaskView = PandaHUDMaskView()

    /// 内容显示容器
    private lazy var hudView: PandaHUDView = {
        let view = PandaHUDView()
            .pd_cornerRadius(4)
            .pd_masksToBounds(true)
        return view
    }()

    public static let shared = PandaHUD()
    override private init(frame: CGRect = .zero) {
        super.init(frame: frame)
        pandaMaskView.add2(self)
        hudView.add2(self)
    }

    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 显示/隐藏
public extension PandaHUD1 {}
