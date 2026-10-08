//
// AboutView.swift
// Page 3. What the app is.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Image(systemName: "leaf.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .foregroundStyle(.green)
                .padding()

            Text("Minute Garden")
                .font(.largeTitle)

            Text("A one minute timer. Press Start and a plant grows every 10 seconds, with birds playing underneath. A chime rings at zero.")
                .multilineTextAlignment(.center)
                .padding()

        }
        .padding()
    }
}

#Preview {
    AboutView()
}
