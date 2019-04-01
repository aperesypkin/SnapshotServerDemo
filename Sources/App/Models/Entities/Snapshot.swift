//
//  Snapshot.swift
//  App
//
//  Created by Alexander Peresypkin on 28/03/2019.
//

import Vapor
import FluentPostgreSQL

final class Snapshot {
    var id: Int?
    var title: String
    var reference: String
    var failure: String
    var diff: String
    var reportID: Report.ID
    
    init(title: String, reference: String, failure: String, diff: String, reportID: Report.ID) {
        self.title = title
        self.reference = reference
        self.failure = failure
        self.diff = diff
        self.reportID = reportID
    }
}

extension Snapshot: PostgreSQLModel {
    var report: Parent<Snapshot, Report> {
        return parent(\.reportID)
    }
}

extension Snapshot: Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: conn) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.reportID, to: \Report.id)
        }
    }
}

extension Snapshot: Content {}

extension Snapshot: Parameter {}
