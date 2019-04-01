//
//  ReportController.swift
//  App
//
//  Created by Alexander Peresypkin on 28/03/2019.
//

import Vapor
import Fluent

final class ReportController: RouteCollection {
    func boot(router: Router) throws {
        let reportRoute = router.grouped("api", "v1", "report")
        reportRoute.get(use: getAllHandler)
        reportRoute.post(Report.self, use: createHandler)
        reportRoute.post(Snapshot.self, at: "snapshot", use: createSnapshotHandler)
//        reportRoute.get("all", use: getAllEntytiesHandler)
        reportRoute.post("upload", use: uploadImages)
    }
    
    private func getAllHandler(req: Request) throws -> Future<[Report]> {
        return Report.query(on: req).all()
    }
    
    private func createHandler(req: Request, report: Report) throws -> Future<Report> {
        return report.save(on: req)
    }
    
    private func createSnapshotHandler(req: Request, snapshot: Snapshot) throws -> Future<Snapshot> {
        return snapshot.save(on: req)
    }
    
    private func uploadImages(req: Request) throws -> Future<Snapshot> {
        let directory = DirectoryConfig.detect()
        let workPath = directory.workDir
        
        return try req.content.decode(SnapshotData.self).flatMap({ snapshot in
            let name = UUID().uuidString + ".png"
            let imageFolder = "Public/snapshots"
            let imageFolderURL = URL(fileURLWithPath: workPath).appendingPathComponent(imageFolder, isDirectory: true)
            do {
                try FileManager.default.createDirectory(at: imageFolderURL,
                                                        withIntermediateDirectories: false)
            } catch {
                print(error.localizedDescription)
            }
            let saveURL = imageFolderURL.appendingPathComponent(name, isDirectory: false)
            do {
                try snapshot.reference.data.write(to: saveURL)
                
                let path = "http://localhost:8080/snapshots/" + "\(name)"
                let snapshot = Snapshot(title: snapshot.title,
                                        reference: path,
                                        failure: path,
                                        diff: path,
                                        reportID: snapshot.reportID)
                print(snapshot)
                return snapshot.save(on: req)
            } catch {
                print("error: \(error)")
                throw Abort(.internalServerError)
            }
        })
        
        
//        return try req.content.decode(SnapshotData.self).map({ snapshot in
//            do {
//                try snapshot.reference.data.write(to: saveURL)
//                print(saveURL)
//                print("snapshot: \(snapshot)")
//
//                return .ok
//            } catch {
//                print("error: \(error)")
//                throw Abort(.internalServerError)
//            }
//        })
    }
    
    struct SnapshotData: Content {
        var title: String
        var reference: File
        var failure: File
        var diff: File
        var reportID: Report.ID
        
        init(title: String, reference: File, failure: File, diff: File, reportID: Report.ID) {
            self.title = title
            self.reference = reference
            self.failure = failure
            self.diff = diff
            self.reportID = reportID
        }
    }
    
//    private func getAllEntytiesHandler(req: Request) throws -> Future<[ReportData]> {
//        return Report.query(on: req).all().flatMap({ reports -> Future<([Snapshot], [Report])> in
//            let ids = reports.compactMap { $0.id }
//            return Snapshot.query(on: req).filter(\.reportID ~~ ids).all().and(result: reports)
//        }).map({ results in
//            let (snapshots, reports) = results
//
//            return try reports.compactMap { report -> ReportController.ReportData in
//                guard let reportID = report.id else { throw Abort(.badRequest) }
//
//                let snapshotsData = snapshots
//                    .filter { $0.reportID == reportID }
//                    .map { SnapshotData(id: $0.id,
//                                        title: $0.title,
//                                        reference: $0.reference,
//                                        failure: $0.failure,
//                                        diff: $0.diff) }
//
//                return ReportData(id: reportID,
//                                  title: report.titleReport,
//                                  snapshots: snapshotsData)
//            }
//        })
//    }
//
//    struct ReportData: Content {
//        let id: Int
//        let title: String
//        let snapshots: [SnapshotData]
//    }
//
//    struct SnapshotData: Content {
//        let id: Int?
//        let title: String
//        var reference: Data
//        var failure: Data
//        var diff: Data
//    }

}
