import Foundation
import SwiftUI
struct Rest: View {
    var body: some View {
        VStack {
            Text("Vista de Reposo")
                .font(.title)
                .offset(y: 20)
            
            Spacer()
        }
        .padding()
    }
}
struct Rest_Previews: PreviewProvider {
    static var previews: some View {
        Rest()
    }
}
