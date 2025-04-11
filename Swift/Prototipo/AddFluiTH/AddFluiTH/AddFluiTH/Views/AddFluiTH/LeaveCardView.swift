import SwiftUI
import SwiftData
import Kingfisher

struct LeaveCardView: View {
    let leave: LeaveRequest
    let isExpanded: Bool
    let onTap: () -> Void
    
    @State private var showFullImage = false
    @State private var buttonDisabled = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(leave.employeeName)
                        .font(.headline)
                    
                    Text("\(formattedDateRange)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                
                if let subtype = leave.licenseSubtype {
                    Image(subtype.iconName)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(.trailing, 20)
                } else {
                    Image(leave.type.iconName)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(.trailing, 20)
                }
                
                if let gender = leave.gender {
                    Image(gender.iconName)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(.trailing, 20)
                }
            }
            
            if isExpanded {
                Group {
                    Text("Tipo: \(leave.type.rawValue)")
                        .font(.caption)
                    
                    
                    if let subtype = leave.licenseSubtype {
                        Text("Subtipo: \(subtype.rawValue)")
                            .font(.caption)
                    }
                    
                    if let relationship = leave.deathRelationship {
                        Text("Parentesco: \(relationship.rawValue)")
                            .font(.caption)
                    }
                    if leave.type == .medical, let urlString = leave.medicalDocumentURL, let url = URL(string: urlString) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Documento médico:")
                                .font(.caption)
                                .bold()
                            
                            Button {
                                showFullImage = true
                            } label: {
                                KFImage(url)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 150)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }
                        .fullScreenCover(isPresented: $showFullImage) {
                            ZStack(alignment: .topTrailing) {
                                Color.black.ignoresSafeArea()
                                
                                KFImage(url)
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                                    .background(Color.black)
                                
                                Button {
                                    buttonDisabled = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        buttonDisabled = false
                                    }
                                    showFullImage = false
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.white)
                                        .padding()
                                }
                            }
                        }
                    }
                }
                .transition(.opacity)
            }
        }
        .padding(.vertical)
        .onTapGesture {
            withAnimation {
                onTap()
            }
        }
        
    }
    private var formattedDateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return "\(formatter.string(from: leave.startDate)) - \(formatter.string(from: leave.endDate))"
    }
}

