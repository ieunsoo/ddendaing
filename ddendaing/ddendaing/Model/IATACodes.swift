import Foundation

///국내공항의 IATA값을 저장하는 열거형
enum IATACodes: String, Codable{
    /*
     국제공항
     인천국제공항: ICN
     김포국제공항: GMP[5]
     김해국제공항: PUS[6]
     제주국제공항: CJU
     무안국제공항: MWX
     양양국제공항: YNY
     청주국제공항: CJJ
     대구국제공항: TAE
     국내선 공항
     원주공항: WJU
     포항경주공항: KPO
     울산공항: USN
     사천공항: HIN[7]
     군산공항: KUV
     광주공항: KWJ
     여수공항: RSU
     */
    //국제공항
    case ICN
    case GMP
    case PUS
    case CJU
    case MWX
    case YNY
    case CJJ
    case TAE
    
    //국내선 전용공항
    case WJU
    case KPO
    case USN
    case HIN
    case KUV
    case KWJ
    case RSU
}
