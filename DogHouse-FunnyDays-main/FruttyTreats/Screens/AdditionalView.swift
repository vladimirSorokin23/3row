//
//  AdditionalView.swift
//  FruttyTreats
//
//

import SwiftUI

struct AdditionalView: View {
    // MARK: - Properties
    @State var link: String

    // MARK: - View body
    var body: some View {
        SiteView(url: URL(string: link)!)
            .onAppear {
                AppDelegate.orientationLock = .all
            }
            .ignoresSafeArea()
            .background(Color.blue.edgesIgnoringSafeArea(.all))
    }
}
