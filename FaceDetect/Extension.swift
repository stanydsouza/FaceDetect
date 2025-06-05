//
//  Extension.swift
//  FaceDetect
//
//  Created by Stany Dsouza on 04/06/25.
//

import UIKit

extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up: self = .up
        case .down: self = .down
        case .left: self = .left
        case .right: self = .right
        case .upMirrored: self = .upMirrored
        case .downMirrored: self = .downMirrored
        case .leftMirrored: self = .leftMirrored
        case .rightMirrored: self = .rightMirrored
        @unknown default:
            self = .up
        }
    }
}

enum CustomError: LocalizedError {
    case custom(message: String)
    case imageConvert
    case noResults

    var errorDescription: String? {
        switch self {
        case let .custom(message: message): message

        case .imageConvert: "Image Conversion Failed"

        case .noResults: "No result found"
        }
    }
}
