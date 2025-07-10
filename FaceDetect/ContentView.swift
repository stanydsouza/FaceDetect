//
//  ContentView.swift
//  FaceDetect
//
//  Created by Stany Dsouza on 04/06/25.
//

import SwiftUI
import UIKit
import Vision

struct ContentView: View {
    @State private var rectangles: [FaceRect] = []

    private let imageName: String = "image2"

    private var isSimulator: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .overlay(
                    ForEach(rectangles) { item in
                        FaceRectangleShape(faceBoundingBox: item.rect)
                            .stroke(Color.blue, lineWidth: 2)
                    }
                )

            Button("Detect Face Rectangles") {
                drawRectangles()
            }
        }
        .padding()
    }

    private func drawRectangles() {
        Task {
            do {
                guard let image = UIImage(named: imageName) else {
                    return
                }
                try await detectFace(image: image)
            } catch {
                print("Vision Error: \(error)")
            }
        }
    }

    private func detectFace(image: UIImage) async throws {
        if #available(iOS 18.0, *), !isSimulator {
            try await detectFaceIOS18Above(image: image)
        } else {
            try await detectFaceIOS18Below(image: image)
        }
    }

    private func detectFaceIOS18Below(image: UIImage) async throws { // In future this may become depricated
        // guard let cgImage = image.cgImage else { throw CustomError.imageConvert }
        guard let ciImage = CIImage(image: image) else {
            throw CustomError.imageConvert
        }

        let orientation = CGImagePropertyOrientation(image.imageOrientation)

        // Set up the request
        let request = VNDetectFaceRectanglesRequest()
        #if targetEnvironment(simulator)
            request.usesCPUOnly = true
        #endif
        
        // handler to perform request
        // let handler = VNImageRequestHandler(cgImage: cgImage, orientation: orientation, options: [:])
        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation, options: [:])
        
        Task.detached(priority: .userInitiated) {
            try handler.perform([request])

            guard let results = request.results, !results.isEmpty else {
                throw CustomError.noResults
            }

            let faceRects = results.map { FaceRect(rect: $0.boundingBox) }
            
            await MainActor.run {
                rectangles = faceRects
            }
        }
        

    }

    @available(iOS 18.0, *)
    private func detectFaceIOS18Above(image: UIImage) async throws {
        guard let ciImage = CIImage(image: image) else {
            throw CustomError.imageConvert
        }

        let orientation = CGImagePropertyOrientation(image.imageOrientation)

        // Set up the request
        let request = DetectFaceRectanglesRequest()

        // Perform the request
        Task.detached(priority: .userInitiated) {
            let results = try await request.perform(on: ciImage, orientation: orientation)
            
            guard !results.isEmpty else {
                throw CustomError.noResults
            }
            
            let faceRects = results.map { FaceRect(rect: $0.boundingBox.cgRect) }
            
            await MainActor.run {
                rectangles = Array(faceRects)
            }
        }
    }
}
