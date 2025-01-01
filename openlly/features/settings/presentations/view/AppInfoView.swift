//
//  AppInfoView.swift
//  openlly
//
//  Created by Mobin on 26/12/24.
//

import SwiftUI

struct InformationSection: View {
    var body: some View {
        Section(header: Text("Information")) {
            NavigationLink(destination: Text("Privacy Policy")) {
                Text("Privacy Policy")
            }
            NavigationLink(destination: Text("Terms of Service")) {
                Text("Terms of Service")
            }
            NavigationLink(destination: Text("About")) {
                Text("About")
            }
            NavigationLink(destination: Text("Contact Us")) {
                Text("Contact Us")
            }
        }
    }
}
