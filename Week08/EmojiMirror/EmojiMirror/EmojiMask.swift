//
//  EmojiMask.swift
//  EmojiMirror - Week08 homework, Jackie Nam
//
//  My own part of the app. Two jobs:
//  1. pickEmoji - look at the face ARKit sees and pick the emoji that matches
//  2. makeEmojiImages - draw each emoji into a picture, so FaceViewAR can
//     stick it on the face
//
//  The sample 07-FaceMeshUI only reads smile and blink. ARKit reports about
//  50 of these "blend shapes" for every frame, each a number from 0 to 1.
//  I added two more: jawOpen (mouth open) and tongueOut.
//

import ARKit
import UIKit

// Every emoji the mask can be, and how to get it. The two arrays line up -
// maskHints[i] says how to make maskEmojis[i] - like emojis and labels in
// TurnBack's HeadingView.
let maskEmojis = ["🙂", "😊", "😉", "😌", "😮", "😂", "😛"]
let maskHints = ["Neutral", "Smile", "Wink", "Close your eyes", "Open your mouth",
                 "Smile with your mouth open", "Stick out your tongue"]

// The order of the ifs matters: the first one that matches wins.
// - Tongue out comes first, because sticking out your tongue opens your mouth too
// - Laughing (smile + open mouth) comes before plain open mouth
// - Both eyes closed comes before one eye closed
// 0.5 is the sample's smileThreshold / blinkThreshold. The mouth only has to
// be a little open (0.3) - a laugh doesn't open it very far.
//
// nonisolated, like the renderer functions in FaceViewAR, because it is
// called from there, on SceneKit's drawing thread, as well as from FaceTracker.
nonisolated func pickEmoji(_ blendShapes: [ARFaceAnchor.BlendShapeLocation: NSNumber]) -> String {
  let smileL = blendShapes[.mouthSmileLeft]?.floatValue ?? 0
  let smileR = blendShapes[.mouthSmileRight]?.floatValue ?? 0
  let smile = (smileL + smileR) / 2
  let blinkLeft = blendShapes[.eyeBlinkLeft]?.floatValue ?? 0
  let blinkRight = blendShapes[.eyeBlinkRight]?.floatValue ?? 0
  let jawOpen = blendShapes[.jawOpen]?.floatValue ?? 0
  let tongueOut = blendShapes[.tongueOut]?.floatValue ?? 0

  if tongueOut > 0.5 {
    return "😛"
  }
  if smile > 0.5 && jawOpen > 0.3 {
    return "😂"
  }
  if jawOpen > 0.3 {
    return "😮"
  }
  if blinkLeft > 0.5 && blinkRight > 0.5 {
    return "😌"
  }
  if blinkLeft > 0.5 || blinkRight > 0.5 {
    return "😉"
  }
  if smile > 0.5 {
    return "😊"
  }
  return "🙂"
}

// Draws one emoji into a picture with a see-through background.
// Same UIGraphicsImageRenderer + NSAttributedString draw(at:) as my Week02
// "ascii image" page, minus the white fill - leaving the background empty is
// what makes it see-through.
func emojiImage(_ emoji: String) -> UIImage {
  let size = 256.0
  let font = UIFont.systemFont(ofSize: 200)
  let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
  return renderer.image { context in
    let str = NSAttributedString(string: emoji, attributes: [.font: font])
    // Center it: half the space left over on each side
    let x = (size - str.size().width) / 2
    let y = (size - str.size().height) / 2
    str.draw(at: CGPoint(x: x, y: y))
  }
}

// All the pictures, made once when the AR view starts. The face updates
// 60 times a second, and drawing a new picture every time would be slow.
func makeEmojiImages() -> [String: UIImage] {
  var images: [String: UIImage] = [:]
  for emoji in maskEmojis {
    images[emoji] = emojiImage(emoji)
  }
  return images
}
