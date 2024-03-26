import Foundation
import SwiftUI
import Core

struct CardView: View {
    let designLibrary: DesignLibraryProvider
    let leaf: LeafNode
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(designLibrary.miscellaneous.asset.cardBackground)
                .mask {
                    RoundedRectangle(
                        cornerRadius: designLibrary.miscellaneous.cornerRadius.card,
                        style: .continuous
                    )
                }
            
            VStack {
                HStack {
                    
                    
                    Spacer()
                    
                    Image("clover")
                        .renderingMode(.template)
                        .padding(.top)
                        .padding(.trailing)
                        .foregroundColor(designLibrary.color.icon.promo)
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        
                        
                        Text(leaf.description)
                            .minimumScaleFactor(0.5)
                            .font(designLibrary.font.cardFont.body)
                            .foregroundColor(designLibrary.color.text.standard)
                            .padding(.leading, 10)
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    
                }
                .frame(height: 112)
                .background(
                    designLibrary.color.background.cardDetails.opacity(
                        designLibrary.miscellaneous.opacity.cardDetails
                    )
                )
                .clipShape(RoundedCorner(
                    radius: designLibrary.miscellaneous.cornerRadius.card,
                    corners: [.bottomLeft, .bottomRight])
                )
            }
        }
        .frame(width: 358, height: 450)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CardView(designLibrary: DesignLibrary(), leaf:StubbedReponses.buildLeafNode())
}
