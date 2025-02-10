//
//  RetryButton.swift
//  SwiftHeroes
//
//  Created by macbook abdul on 24/03/2024.
//

import Foundation
import SwiftUI

public struct RetryButton: View {
    let text: String
    let designLibrary: DesignLibraryProvider
    let onTap: () -> Void

    public var body: some View {
        VStack {
            Text(text)
                .foregroundColor(designLibrary.color.text.standard)

            Button(action: onTap) {
                HStack {
                    Image("duck")
                        .renderingMode(.template)
                        .foregroundColor(designLibrary.color.icon.buttonPrimary)

                    Text("Retry...")
                        .foregroundColor(designLibrary.color.text.buttonPrimary)
                        .font(designLibrary.font.buttonFont.standard)
                }
                .frame(width: 150, height: 40)
                .background(designLibrary.color.background.buttonPrimary)
                .cornerRadius(designLibrary.miscellaneous.cornerRadius.button)
            }
        }
    }
}
