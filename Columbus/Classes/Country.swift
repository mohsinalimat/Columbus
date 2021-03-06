//
//  Country.swift
//  Columbus
//
//  Created by Stefan Herold on 21.06.18.
//  Copyright © 2018 CodingCobra. All rights reserved.
//

import UIKit

enum CountryDecodingError: Error {
    case nameNotFound
}

public struct Country {

    /// Name of the country
    public let name: String
    /// ISO country code, e.g. DE, etc.
    public let isoCountryCode: String
    /// International dialing code, e.g. 49, 1, ...
    public let dialingCodeWithPlusPrefix: String
    /// `dialingCode` without + sign
    public let dialingCode: String
    /// The flag icon of the country
    public let flagIcon: UIImage
}

extension Country: Decodable {

    enum CodingKeys: String, CodingKey {
        case isoCountryCode = "code"
        case dialingCodeWithPlusPrefix = "dial_code"
    }

    public init(from decoder: Decoder) throws {
        let bundle = Columbus.bundle
        let container = try decoder.container(keyedBy: CodingKeys.self)

        isoCountryCode = try container.decode(String.self, forKey: .isoCountryCode)
        dialingCodeWithPlusPrefix = try container.decode(String.self, forKey: .dialingCodeWithPlusPrefix)
        dialingCode = dialingCodeWithPlusPrefix.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)

        guard let countryName = Locale.current.localizedString(forRegionCode: isoCountryCode) else {
            throw CountryDecodingError.nameNotFound
        }
        name = countryName
        flagIcon = UIImage(named: isoCountryCode.lowercased(), in: bundle, compatibleWith: nil) ?? UIImage()
    }
}
