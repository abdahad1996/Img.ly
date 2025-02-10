import Foundation
import SwiftUI

public struct MiscellaneousTokens: MiscellaneousTokensProvider {
    public let cornerRadius: CornerRadiusesProvider = CornerRadiuses()
    public let opacity: OpacitiesProvider = Opacities()
    public let asset: AssetNamesProvider = AssetNames()
}

public struct MiscellaneousTokensAlternative: MiscellaneousTokensProvider {
    public let cornerRadius: CornerRadiusesProvider =
        CornerRadiusesAlternative()
    public let opacity: OpacitiesProvider = OpacitiesAlternative()
    public let asset: AssetNamesProvider = AssetNamesAlternative()
}

public protocol MiscellaneousTokensProvider {
    var cornerRadius: CornerRadiusesProvider { get }
    var opacity: OpacitiesProvider { get }
    var asset: AssetNamesProvider { get }
}

// MARK: CornerRadius

public struct CornerRadiuses: CornerRadiusesProvider {
    public let card: Double = 32
    public let button: Double = 100
}

public struct CornerRadiusesAlternative: CornerRadiusesProvider {
    public let card: Double = 4
    public let button: Double = 4
}

public protocol CornerRadiusesProvider {
    var card: Double { get }
    var button: Double { get }
}

// MARK: Opacity

public struct Opacities: OpacitiesProvider {
    public let cardDetails: Double = 0.6
}

public struct OpacitiesAlternative: OpacitiesProvider {
    public let cardDetails: Double = 1
}

public protocol OpacitiesProvider {
    var cardDetails: Double { get }
}

// MARK: Asset

public struct AssetNames: AssetNamesProvider {
    public let cardBackground = "img2"
}

public struct AssetNamesAlternative: AssetNamesProvider {
    public let cardBackground = "img1"
}

public protocol AssetNamesProvider {
    var cardBackground: String { get }
}
