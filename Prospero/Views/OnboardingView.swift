//
//  ContentView.swift
//  Prospero
//
//  Created by Zach Palumbo on 9/26/20.
//

import SwiftUI

struct OnboardingView: View {

    enum Step: Equatable {
        case preWelcome
        case welcome
        case addProduction
        case welcomeMember(UserProduction)
    }

    var onCompletion: (UserProduction) -> Void

    @State private var step = Step.preWelcome

    private let slowSpring = Animation.spring(response: 0.7, dampingFraction: 0.7)

    var body: some View {
        Group {
            switch step {
            case .preWelcome:
                EmptyView()
            case .welcome:
                Text("Welcome to Prospero")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .transition(.horizontalProgression)
            case .addProduction:
                AddProductionView(
                    stepAnimation: slowSpring,
                    onSuccess: { step = .welcomeMember($0) }
                )
                    .frame(maxWidth: .infinity)
                    .transition(.horizontalProgression)
            case .welcomeMember(let production):
                VStack {
                    Text("All set, \(production.member.name.formatted(.name(style: .short))) 🎉")
                        .font(.system(.title2, design: .rounded))
                        .padding(.bottom)
                    Button("Let's get started") { onCompletion(production) }
                        .font(.system(.subheadline, design: .rounded))
                }
                .transition(.opacity.animation(.easeInOut(duration: 2).delay(0.5)))
            }
        }
        .animation(slowSpring, value: step)
        .task {
            await Task.sleep(seconds: 0.5)
            step = .welcome
            await Task.sleep(seconds: 2)
            step = .addProduction
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(onCompletion: { print($0) })
    }
}
