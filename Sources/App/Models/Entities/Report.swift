//
//  Report.swift
//  App
//
//  Created by Alexander Peresypkin on 28/03/2019.
//

import Vapor
import FluentPostgreSQL

final class Report {
    var id: Int?
    var titleReport: String
    
    init(titleReport: String) {
        self.titleReport = titleReport
    }
}

extension Report: PostgreSQLModel {
    var snapshots: Children<Report, Snapshot> {
        return children(\.reportID)
    }
}

extension Report: Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: conn) { builder in
            try addProperties(to: builder)
        }
    }
}

extension Report: Content {}

extension Report: Parameter {}
