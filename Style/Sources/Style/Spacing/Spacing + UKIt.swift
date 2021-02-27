import UIKit

public extension CGFloat {
    static func style(_ spacing: Spacing) -> CGFloat {
        switch spacing {
        case .xl: return 24
        case .l: return 16
        case .m: return 8
        case .s: return 4
        }
    }

    static func style(iconSize: IconsSize) -> CGFloat {
        switch iconSize {
        case .large: return 64
        case .medium: return 44
        case .small: return 24
        }
    }
}

public extension UIEdgeInsets {
    static func style(_ spacing: Spacing) -> UIEdgeInsets {
        .init(top: .style(spacing), left: .style(spacing), bottom: .style(spacing), right: .style(spacing))
    }
}
