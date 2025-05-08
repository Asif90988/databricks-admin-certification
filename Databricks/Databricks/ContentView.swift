//
//  ContentView.swift
//  Databricks
//
//  Created by Asif Mohammed on 5/8/25.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: DatabricksDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(DatabricksDocument()))
}
