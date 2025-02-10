import Foundation

public struct DesignLibrary: DesignLibraryProvider {
    public init() {}
    public let color: ColorTokensProvider = ColorTokens()
    public let font: FontTokensProvider = FontTokens()
    public let miscellaneous: MiscellaneousTokensProvider =
        MiscellaneousTokens()
}

public struct DesignLibraryAlternative: DesignLibraryProvider {
    public let color: ColorTokensProvider = ColorTokensAlternative()
    public let font: FontTokensProvider = FontTokensAlternative()
    public let miscellaneous: MiscellaneousTokensProvider =
        MiscellaneousTokensAlternative()
}

public protocol DesignLibraryProvider {
    var color: ColorTokensProvider { get }
    var font: FontTokensProvider { get }
    var miscellaneous: MiscellaneousTokensProvider { get }
}
