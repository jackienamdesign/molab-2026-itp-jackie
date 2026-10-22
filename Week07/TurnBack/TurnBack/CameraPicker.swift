//
//  CameraPicker.swift
//  TurnBack - Week07 homework, Jackie Nam
//
//  Opens the camera inside the app. Same shape as PhotoPicker.swift in the
//  class sample 07-PhotoPickBlender: a UIKit view controller wrapped with
//  UIViewControllerRepresentable, and a Coordinator that hears back from it.
//
//  The differences from the sample:
//  - UIImagePickerController with sourceType .camera, instead of
//    PHPickerViewController. PHPicker can only pick from the library.
//  - The Coordinator is an NSObject. UIImagePickerController's delegate has
//    to be, PHPicker's doesn't.
//  - One photo comes back, so it's a UIImage? instead of an array.
//
//  The camera needs permission: NSCameraUsageDescription is set in the
//  target's Info settings. The simulator has no camera, so HeadingView only
//  shows the button on a real phone.
//

import SwiftUI

struct CameraPicker: UIViewControllerRepresentable {
  @Binding var image: UIImage?
  @Binding var isPresented: Bool

  func makeUIViewController(context: Context) -> some UIViewController {
    let picker = UIImagePickerController()
    picker.sourceType = .camera
    picker.delegate = context.coordinator
    return picker
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let parent: CameraPicker

    init(_ parent: CameraPicker) {
      self.parent = parent
    }

    // Called after Use Photo. The photo is in info under .originalImage.
    func imagePickerController(
      _ picker: UIImagePickerController,
      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
      if let newImage = info[.originalImage] as? UIImage {
        parent.image = newImage
      }
      parent.isPresented = false
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      parent.isPresented = false
    }
  }
}
