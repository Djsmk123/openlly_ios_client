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
                // Skeleton Loading State
                if viewModel.answerLoading {
                    MessageTabLoadingView()
                }
                // Error or Empty State
                else if !viewModel.answerError.isEmpty {
                    MessageTabErrorState(onTapRetry: {
                        viewModel.getAnswers(forceReload: true)
                    })
                }
                // Empty state if no answers
                else if viewModel.answers.isEmpty {
                    MessageTabEmptyView()
                }
                // Main message list view
                else {
                    MessageListView(
                        answers: viewModel.answers,

                        onTap: { index in
                            let answer = viewModel.answers[index]
                            viewModel.markAsSeenOneMessage(answer: answer)

                            // Present a detail or reply view
                            viewModel.presentReplyView(for: answer)
                        }
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            // Wait for a delay before loading data
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                viewModel.loadData()
            }
        }
        .refreshable {
            // Directly call the loadData function for refresh
            viewModel.loadData(forceReload: true)
        }
        .preferredColorScheme(.light) // Set default theme to light
    }
}

extension ForYouTabViewModel {
    // Centralize data loading logic in the ViewModel
    func loadData(forceReload: Bool = false) {
        getAnswers(forceReload: forceReload)
    }
}

#Preview {
    MessageTab()
}
