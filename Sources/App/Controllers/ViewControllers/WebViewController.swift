//
//  WebViewController.swift
//  App
//
//  Created by Alexander Peresypkin on 28/03/2019.
//

import Vapor
import Fluent
import Leaf

final class WebViewController: RouteCollection {
    func boot(router: Router) throws {
        router.get("test", use: reportHandler)
    }
    
    private func test(req: Request) throws -> Future<View> {
        return try req.view().render("report")
    }
    
    private func reportHandler(req: Request) throws -> Future<View> {
        return Report.query(on: req).all().flatMap({ reports in
            let reportList = try reports.map({ report in
                return ReportContext(id: report.id ?? 0,
                                     title: report.titleReport,
                                     snapshots: try report.snapshots.query(on: req).all())
            })
            
            let data = ["reportList": reportList]
            return try req.view().render("report", data)
        })
    }
    
    struct ReportContext: Encodable {
        let id: Int
        let title: String
        let snapshots: Future<[Snapshot]>
    }
}
