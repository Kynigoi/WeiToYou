//
//  IntroView.swift
//  weitoyou
//
//  Created by Antonella Giugliano on 24/02/23.
//

import SwiftUI

struct IntroView: View {
    
    private var introTexts = [
        "An oriental legend tells that since birth each of us is linked to their soul mates by an invisible red thread.",
        "Stronger than adversity, this thread of fate will lead them to find each other sooner or later.",
        "An indestructible thread for an indissoluble bond.",
        "Connect your thread to keep in touch with your mate."
    ]
    
    @State private var currentTabItem = 0
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color("index"))
        UIPageControl.appearance().pageIndicatorTintColor = .tertiaryLabel
        UIPageControl.appearance().tintColor = .tertiaryLabel
    }
    
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                Image("knot_intro")
                    
                //                Spacer()
                TabView(selection: $currentTabItem) {
                    ForEach(0..<introTexts.count) { i in
                        Text(introTexts[i])
                            .kerning(0.41)
                            .lineSpacing(28)
                            .multilineTextAlignment(.center)
                            .fontWeight(.light)
                            .tag(i)
                    }
                    
                }.frame(height: ScreenSize.height * 0.35)
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    .padding([.horizontal, .bottom],25)
                
                Spacer()
                NavigationLink(destination: HandleYourIDView(), label: {
                    ZStack{
                    RoundedRectangle(cornerRadius: 13)
                            .frame(width: ScreenSize.width * 0.8, height: ScreenSize.height * 0.06)
                        .foregroundColor(Color.accentColor)
                        .shadow(color: .primary.opacity(0.15), radius: 2, x: 0, y: 8
                        )
                    Text("Continue")
                        .foregroundColor(Color("button"))
                }
                    .opacity(currentTabItem == introTexts.count - 1 ? 1.0 : 0.0)
                })
//                Spacer()
                
            }
            .navigationBarBackButtonHidden()
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
