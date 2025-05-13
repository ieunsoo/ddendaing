//
//  Flight.swift
//  KoreaAirportInfo
//
//  Created by eunsoo on 5/11/25.
//

import Foundation

//enum airportName{
//    /*
//     국제공항
//     인천국제공항: ICN
//     김포국제공항: GMP[5]
//     김해국제공항: PUS[6]
//     제주국제공항: CJU
//     무안국제공항: MWX
//     양양국제공항: YNY
//     청주국제공항: CJJ
//     대구국제공항: TAE
//     국내선 공항
//     원주공항: WJU
//     포항경주공항: KPO
//     울산공항: USN
//     사천공항: HIN[7]
//     군산공항: KUV
//     광주공항: KWJ
//     여수공항: RSU
//     */
//    case ICN
//    case GMP
//    case PUS
//    case CJU
//    case MWX
//    case YNY
//    case CJJ
//    case TAE
//    
//    //국내선 전용공항
//    case WJU
//    case KPO
//    case USN
//    case HIN
//    case KUV
//    case KWJ
//    case RSU
//}

// 최상위 응답 구조
struct FlightListResponse: Codable {
    let data: FlightDataContainer
}

// data 내부 컨테이너
struct FlightDataContainer: Codable {
    let list: [Flight]
//    let list2: [Flight]?  // 필요에 따라 사용 (현재는 list만 사용)
}

// 개별 항공편 데이터
/*
"STD": "1600",
 "VIA_ENG": "HONGQIAO",
 "AIRPORT": "GMP",
 "ARRIVED_KOR": "상하이/홍차오",
 "AIR_FLN": "MU8936",
 "ACT_C_DATE": "20250511",
 "RMK_JPN": "出発",
 "FLN": "8936",
 "RMK_CHN": "出发",
 "LINE": "I",
 "RMK_ENG": "DEPARTED",
 "AIR_ENG": "CHINA EASTERN AIRLINES",
 "AIR_ICAO": "CES",
 "IO": "O",
 "AIR_IATA": "MU",
 "GATE": null,
 "BOARDING_ENG": "GIMPO",
 "LINK_URL": "https://us.ceair.com/en/",
 "RMK_KOR": "출발",
 "AIR_KOR": "중국동방항공",
 "VIA": "SHA",x`
 "VIA_KOR": "상하이/홍차오",
 "ETD": "1614",
 "CITY": "SHA",
 "ARRIVED_ENG": "HONGQIAO",
 "ETD1": "1614",
 "BOARDING_KOR": "서울/김포"
 */
struct Flight: Identifiable, Codable {
    let id = UUID()
    let flightNumber: String
    let airline: String
    let std: String
    let etd: String
    let destination: String?
    let gate: String?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case flightNumber = "AIR_FLN"
        case airline = "AIR_KOR"
        case std = "STD"
        case etd = "ETD"
        case destination = "ARRIVED_KOR"
        case gate = "GATE"
        case status = "RMK_KOR"
    }
}
