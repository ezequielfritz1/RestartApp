//
//  HomeView.swift
//  Restart
//
//  Created by Ezequiel Fritz on 10/6/22.
//

import SwiftUI

struct HomeView: View {
    // Esto no cambia el valor. Solo accede a la key "onboarding", pero si no la encuentra, si la inicializa en false
    @AppStorage("onboarding") private var isOnboardingViewActive = false
    @State private var isAnimating: Bool = false
    private let audioPlayer = AudioPlayer()

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Spacer()

                HomeHeaderView(isAnimating: isAnimating)

                HomeCenterView()

                Spacer()

                HomeFooterView {
                    withAnimation {
                        audioPlayer.playSound(sound: "success", type: "m4a")
                        isOnboardingViewActive = true
                    }
                }
            }
            .onAppear {
                isAnimating = true
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

fileprivate struct HomeHeaderView: View {
    let isAnimating: Bool

    var body: some View {
        ZStack {
            CircleGroupView(shapeColor: .gray, shapeOpacity: 0.1)
            Image("character-2")
                .resizable()
                .scaledToFit()
                .padding()
                .offset(y: isAnimating ? 35 : -35)
                .animation(
                    Animation.easeIn(duration: 4)
                        .repeatForever()
                , value: isAnimating)
        }
    }
}

fileprivate struct HomeCenterView: View {
    var body: some View {
        Text("""
        The time that leads to mastery is
        dependent on the intensity of our focus.
        """)
        .multilineTextAlignment(.center)
        .foregroundColor(.gray)
        .font(.title3)
        .padding()
    }
}

fileprivate struct HomeFooterView: View {
    let onRestart: (() -> Void)
    var body: some View {
        Button {
            onRestart()
        } label: {
            Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                .imageScale(.large)
            Text("Restart")
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .controlSize(.large)
    }
}
