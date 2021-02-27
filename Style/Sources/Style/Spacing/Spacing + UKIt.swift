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
}
