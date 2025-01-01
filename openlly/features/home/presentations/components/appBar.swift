//
//  appBar.swift
//  openlly
//
//  Created by Mobin on 25/12/24.
//
import SwiftUI

struct HomeAppBar: View {
    let currentTab: Int
    let onTabChange: (Int) -> Void
    let impactGenerator = UIImpactFeedbackGenerator(style: .light)
    let unReadMessageCount: Int
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack {
            // Spacer to push the tabs into the center
            Spacer()

            // Center-aligned tabs
            HStack(spacing: 20) {
                Button(action: {
                    impactGenerator.impactOccurred()
                    onTabChange(0)
                }) {
                    HStack {
                        Text("For You")
                            .foregroundColor(currentTab == 0 ? .black : .gray)
                            .bold(currentTab == 0)
                    }
                }

                Button(action: {
                    impactGenerator.impactOccurred()
                    onTabChange(1)
                }) {
                    HStack {
                        if unReadMessageCount > 0 {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 10, height: 10)
                        }
                        Text("Message")
                            .foregroundColor(currentTab == 1 ? .black : .gray)
                            .bold(currentTab == 1)
                    }
                }
            }

            // Spacer to push the gear icon to the trailing edge
            Spacer()

            // Action button on the trailing edge
            NavigationLink(destination: SettingsView()
                .environmentObject(appState))
            {
                Image(systemName: "gear")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(8)
                    .foregroundColor(.black)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black.opacity(0.3), lineWidth: 1))
            }
            .padding(.trailing, 20)
        }
        .padding(.top)
        .background(Color.white)
    }
}
