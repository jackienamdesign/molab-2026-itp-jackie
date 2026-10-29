//
//  FaceViewAR.swift
//  EmojiMirror - Week08 homework, Jackie Nam
//
//  From the class sample 07-FaceMeshUI, with the sample's spacing kept.
//  Week08 changes are marked "Week08:".
//
//  The sample draws a cyan wireframe over your face. I kept the wireframe
//  and put an emoji on the front of it, which changes with your expression.
//  The emoji is a flat square (SCNPlane) added as a child of the face node,
//  so ARKit moves and turns it with your head - I don't do any of that maths.
//

import ARKit
import SceneKit
import SwiftUI

/// Front-camera AR view running ARFaceTrackingConfiguration.
/// Draws a wireframe face mesh and reports blend shapes to a FaceTracker.
struct FaceViewAR: UIViewRepresentable {
    let tracker: FaceTracker

    func makeCoordinator() -> Coordinator {
        // Week08: the emoji pictures are drawn once, here, and handed over
        Coordinator(tracker: tracker, images: makeEmojiImages())
    }

    func makeUIView(context: Context) -> ARSCNView {
        let view = ARSCNView(frame: .zero)
        view.delegate = context.coordinator
        view.session.delegate = context.coordinator
        view.automaticallyUpdatesLighting = true

        if ARFaceTrackingConfiguration.isSupported {
            let config = ARFaceTrackingConfiguration()
            config.maximumNumberOfTrackedFaces = 1
            config.isLightEstimationEnabled = true
            view.session.run(config, options: [.resetTracking, .removeExistingAnchors])
        }
        return view
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}

    static func dismantleUIView(_ uiView: ARSCNView, coordinator: Coordinator) {
        uiView.session.pause()
    }

    final class Coordinator: NSObject, ARSCNViewDelegate, ARSessionDelegate {
        let tracker: FaceTracker
        let images: [String: UIImage]   // Week08: emoji -> its picture

        init(tracker: FaceTracker, images: [String: UIImage]) {
            self.tracker = tracker
            self.images = images
        }

        // MARK: ARSCNViewDelegate (called on SceneKit render thread)

        nonisolated func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
            guard anchor is ARFaceAnchor,
                  let device = renderer.device,
                  let faceGeometry = ARSCNFaceGeometry(device: device) else { return nil }
            let material = faceGeometry.firstMaterial
            material?.fillMode = .lines
            material?.diffuse.contents = UIColor.cyan
            material?.lightingModel = .constant
            let node = SCNNode(geometry: faceGeometry)

            // Week08: the emoji. A 22 cm square, so it covers a face.
            // On the face, +z points out toward the camera, and 0.1 m puts the
            // square just in front of the tip of the nose.
            // .constant lighting, like the wireframe, so the emoji keeps its
            // own colors instead of being shaded by the room's light.
            let plane = SCNPlane(width: 0.22, height: 0.22)
            plane.firstMaterial?.diffuse.contents = images["🙂"]
            plane.firstMaterial?.lightingModel = .constant
            let emojiNode = SCNNode(geometry: plane)
            emojiNode.position = SCNVector3(0, 0, 0.1)
            emojiNode.name = "🙂"   // name = which emoji is showing
            node.addChildNode(emojiNode)

            return node
        }

        nonisolated func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            guard let faceAnchor = anchor as? ARFaceAnchor else { return }
            (node.geometry as? ARSCNFaceGeometry)?.update(from: faceAnchor.geometry)

            let blendShapes = faceAnchor.blendShapes
            let tracked = faceAnchor.isTracked

            // Week08: swap the picture only when the emoji changes, not on
            // every frame. The node's name remembers which one is showing.
            let emoji = pickEmoji(blendShapes)
            if let emojiNode = node.childNodes.first, emojiNode.name != emoji {
                emojiNode.geometry?.firstMaterial?.diffuse.contents = images[emoji]
                emojiNode.name = emoji
            }

            Task { @MainActor [tracker] in
                if tracked {
                    tracker.update(blendShapes: blendShapes)
                } else {
                    tracker.faceLost()
                }
            }
        }

        nonisolated func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
            guard anchor is ARFaceAnchor else { return }
            Task { @MainActor [tracker] in tracker.faceLost() }
        }

        // MARK: ARSessionDelegate

        nonisolated func sessionWasInterrupted(_ session: ARSession) {
            Task { @MainActor [tracker] in tracker.faceLost() }
        }
    }
}
