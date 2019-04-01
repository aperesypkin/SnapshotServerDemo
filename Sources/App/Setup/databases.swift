//
//  databases.swift
//  App
//
//  Created by Alexander Peresypkin on 28/03/2019.
//

import Vapor
import FluentPostgreSQL

public func databases(config: inout DatabasesConfig) throws {
    
    let databaseConfig: PostgreSQLDatabaseConfig
    if let url = Environment.get("DATABASE_URL") {
        databaseConfig = PostgreSQLDatabaseConfig(url: url)!
    } else {
        let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
        let username = Environment.get("DATABASE_USER") ?? "postgres"
        let databaseName = Environment.get("DATABASE_DB") ?? "snapshot_server"
        let password = Environment.get("DATABASE_PASSWORD") ?? "123456"
        let databasePort = 5432
        
        databaseConfig = PostgreSQLDatabaseConfig(
            hostname: hostname,
            port: databasePort,
            username: username,
            database: databaseName,
            password: password)
    }
    
//    let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
//    let username = Environment.get("DATABASE_USER") ?? "postgres"
//    let databaseName = Environment.get("DATABASE_DB") ?? "snapshot_server"
//    let password = Environment.get("DATABASE_PASSWORD") ?? "123456"
//
//    let pgConfig = PostgreSQLDatabaseConfig(hostname: hostname,
//                                            port: 5432,
//                                            username: username,
//                                            database: databaseName,
//                                            password: password)
    
    let database = PostgreSQLDatabase(config: databaseConfig)
    
    config.add(database: database, as: .psql)
    
}
