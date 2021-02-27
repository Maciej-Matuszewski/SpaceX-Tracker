import UIKit

@available(iOS 10.0, *)
public extension UIFont {
    static func style(_ font: Fonts, shouldSupportResizing: Bool = true) -> UIFont {
        let traitCollection: UITraitCollection? = shouldSupportResizing ? nil : .init(preferredContentSizeCategory: .large)
        switch font {
        case .body: return .preferredFont(forTextStyle: .body, compatibleWith: traitCollection)
        case .button: return .preferredFont(forTextStyle: .callout, compatibleWith: traitCollection)
        case .footnote: return .preferredFont(forTextStyle: .footnote, compatibleWith: traitCollection)
        case .subtitle: return .preferredFont(forTextStyle: .title3, compatibleWith: traitCollection)
        case .title: return .preferredFont(forTextStyle: .title1, compatibleWith: traitCollection)
        }
    }
}
