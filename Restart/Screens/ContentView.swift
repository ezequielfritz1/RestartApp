//
//  ContentView.swift
//  Restart
//
//  Created by Ezequiel Fritz on 10/6/22.
//

import SwiftUI

struct ContentView: View {
    private static let onboardingKey = "onboarding"

    // La primera vez que compila no encuentra el key "onboarding" entonces lo inicializa en true
    @AppStorage(Self.onboardingKey) private var isOnboardingViewActive = true

    var body: some View {
        ZStack {
            if isOnboardingViewActive {
                OnboardingView()
            } else {
                HomeView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
