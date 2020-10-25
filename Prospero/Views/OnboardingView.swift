//
//  ContentView.swift
//  Prospero
//
//  Created by Zach Palumbo on 9/26/20.
//

import SwiftUI

struct OnboardingView: View {

    enum Step {
        case preWelcome
        case welcome
        case confirmProduction(Production)
        case welcomeMember(Production, Production.Member)
    }

    var onCompletion: (Production) -> Void = { _ in }

    @State private var step = Step.preWelcome

    // Just used to animate in code entry with a delay during the Welcome step.
    @State private var isCodeEntryShowing = false

    var body: some View {
        Group {
            switch step {
            case .preWelcome: Group {}
            case .welcome:
                VStack {
                    Text("Welcome to Prospero")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.semibold)
                        .padding()

                    if isCodeEntryShowing {
                        ProductionCodeEntryView(
                            onCompletion: { step = .confirmProduction($0) }
                        )
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
                        isCodeEntryShowing = true
                    }
                }
                .transition(.horizontalProgression)
            case .confirmProduction(let production):
                VStack {
                    MemberConfirmationView(
                        production: production,
                        onCompletion: { step = .welcomeMember(production, $0) }
                    )
                    .padding(.bottom)
                    Button("This is not my production") { step = .welcome }
                        .font(.system(.footnote, design: .rounded))
                }
                .transition(.horizontalProgression)
            case .welcomeMember(let production, let member):
                VStack {
                    Text("All set, \(member.person.name.first) 🎉")
                        .font(.system(.title2, design: .rounded))
                        .padding(.bottom)
                    Button("Let's get started") { onCompletion(production) }
                        .font(.system(.subheadline, design: .rounded))
                }
                .transition(AnyTransition.opacity.animation(
                    Animation.easeInOut(duration: 2).delay(0.5)
                ))
            }
        }
        .animation(.spring(response: 0.7, dampingFraction: 0.7))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                step = .welcome
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
