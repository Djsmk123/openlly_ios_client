import SwiftUI

struct MessageTab: View {
    @StateObject private var viewModel: ForYouTabViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: forYouTabViewModel)
    }
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea() // Ensure the background color fills the entire screen

            VStack(spacing: 0) {
                if viewModel.answerLoading {
                    // Skeleton Shimmer Effect for Loading State
                    MessageTabLoadingView()
                } else if viewModel.answers.isEmpty {
                    // Show Error or Empty State Based on API Response
                    if viewModel.answerError != nil {
                        MessageTabErrorState(onTapRetry: {
                            viewModel.getAnswers(forceReload: true)
                        })
                    } else {
                        MessageTabEmptyView()
                    }
                } else {
                    // Show the List of Messages
                    MessageListView(
                        answers: viewModel.answers,
                        onRefresh: {
                            viewModel.getAnswers(forceReload: true)
                        },
                        onTap: { index in
                            let answer = viewModel.answers[index]
                            viewModel.markAsSeenOneMessage(answer: answer)
                            
                            // Present a detail or reply view
                            Task {
                                viewModel.presentReplyView(for: answer)
                            }
                        }
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand VStack to full screen
        }
        .onAppear {
            viewModel.objectWillChange.send()
            Task {
                viewModel.getAnswers()
            }
        }
        .preferredColorScheme(.light) // Set default theme to light
    }
}

#Preview {
    MessageTab()
}
