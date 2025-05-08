//
//  DatabricksApp.swift
//  Databricks
//
//  Created by Asif Mohammed on 5/8/25.
//

import SwiftUI

@main
struct DatabricksApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: DatabricksDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
