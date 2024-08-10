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
    func checkCurrentUser() async -> UserModel?
    func signOut()
    func updateUser(user: UserModel) async -> Bool
    func fetchUsers() async -> [UserModel]?
}

final class UserService: IUserService {

    private let userCollection = Firestore.firestore().collection(FirebaseCollections.user.rawValue)
    private let auth = Auth.auth()

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
        let response = try? await userCollection.document(userId).getDocument()
        guard response != nil && response!.exists else { return nil }
        let data = try? Firestore.Decoder().decode(UserModel.self, from: response?.data() ?? [:])
        guard data != nil else { return nil }
        return data

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

    func checkCurrentUser() async -> UserModel? {
        guard let currentAuthUser = auth.currentUser else { return nil }
        let user = await fetchUser(userId: currentAuthUser.uid)
        return user
    }

    func signOut() {
        guard auth.currentUser != nil else { return }
        try? auth.signOut()
    }

    func updateUser(user: UserModel) async -> Bool {
        do {
            try await userCollection.document(user.id ?? "")
                .setData(Firestore.Encoder().encode(user))
            return true
        }
        catch {
            print("hata")
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
