//
//  SplashScreen.swift
//  SwiftHeroes
//
//  Created by macbook abdul on 25/03/2024.
//

import Foundation
import SwiftUI

struct SplashScreen: View {
	@State private var scale = 0.5
	@Binding var isActive: Bool
	var body: some View {
		VStack {
			VStack {
				Image("logo")
					.resizable()
					.frame(width: 100, height: 100)
					.font(.system(size: 100))
					.foregroundColor(.blue)
					.clipShape(Circle())
					.overlay(Circle().stroke(Color.white, lineWidth: 2)) // Add a white stroke around the circle
					.shadow(radius: 3)
			}.scaleEffect(scale)
				.onAppear {
					withAnimation(.easeIn(duration: 0.7)) {
						self.scale = 0.9
					}
				}
		}.onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
				withAnimation {
					self.isActive = true
				}
			}
		}
	}
}
