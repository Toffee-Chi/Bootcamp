import SwiftUI

struct BirthdayListView: View {
    let birthdays: [Birthday]

    var body: some View {
        ScrollView {
            ForEach(birthdays) { birthday in
                HStack {
                    Text(birthday.name)
                        .font(.body)
                        .padding(.vertical, 10)
                        .padding(.leading)

                    Spacer()

                    Image(systemName: "gift")
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(radius: 2)
                )
                .padding(.horizontal)
                .padding(.vertical, 4)
            }
        }
    }
}
