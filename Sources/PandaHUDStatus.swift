import Foundation

/// HUD状态
public enum PandaHUDStatus {
    case success // 成功
    case error // 错误
    case info // 信息
    case text // 文字
    case toast // 底部弹出文字提示
    case loading // 加载中
    case progress // 进度
}
