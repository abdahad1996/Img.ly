import Foundation
import SwiftUI

public struct ColorTokens: ColorTokensProvider {
  public let icon: IconColorsProvider = IconColors()
  public let text: TextColorsProvider = TextColors()
  public let background: BackgroundColorsProvider = BackgroundColors()
}

public struct ColorTokensAlternative: ColorTokensProvider {
  public let icon: IconColorsProvider = IconColorsAlternative()
  public let text: TextColorsProvider = TextColorsAlternative()
  public let background: BackgroundColorsProvider = BackgroundColorsAlternative()
}

public protocol ColorTokensProvider {
  var icon: IconColorsProvider { get }
  var text: TextColorsProvider { get }
  var background: BackgroundColorsProvider { get }
}

// MARK: Icon

public struct IconColors: IconColorsProvider {
  public let promo: Color
  public let buttonPrimary: Color

  init(baseColors: BaseColorsProvider = BaseColors()) {
    self.promo = baseColors.brandPrimary
    self.buttonPrimary = baseColors.dark
  }
}

public struct IconColorsAlternative: IconColorsProvider {
  public let buttonPrimary: Color
  public let promo: Color

  init(baseColors: BaseColorsProvider = BaseColorsAlternative()) {
    self.buttonPrimary = baseColors.brandSecondary
    self.promo = baseColors.brandSecondary
  }
}

public protocol IconColorsProvider {
  var buttonPrimary: Color { get }
  var promo: Color { get }
}

// MARK: Text

public struct TextColors: TextColorsProvider {
  public let standard: Color
  public let buttonPrimary: Color

  init(baseColors: BaseColorsProvider = BaseColors()) {
    self.standard = baseColors.white
    self.buttonPrimary = baseColors.dark
  }
}

public struct TextColorsAlternative: TextColorsProvider {
  public let standard: Color
  public let buttonPrimary: Color

  init(baseColors: BaseColorsProvider = BaseColorsAlternative()) {
    self.standard = baseColors.dark
    self.buttonPrimary = baseColors.white
  }
}

public protocol TextColorsProvider {
  var standard: Color { get }
  var buttonPrimary: Color { get }
}

// MARK: Background

public struct BackgroundColors: BackgroundColorsProvider {
  public var cell: Color
  public let cardDetails: Color
  public let buttonPrimary: Color

  init(baseColors: BaseColorsProvider = BaseColors()) {
    self.cardDetails = baseColors.black
    self.buttonPrimary = baseColors.brandPrimary
    self.cell = baseColors.dark
  }
}

public struct BackgroundColorsAlternative: BackgroundColorsProvider {
  public var cell: Color
  public let cardDetails: Color
  public let buttonPrimary: Color

  init(baseColors: BaseColorsProvider = BaseColorsAlternative()) {
    self.cardDetails = baseColors.cream
    self.buttonPrimary = baseColors.brandPrimary
    self.cell = baseColors.brandSecondary
  }
}

public protocol BackgroundColorsProvider {
  var cardDetails: Color { get }
  var buttonPrimary: Color { get }
  var cell: Color { get }
}
