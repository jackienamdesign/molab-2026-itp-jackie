//
//  Document.swift
//  TurnBack - Week07 homework, Jackie Nam
//
//  The drift log the whole app shares. Made once in TurnBackApp and passed down
//  with .environment, the same way the MotionDetector is. From Document.swift
//  in the class sample 06-ImageEditDemoJSON.
//
//  Every change is saved straight away, so there is no Save button to forget.
//
//  Week07: photos are saved as their own jpg files next to driftlog.json, using
//  documentPath from SaveLoadJSON.swift. Writing image data to a file is the
//  Week02 ascii image trick (pngData, then write), with jpegData instead -
//  a phone photo as a png is many megabytes.
//

import UIKit

@Observable
class Document {
  var model: Model

  // The file lives in the app's Documents folder. saveJSON prints a cp command
  // in the Xcode console that copies it to Downloads, to look at it.
  let saveFileName = "driftlog.json"

  init() {
    // For testing - uncomment to start over with an empty log:
    // remove(fileName: saveFileName)
    model = Model(JSONfileName: saveFileName)
  }

  func addEntry(entry: DriftEntry) {
    model.entries.append(entry)
    saveModel()
  }

  // Delete the photo files too, or they would sit in Documents forever with
  // nothing pointing at them.
  func clearAll() {
    for entry in model.entries {
      if let photoFile = entry.photoFile {
        remove(fileName: photoFile)
        remove(fileName: "thumb-" + photoFile)
      }
    }
    model.entries = []
    saveModel()
  }

  // Week07 UX: delete one walk. A plain loop keeps every entry except this
  // one - Week02 style, no filter.
  func deleteEntry(entry: DriftEntry) {
    if let photoFile = entry.photoFile {
      remove(fileName: photoFile)
      remove(fileName: "thumb-" + photoFile)
    }
    var kept: [DriftEntry] = []
    for other in model.entries {
      if other.id != entry.id {
        kept.append(other)
      }
    }
    model.entries = kept
    saveModel()
  }

  // Week07: save the photo as a jpg in Documents, plus a small copy for the
  // My Walks list ("thumb-" + the same name). The list used to load every
  // full size photo each time it drew.
  // The small copy is drawn with UIGraphicsImageRenderer, from Week02's
  // ascii image page. draw(in:) squeezes the photo into the smaller size.
  func savePhoto(image: UIImage, fileName: String) {
    writeJPEG(image: image, fileName: fileName)

    let width = 200.0
    let size = CGSize(width: width, height: width * image.size.height / image.size.width)
    let renderer = UIGraphicsImageRenderer(size: size)
    let thumb = renderer.image { context in
      image.draw(in: CGRect(origin: CGPoint.zero, size: size))
    }
    writeJPEG(image: thumb, fileName: "thumb-" + fileName)
  }

  func writeJPEG(image: UIImage, fileName: String) {
    do {
      let filePath = try documentPath(fileName: fileName)
      let data = image.jpegData(compressionQuality: 0.7)
      try data?.write(to: filePath)
      print("writeJPEG filePath \(filePath)")
    } catch {
      print("writeJPEG error \(error)")
    }
  }

  // Week07: read a saved photo back. Data(contentsOf:) + UIImage(data:) is
  // the same pair Week02 used to load an image from a URL - a file path is a
  // URL too. nil if the file is not there.
  func loadPhoto(fileName: String) -> UIImage? {
    do {
      let filePath = try documentPath(fileName: fileName)
      let data = try Data(contentsOf: filePath)
      return UIImage(data: data)
    } catch {
      print("loadPhoto error \(error)")
      return nil
    }
  }

  // Week07 UX: the small copy if there is one, else the full photo. Walks
  // saved before thumbnails were added only have the full one.
  func loadThumbnail(fileName: String) -> UIImage? {
    let thumb = loadPhoto(fileName: "thumb-" + fileName)
    if thumb != nil {
      return thumb
    }
    return loadPhoto(fileName: fileName)
  }

  func saveModel() {
    print("Document saveModel")
    model.saveAsJSON(fileName: saveFileName)
  }
}
