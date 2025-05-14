//
//  FlightViewModel.swift
//  KoreaAirportInfo
//
//  Created by eunsoo on 5/11/25.
//

import Foundation

@MainActor
class FlightViewModel: ObservableObject {
    @Published var flights: [Flight] = []
    
    var airportName: String = "PUS"
    var actDate: String = "20250514"
    var stHourMin: String
    var enHourMin: String
    
    init(){
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmm"  // 24시간제 시분 형식
        let now = Date()

        // 현재 시간
        let currentTime = formatter.string(from: now)

        // Calendar 사용
        let calendar = Calendar.current

        // -3시간 계산
        let minus3 = calendar.date(byAdding: .hour, value: -3, to: now)!
        let isPrevDay = !calendar.isDate(minus3, inSameDayAs: now)
        let finalMinus3 = isPrevDay
            ? calendar.date(bySettingHour: 0, minute: 0, second: 0, of: now)!
            : minus3
        let timeMinus3 = formatter.string(from: finalMinus3)

        // +3시간 계산
        let plus3 = calendar.date(byAdding: .hour, value: 3, to: now)!
        let isNextDay = !calendar.isDate(plus3, inSameDayAs: now)
        let finalPlus3 = isNextDay
            ? calendar.date(bySettingHour: 23, minute: 59, second: 0, of: now)!
            : plus3
        let timePlus3 = formatter.string(from: finalPlus3)

        print("\(timeMinus3) ~ \(timePlus3)")

        self.stHourMin = timeMinus3
        self.enHourMin = timePlus3
    }
    
    func nowtime() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmm"
        let timeString = formatter.string(from: Date())
        
        var returnTime: Int = 0
        if let tmpInt = Int(timeString){
            returnTime = tmpInt
        }
        return returnTime
    }
    
    func fetchFlights() async {
        guard let url = URL(string: "https://www.airport.co.kr/gimpo/ajaxf/frPryInfoSvc/getPryInfoList.do?pInoutGbn=O&pAirport=\(airportName.description)&pActDate=\(actDate.description)&pSthourMin=\(stHourMin.description)&pEnhourMin=\(enHourMin.description)") else {
            print("❌ 잘못된 URL입니다.")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                print("❌ 서버 응답 오류: \(response)")
                return
            }
            
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(FlightListResponse.self, from: data)
            self.flights = decodedResponse.data.list
//            print(self.flights)
            
        } catch {
//            print("❌ 디코딩 실패: \(error)")
//            print("📦 응답 원문:\n", String(data: data, encoding: .utf8) ?? "데이터 없음")
            
            print("❌ 데이터 불러오기 실패: \(error.localizedDescription)")
        }
    }
}
