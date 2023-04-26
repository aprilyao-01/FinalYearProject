//
//  ReportItem.swift
//  Guardian
//
//  Created by Siyu Yao on 16/03/2023.
//

import Foundation


class ReportItem: Codable, Identifiable, Equatable, ObservableObject{
    
    internal init(id: String = UUID().uuidString, reportType: Int, locLongitude: Double, locLatitude: Double, reportedTime: String, reportedBy: String, deleteRequestedBy: [String], missingPersonGender: String, missingPersonName: String, missingPersonAge: String, missingPersonWornCloths: String, missingPersonImage: String,reportingConfirmedByUsers : [String]) {
        self.id = id
        self.reportType = reportType
        self.locLongitude = locLongitude
        self.locLatitude = locLatitude
        self.reportedTime = reportedTime
        self.reportedBy = reportedBy
        self.deleteRequestedBy = deleteRequestedBy
        self.missingPersonGender = missingPersonGender
        self.missingPersonName = missingPersonName
        self.missingPersonAge = missingPersonAge
        self.missingPersonWornCloths = missingPersonWornCloths
        self.missingPersonImage = missingPersonImage
        self.reportingConfirmedByUsers = reportingConfirmedByUsers
    }
    
    
    static func == (lhs: ReportItem, rhs: ReportItem) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    
    
    var id: String = UUID().uuidString
    var reportType: Int
    var locLongitude: Double
    var locLatitude: Double
    var reportedTime: String
    var reportedBy: String
    var reportingConfirmedByUsers: [String]
    var deleteRequestedBy: [String]
    var missingPersonGender: String
    var missingPersonName: String
    var missingPersonAge: String
    var missingPersonWornCloths: String
    var missingPersonImage: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case reportType = "reportType"
        case locLongitude = "locLongitude"
        case locLatitude = "locLatitude"
        case reportedTime = "reportedTime"
        case reportedBy = "reportedBy"
        case deleteRequestedBy = "deleteRequestedBy"
        case missingPersonGender = "missingPersonGender"
        case missingPersonName = "missingPersonName"
        case missingPersonAge = "missingPersonAge"
        case missingPersonWornCloths = "missingPersonWornCloths"
        case missingPersonImage = "missingPersonImage"
        case reportingConfirmedByUsers = "reportingConfirmedByUsers"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encodeIfPresent(id, forKey: .id)
            try container.encodeIfPresent(reportType, forKey: .reportType)
            try container.encodeIfPresent(locLongitude, forKey: .locLongitude)
            try container.encodeIfPresent(locLatitude, forKey: .locLatitude)
            try container.encodeIfPresent(reportedTime, forKey: .reportedTime)
            try container.encodeIfPresent(reportedBy, forKey: .reportedBy)
            try container.encodeIfPresent(deleteRequestedBy, forKey: .deleteRequestedBy)
            try container.encodeIfPresent(missingPersonGender, forKey: .missingPersonGender)
            try container.encodeIfPresent(missingPersonName, forKey: .missingPersonName)
            try container.encodeIfPresent(missingPersonAge, forKey: .missingPersonAge)
            try container.encodeIfPresent(missingPersonWornCloths, forKey: .missingPersonWornCloths)
            try container.encodeIfPresent(missingPersonImage, forKey: .missingPersonImage)
            try container.encodeIfPresent(reportingConfirmedByUsers, forKey: .reportingConfirmedByUsers)

        } catch {
            print("error")
        }
    }
    
    //Json decode
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        reportType = try values.decode(Int.self, forKey: .reportType)
        locLongitude = try values.decode(Double.self, forKey: .locLongitude)
        locLatitude = try values.decode(Double.self, forKey: .locLatitude)
        reportedTime = try values.decode(String.self, forKey: .reportedTime)
        reportedBy = try values.decode(String.self, forKey: .reportedBy)
        deleteRequestedBy = try values.decodeIfPresent([String].self, forKey: .deleteRequestedBy) ?? []
        missingPersonGender = try values.decode(String.self, forKey: .missingPersonGender)
        missingPersonName = try values.decode(String.self, forKey: .missingPersonName)
        missingPersonAge = try values.decode(String.self, forKey: .missingPersonAge)
        missingPersonWornCloths = try values.decode(String.self, forKey: .missingPersonWornCloths)
        missingPersonImage = try values.decode(String.self, forKey: .missingPersonImage)
        reportingConfirmedByUsers = try values.decodeIfPresent([String].self, forKey: .reportingConfirmedByUsers) ?? []
    }

}
