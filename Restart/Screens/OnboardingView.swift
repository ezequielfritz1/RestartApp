//
//  OnboardingView.swift
//  Restart
//
//  Created by Ezequiel Fritz on 10/6/22.
//

class TextTitleModel: ObservableObject {
    @Published var value = "Share."
}

import SwiftUI
import Combine

struct OnboardingView: View {
    // Esto no cambia el valor. Solo accede a la key "onboarding", pero si no la encuentra, si la inicializa en true
    @AppStorage("onboarding") private var isOnboardingViewActive = true
    @State private var isAnimating: Bool = false
    @StateObject private var textTitle: TextTitleModel = .init()

    var body: some View {
        ZStack {
            Color("ColorBlue")
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                OnboardingHeaderView(isAnimating: isAnimating).environmentObject(textTitle)

                OnboardingCenterView(isAnimating: isAnimating).environmentObject(textTitle)

                Spacer()
                OnboardingFooterView(onChevronItem: {
                    isOnboardingViewActive = false
                }, isAnimating: isAnimating)
            }
        }
        .onAppear {
            isAnimating = true
        }
        .preferredColorScheme(.dark)
    }
}

fileprivate struct OnboardingHeaderView: View {
    let isAnimating: Bool
    @EnvironmentObject private var textTitle: TextTitleModel

    var body: some View {
        VStack(spacing: 0) {
            Text(textTitle.value)
                .font(.system(size: 40))
                .foregroundColor(.white)
                .fontWeight(.heavy)
                .transition(.opacity)
                .id(textTitle.value)

            Text("""
            It's not how much we give but
            how much love we put into giving.
            """)
            .foregroundColor(.white)
            .font(.title3)
            .fontWeight(.light)
            .multilineTextAlignment(.center)
        }
        .opacity(isAnimating ? 1 : 0)
        .offset(y: isAnimating ? 0 : -40)
        .animation(.easeOut(duration: 1), value: isAnimating)
    }
}

fileprivate struct OnboardingCenterView: View {
    let isAnimating: Bool
    @EnvironmentObject private var textTitle: TextTitleModel
    @State private var imageOffset: CGSize = .zero
    @State private var indicatorOpacity: Double = 1

    var body: some View {
        ZStack {
            CircleGroupView(shapeColor: .white, shapeOpacity: 0.2)
                .offset(x: imageOffset.width * -1)
                .blur(radius: abs(imageOffset.width / 5))
                .animation(.easeOut(duration: 1), value: imageOffset)

            Image("character-1")
                .resizable()
                .scaledToFit()
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : -40)
                .animation(.easeOut(duration: 1), value: isAnimating)
                .offset(x: imageOffset.width * 1.2, y: 0)
                .rotationEffect(.degrees(Double(imageOffset.width / 20)))
                .gesture(
                    DragGesture()
                        .onChanged {
                            if abs(imageOffset.width) <= 150 {
                                imageOffset = $0.translation
                                withAnimation(.linear(duration: 0.25)) {
                                    indicatorOpacity = 0
                                    textTitle.value = "Give."
                                }
                            }
                        }
                        .onEnded { _ in
                            imageOffset = .zero
                            withAnimation(.linear(duration: 0.25)) {
                                indicatorOpacity = 1
                                textTitle.value = "Share."
                            }
                        }
                )
                .animation(.easeOut(duration: 1), value: imageOffset)
        }
        .overlay(
            Image(systemName: "arrow.left.and.right.circle")
                .font(.system(size: 44, weight: .ultraLight))
                .foregroundColor(.white)
                .offset(y: 20)
                .opacity(isAnimating ? 1 : 0)
                .animation(.easeOut(duration: 1).delay(2), value: isAnimating)
                .opacity(indicatorOpacity)
            , alignment: .bottom
        )
    }
}

fileprivate struct OnboardingFooterView: View {
    let onChevronItem: (() -> Void)
    let isAnimating: Bool
    private let audioPlayer = AudioPlayer()
    private let hapticFeedback = UINotificationFeedbackGenerator()

    @State private var buttonOffset: Double = 0
    @State private var buttonWidth: Double = UIScreen.main.bounds.width - 80

    var body: some View {
        ZStack {
            Capsule()
                .fill(.white.opacity(0.2))
            Capsule()
                .fill(.white.opacity(0.2))
                .padding(8)

            HStack {
                Capsule()
                    .fill(Color("ColorRed"))
                    .frame(width: buttonOffset + 80, alignment: .center)
                Spacer()
            }

            Text("Get Started")
                .font(.system(.title3, design: .rounded))
                .foregroundColor(.white)
                .fontWeight(.bold)

            HStack {
                ZStack {
                    Circle()
                        .fill(Color("ColorRed"))
                    Circle()
                        .fill(.black.opacity(0.15))
                        .padding(8)
                    Image(systemName: "chevron.right.2")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .bold))
                }
                .frame(width: 80, height: 80, alignment: .center)
                .offset(x: buttonOffset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if gesture.translation.width > 0 && buttonOffset <= buttonWidth - 80 {
                                buttonOffset = gesture.translation.width
                            }
                        }
                        .onEnded { _ in
                            withAnimation(Animation.easeOut(duration: 0.4)) {
                                if buttonOffset > buttonWidth / 2 {
                                    hapticFeedback.notificationOccurred(.success)
                                    audioPlayer.playSound(sound: "chimeup", type: "mp3")
                                    buttonOffset = buttonWidth - 80
                                    onChevronItem()
                                } else {
                                    hapticFeedback.notificationOccurred(.warning)
                                    buttonOffset = 0
                                }
                            }
                        }
                )

                Spacer()
            }
        }
        .frame(width: buttonWidth, height: 80, alignment: .center)
        .padding()
        .opacity(isAnimating ? 1 : 0)
        .offset(y: isAnimating ? 0 : 40)
        .animation(.easeOut(duration: 1), value: isAnimating)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
