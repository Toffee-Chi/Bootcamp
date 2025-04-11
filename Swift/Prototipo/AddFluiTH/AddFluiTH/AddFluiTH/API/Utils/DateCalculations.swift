import Foundation

struct DateCalculations {
    
    static func calculateEndDate(
        startDate: Date,
        licenseSubtype: LicenseSubtype?,
        deathRelationship: DeathRelationship? = nil,
        gender: Gender? = nil
    ) -> Date {
        guard let licenseSubtype else { return startDate }
        
        
        guard licenseSubtype != .exam else { return startDate }
        
        let calendar = Calendar.current
        var daysToAdd: Int
        
        switch licenseSubtype {
        case .marriage:
            daysToAdd = 5
        case .mourning:
            daysToAdd = switch deathRelationship {
            case .parents, .children, .siblings: 5
            case .grandparents: 3
            case .other, nil: 2
            }
        case .birth:
            daysToAdd = gender == .male ? 14 : 150
        case .exam:
            return startDate
        }
        
        return calendar.date(byAdding: .day, value: daysToAdd, to: startDate)!
    }
    
    
    static func isWeekend(_ date: Date) -> Bool {
        let weekday = Calendar.current.component(.weekday, from: date)
        return weekday == 1 || weekday == 7
    }
}
