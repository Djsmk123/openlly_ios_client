import SwiftUI

struct ForYouTab: View {
    let userAvatarImg: String
    let impactGenerator = UIImpactFeedbackGenerator(style: .light)
    @StateObject private var viewModel: ForYouTabViewModel

    init(userAvatarImg: String) {
        _viewModel = StateObject(wrappedValue: forYouTabViewModel)
        self.userAvatarImg = userAvatarImg
    }

    var body: some View {
        VStack {
            if viewModel.loading {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(0 ..< 5, id: \.self) { _ in
                            QuestionCardSkeleton()
                                .frame(width: UIScreen.main.bounds.width * 0.8, height: 250)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            } else if viewModel.questions.isEmpty && !viewModel.error.isEmpty {
                Text(viewModel.error)
                    .foregroundColor(.red)
            } else {
                TabView(selection: $viewModel.currentIndex) {
                    ForEach(viewModel.questions.indices, id: \.self) { index in
                        QuestionCard(
                            question: viewModel.questions[index],
                            cardWidth: UIScreen.main.bounds.width * 0.8,
                            onTap: { _ in },
                            userAvatar: userAvatarImg
                        )
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 250)
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 250)
                .onChange(of: viewModel.currentIndex, initial: true) {
                    impactGenerator.impactOccurred()
                }
            }

            Spacer()
                .frame(height: 20)
            if !viewModel.loading && viewModel.questions.count > 0 {
                PageDots(count: viewModel.questions.count, activeIndex: viewModel.currentIndex)
            }

            Spacer()

            if !viewModel.loading && viewModel.questions.count > viewModel.currentIndex {
                HomeBottomView(question: viewModel.questions[viewModel.currentIndex])
            }
        }
        .padding(.horizontal, 20)
        .onAppear {
            withAnimation {
                viewModel.getQuestions()
            }
        }
    }
}

struct QuestionCardSkeleton: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.gray.opacity(0.2))
            .shimmerAnimation()
    }
}

extension View {
    func shimmerAnimation() -> some View {
        modifier(ShimmerModifier())
    }
}

struct ShimmerModifier: ViewModifier {
    @State private var offset = -UIScreen.main.bounds.width

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.clear, .white.opacity(0.4), .clear]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * 2)
                        .offset(x: offset)
                        .animation(
                            Animation.linear(duration: 1.5)
                                .repeatForever(autoreverses: false),
                            value: offset
                        )
                }
            )
            .onAppear {
                offset = UIScreen.main.bounds.width
            }
    }
}
