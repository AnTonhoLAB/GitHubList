//
//  UserListModel.swift
//  GitHubList
//
//  Created by George Gomes on 30/06/23.
//

import Foundation

// MARK: - UserListElement
protocol SimpleUserProtocol {
    var login: String { get }
}

struct SimpleUser: SimpleUserProtocol {
    let login: String
}

struct UserListModel: Codable, SimpleUserProtocol {
    let login: String
    let id: Int
    let nodeID: String
    let avatarURL: String
    let gravatarID: String
    let url, htmlURL, followersURL: String
    let followingURL, gistsURL, starredURL: String
    let subscriptionsURL, organizationsURL, reposURL: String
    let eventsURL: String
    let receivedEventsURL: String
    let type: TypeEnum
    let siteAdmin: Bool

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
    }
}

extension UserListModel: Equatable {
    static func ==(lhs: UserListModel, rhs: UserListModel) -> Bool {
        return lhs.id == rhs.id
    }
}

enum TypeEnum: String, Codable {
    case organization = "Organization"
    case user = "User"
}
