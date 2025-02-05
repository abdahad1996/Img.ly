import Foundation
import SwiftUI

public struct FontTokens: FontTokensProvider {
  public let cardFont: CardFontProvider = CardFont()
  public let buttonFont: ButtonFontProvider = ButtonFont()
}

public struct FontTokensAlternative: FontTokensProvider {
  public let cardFont: CardFontProvider = CardFontAlternative()
  public let buttonFont: ButtonFontProvider = ButtonFontAlternative()
}

public protocol FontTokensProvider {
  var cardFont: CardFontProvider { get }
  var buttonFont: ButtonFontProvider { get }
}

// MARK: Card

public struct CardFont: CardFontProvider {
  public let title = Font.custom(CustomFont.heptaSlabBold.rawValue, size: 36)
  public let body = Font.custom(CustomFont.spaceGroteskRegular.rawValue, size: 16)
  public let price = Font.custom(CustomFont.heptaSlabBold.rawValue, size: 24)
}

public struct CardFontAlternative: CardFontProvider {
  public let title = Font.custom(CustomFont.playfairDisplayBold.rawValue, size: 36)
  public let body = Font.custom(CustomFont.ralewayRegular.rawValue, size: 16)
  public let price = Font.custom(CustomFont.playfairDisplayBold.rawValue, size: 24)
}

public protocol CardFontProvider {
  var title: Font { get }
  var body: Font { get }
  var price: Font { get }
}

// MARK: Button

public struct ButtonFont: ButtonFontProvider {
  public let standard = Font.custom(CustomFont.spaceGroteskBold.rawValue, size: 16)
}

public struct ButtonFontAlternative: ButtonFontProvider {
  public let standard = Font.custom(CustomFont.ralewayBold.rawValue, size: 16)
}

public protocol ButtonFontProvider {
  var standard: Font { get }
}
