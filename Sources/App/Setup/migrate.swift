//
//  migrate.swift
//  App
//
//  Created by Alexander Peresypkin on 28/03/2019.
//

import Vapor
import FluentPostgreSQL

public func migrate(migrations: inout MigrationConfig) throws {
    
    migrations.add(model: Report.self, database: .psql)
    migrations.add(model: Snapshot.self, database: .psql)

}
