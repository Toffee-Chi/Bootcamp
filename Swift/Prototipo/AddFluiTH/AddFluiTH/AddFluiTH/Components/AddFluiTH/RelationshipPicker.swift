import SwiftUI

struct RelationshipPicker: View {
    @Binding var selection: DeathRelationship?
    
    var body: some View {
        Picker("Parentesco", selection: $selection) {
            ForEach(DeathRelationship.allCases) { relation in
                Text(relation.rawValue).tag(relation as DeathRelationship?)
            }
        }
        .pickerStyle(.navigationLink)
    }
}
