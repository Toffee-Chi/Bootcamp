import SwiftUI

struct LeaveTypePicker: View {
    @Binding var selection: LeaveType?
    
    var body: some View {
        Picker("Tipo de permiso", selection: $selection) {
            ForEach(LeaveType.allCases) { type in
                Text(type.rawValue).tag(type as LeaveType?)
            }
        }
        .pickerStyle(.navigationLink)
    }
}

