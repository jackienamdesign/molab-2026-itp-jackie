//
//  DriftEntry.swift
//  TurnBack - Week07 homework, Jackie Nam
//
//  One saved walk: where I marked, when, how long I was gone, and how far off
//  the arrow was when I got back. Shaped like ItemModel in the class sample
//  06-ImageEditDemoJSON.
//
//  Codable is what lets this be turned into JSON and back. Every property has
//  to be a type that is Codable too - String, Double, Date and UUID all are.
//
//  Week07: photoFile is the name of a jpg in the Documents folder - the photo
//  of the way I was facing when I pressed Mark. The photo itself is not in the
//  JSON, only its file name.
//
//  photoFile is optional (String?) on purpose. The walks saved in Week06 have
//  no photoFile in their JSON. A missing optional just comes back as nil, but
//  a missing plain String would make the whole file fail to load and the log
//  would come up empty (the gotcha from Week06).
//

import Foundation

struct DriftEntry: Identifiable, Codable {
  var id = UUID()
  var emoji = ""
  var name = ""
  var date = Date()
  var minutes = 0.0
  var driftDegrees = 0.0
  var photoFile: String?
}
