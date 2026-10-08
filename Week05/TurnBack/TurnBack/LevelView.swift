/*
See the License.txt file for this sample’s licensing information.
*/

// Copied from the class sample 05-BubbleLevel.
// Only change: start() / stop() were taken out, because BrowseView starts and
// stops the detector for the whole app the way SeismometerBrowser does. Leaving
// them in here stopped the sensor every time I navigated back to the list.

import SwiftUI

struct LevelView: View {
  @Environment(MotionDetector.self) var motionDetector: MotionDetector

  var body: some View {
    VStack {
      Text("Hold the phone flat to read a heading")
        .font(.title3)
        .multilineTextAlignment(.center)
        .padding()

      BubbleLevel()

      OrientationDataView()
        .padding(.top, 80)
    }
    .navigationTitle("Level")
  }
}

#Preview {
  LevelView()
    .environment(MotionDetector(updateInterval: 0.1).started())
}
