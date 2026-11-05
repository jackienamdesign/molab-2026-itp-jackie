/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct MainView: View {
    
    @Environment(LobbyModel.self) var lobbyModel
    
    @Environment(AppModel.self) var app
    
    var body: some View {
        // Week09: TabView from 03-About-Me, Match and Floor are my new tabs
        TabView {
            MatchView()
                .tabItem {
                    Label("Match", systemImage: "checklist")
                }
            FloorView()
                .tabItem {
                    Label("Floor", systemImage: "person.3.fill")
                }
            settingsView()
                .tabItem {
                    Label("Info", systemImage: "info.circle")
                }
        }
        .onAppear {
            print("MainView onAppear currentUser", lobbyModel.currentUser?.email ?? "-none-")
        }
    }

    func settingsView() -> some View {
        Group {
            if lobbyModel.currentUser == nil {
                LoginView()
            }
            else {
                LobbyView()
            }
        }
    }
}

// navigation with app.path

// NavigationStack(path: $app.path) {

// NavigationLink(value: "gallery") {
//    Label("Media Gallery", systemImage: "photo.stack.fill")
//        .font(.system(size: 36, weight: .bold))
//        .foregroundColor(.white)
// }

//    .navigationDestination(for: String.self) { dest in
//        if dest == "gallery" {
//            GalleryView(galleryModel: app.galleryModel)
//        }
//        else {

