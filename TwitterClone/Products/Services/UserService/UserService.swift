//
//  UserService.swift
//  TwitterClone
//
//  Created by Emre Simsek on 3.08.2024.
//

import FirebaseAuth
import FirebaseFirestore

protocol IUserService {
  func createUser(user: UserModel) async -> UserModel?
  func loginUser(user: UserModel) async -> UserModel?
  func fetchUser(userId: String) async -> UserModel?
  func checkCurrentUser() async -> String?
  func signOut()
  func updateUser(user: UserModel) async -> Bool
  func fetchUsers() async -> [UserModel]?
  func followUser(user: UserModel, targetUser: UserModel) async -> Bool
  func addListenerUser(
    uid: String, onActive: @escaping (UserModel) -> Void
  )
}

final class UserService: IUserService {

  private let userCollection = Firestore.firestore().collection(FirebaseCollections.user.rawValue)
  private let auth = Auth.auth()

  func addListenerUser(
    uid: String, onActive: @escaping (UserModel) -> Void
  ) {
    userCollection.document(uid)
      .addSnapshotListener { snapshot, error in
        guard
          let user = try? Firestore.Decoder().decode(UserModel.self, from: snapshot?.data() ?? "")
        else { return }
        onActive(user)
      }
  }

  func followUser(user: UserModel, targetUser: UserModel) async -> Bool {
    guard let uid = user.id else { return false }
    guard let targetUid = targetUser.id else { return false }
    var followingUsers: [String] = user.followingUsers ?? []
    followingUsers.append(targetUid)
    do {
      try await userCollection.document(uid).updateData(["followingUsers": followingUsers])
    } catch {
      print("Error updating following users")
      return false
    }
    var followerUsers: [String] = targetUser.followerUsers ?? []
    followerUsers.append(uid)
    do {
      try await userCollection.document(targetUid).updateData(["followerUsers": followerUsers])
    } catch {
      print("Error updating followers users")
      return false
    }
    return true
  }

  func createUser(user: UserModel) async -> UserModel? {
    let response = await createUserAuth(user: user)
    guard response != nil else { return nil }
    let copyUser = user.copyWith(id: response)
    await createUserFirebase(user: copyUser)
    return copyUser
  }

  func loginUser(user: UserModel) async -> UserModel? {
    let responseLogin = try? await auth.signIn(
      withEmail: user.email ?? "",
      password: user.password ?? ""
    )
    guard responseLogin != nil && responseLogin?.user.uid != nil else { return nil }
    let responseUser = await fetchUser(userId: responseLogin!.user.uid)
    return responseUser

  }

  func fetchUser(userId: String) async -> UserModel? {
    guard !userId.isEmpty else {
      print("USERSERVICE: User id is empty")
      return nil
    }
    do {
      let rawUser = try await userCollection.document(userId).getDocument().data()
      let user = try Firestore.Decoder().decode(UserModel.self, from: rawUser!)
      return user
    } catch {
      print("USERSERVICE: user not found")
      return nil
    }
  }

  func fetchUsers() async -> [UserModel]? {
    guard let documents = try? await userCollection.getDocuments().documents
    else {
      print("USERSERVICE: Documents not found")
      return nil
    }
    var fetchedUsers: [UserModel] = []
    for document in documents {
      guard
        let data = try? Firestore.Decoder()
          .decode(UserModel.self, from: document.data())
      else {
        print("USERSERVICE: Error decoding document")
        return nil
      }
      fetchedUsers.append(data)
    }
    return fetchedUsers
  }

  func checkCurrentUser() async -> String? {
    guard let currentAuthUser = auth.currentUser else { return nil }
    return currentAuthUser.uid
  }

  func signOut() {
    guard auth.currentUser != nil else { return }
    try? auth.signOut()
  }

  func updateUser(user: UserModel) async -> Bool {
    guard let uid = user.id else {
      print("USERSERVICE: User id is empty")
      return false
    }
    do {
      try await userCollection.document(uid)
        .setData(Firestore.Encoder().encode(user))
      return true
    } catch {
      print("USERSERVICE: Error updating user: \(error.localizedDescription)")
      return false
    }
  }

  private func createUserAuth(user: UserModel) async -> String? {
    let result = try? await auth.createUser(
      withEmail: user.email ?? "",
      password: user.password ?? ""
    )
    guard let userId = result?.user.uid else {
      print("Auth register failed user uid returned as null")
      return nil
    }
    return userId
  }

  private func createUserFirebase(user: UserModel) async {
    try? await userCollection.document(user.id ?? "").setData(Firestore.Encoder().encode(user))
  }

}
