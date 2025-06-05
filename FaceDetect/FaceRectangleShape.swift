//
//  FaceRectangleShape.swift
//  FaceDetect
//
//  Created by Stany Dsouza on 04/06/25.
//

import SwiftUI

struct FaceRect: Identifiable {
    let id = UUID()
    let rect: CGRect

    init(rect: CGRect) {
        self.rect = rect
    }
}

struct FaceRectangleShape: Shape {
    private let faceBoundingBox: CGRect // normalized (0-1)

    init(faceBoundingBox: CGRect) {
        self.faceBoundingBox = faceBoundingBox
    }

    func path(in rect: CGRect) -> Path {
        // Convert normalized Vision rect to SwiftUI coordinates
        let x = faceBoundingBox.origin.x * rect.width
        let y = (1 - faceBoundingBox.origin.y - faceBoundingBox.height) * rect.height
        let width = faceBoundingBox.width * rect.width
        let height = faceBoundingBox.height * rect.height

        let convertedRect = CGRect(x: x, y: y, width: width, height: height)

        var path = Path()
        path.addRect(convertedRect)
        return path
    }
}

// struct FaceRectangleShape: Shape {
//    let normalizedRect: CGRect   // VNFaceObservation.boundingBox
//    let containerSize: CGSize    // GeometryReader size
//
//    func path(in _: CGRect) -> Path {
//        var path = Path()
//
//        let x = normalizedRect.origin.x * containerSize.width
//        let y = (1 - normalizedRect.origin.y - normalizedRect.height) * containerSize.height
//        let width = normalizedRect.width * containerSize.width
//        let height = normalizedRect.height * containerSize.height
//
//        let converted = CGRect(x: x, y: y, width: width, height: height)
//        path.addRect(converted)
//        return path
//    }
// }
