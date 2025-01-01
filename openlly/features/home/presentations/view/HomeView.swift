import SwiftUI

struct HomeView: View {
    @State private var profileModel: ProfileViewModel = profileViewModel
    @State private var currentTab = 0
    @StateObject private var viewModel: ForYouTabViewModel
    init() {
        _viewModel = StateObject(wrappedValue: forYouTabViewModel)
        // fetch messages from server after 0.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [homeView = self] in
            homeView.viewModel.getAnswers(forceReload: true)
        }
    }

    var body: some View {
        VStack {
            // Action Bar
            HomeAppBar(currentTab: currentTab, onTabChange: { tab in
                currentTab = tab
            }, unReadMessageCount: viewModel.unseenAnswerCount)
            if currentTab == 0 {
                ForYouTab(userAvatarImg: profileModel.user?.avatarImage ?? "")
            } else {
                MessageTab()
            }

        }.background(Color.white)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().preferredColorScheme(.dark)
    }
}
