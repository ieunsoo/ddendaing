import Foundation

/// 한국 공항의 목록을 열거형으로 변환한것
///
/// case: 영문지역이름 = 한글공항이름
enum KR_AirportNames: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }

    case Incheon = "인천국제공항"
    case Gimpo = "김포국제공항"
    case Gimhae = "김해국제공항"
    case Jeju = "제주국제공항"
    case Muan = "무안국제공항"
    case Yangyang = "양양국제공항"
    case Cheongju = "청주국제공항"
    case Daegu = "대구국제공항"
    case Wonju = "원주공항"
    case Pohang = "포항경주공항"
    case Ulsan = "울산공항"
    case Sacheon = "사천공항"
    case Gunsan = "군산공항"
    case Gwangju = "광주공항"
    case Yeosu = "여수공항"
}
