import UIKit

//MARK: Public
@available(iOS 12.0, *)
public extension UIColor {
    static func style(_ color: Colors) -> UIColor {
        guard #available(iOS 13.0, *) else {
            return color.uiColor(for: .unspecified)
        }
        return color.dynamicColor
    }
}

@available(iOS 12.0, *)
public extension CGColor {
    static func style(_ color: Colors) -> CGColor {
        UIColor.style(color).cgColor
    }
}

//MARK: Private
private extension UIColor {
    convenience init(_ decimalRed: CGFloat, _ decimalGreen: CGFloat, _ decimalBlue: CGFloat, _ alpha: CGFloat = 1) {
        self.init(red: decimalRed / 255.0, green: decimalGreen / 255.0, blue: decimalBlue / 255.0, alpha: alpha)
    }
}

@available(iOS 12.0, *)
private extension Colors {
    func uiColor(for interfaceStyle: UIUserInterfaceStyle, highContrast: Bool = false) -> UIColor {
        switch (self, interfaceStyle, highContrast) {

        // MARK: Dark Palette
        case (.primaryText, .dark, _): return UIColor(240, 235, 230)
        case (.secondaryText, .dark, _): return UIColor(190, 180, 175)
        case (.accent, .dark, _): return UIColor(205, 3, 3)

        case (.primaryBackground, .dark, _): return UIColor(0, 0, 0)
        case (.secondaryBackground, .dark, _): return UIColor(35, 35, 33)

        // MARK: Light Palette
        case (.primaryText, _, _): return UIColor(42, 42, 42)
        case (.secondaryText, _, _): return UIColor(64, 64, 64)
        case (.accent, _, _): return UIColor(255, 53, 53)

        case (.primaryBackground, _, _): return UIColor(250, 250, 250)
        case (.secondaryBackground, _, _): return UIColor(255, 255, 255)
        }
    }

    @available(iOS 13.0, *)
    var dynamicColor: UIColor {
        return UIColor { traitCollection -> UIColor in
            return uiColor(
                for: traitCollection.userInterfaceStyle,
                highContrast: traitCollection.accessibilityContrast == .high
            )
        }
    }
}
