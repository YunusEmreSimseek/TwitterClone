//  ImageService.swift
//  TwitterClone
//
//  Created by Emre Simsek on 5.08.2024.

import Firebase
import FirebaseStorage

protocol IImageService {
    func uploadImageToFirebaseStorage(image: UIImage) async -> String?
    func deleteImageFromFirebaseStorage(url: String) async -> Bool
}

final class ImageService: IImageService {

    func uploadImageToFirebaseStorage(image: UIImage) async -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("IMAGESERVICE: image couldnt be converted to data")
            return nil
        }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference().child("profile_image/\(filename).png")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        let _ = try? await ref.putDataAsync(imageData, metadata: metadata)
        let url = try? await ref.downloadURL()
        print("downloadURL : \(url?.debugDescription ?? "nil")")
        return url?.absoluteString
    }

    func deleteImageFromFirebaseStorage(url: String) async -> Bool {
        let ref = Storage.storage().reference(forURL: url)
        do {
            try await ref.delete()
            return true
        }
        catch {
            print(
                "IMAGESERVICE: deleteImageFromFirebaseStorage error: \(error.localizedDescription)"
            )
            return false
        }
    }
}
