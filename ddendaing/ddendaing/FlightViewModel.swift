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
    var actDate: String
    var stHourMin: String
    var enHourMin: String
    
    init(){
        let now = Date()
        let calendar = Calendar.current

        // MARK: - Date Formatters
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HHmm"  // 24시간제 시분 형식

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        // MARK: - 현재 시간
        let currentTimeHHmm = timeFormatter.string(from: now)

        // MARK: - -3시간 계산 (이전 날짜면 0000 고정)
        let threeHoursBefore = calendar.date(byAdding: .hour, value: -2, to: now)!
        let isBeforeToday = !calendar.isDate(threeHoursBefore, inSameDayAs: now)
        let adjustedMinusDate = isBeforeToday
            ? calendar.date(bySettingHour: 0, minute: 0, second: 0, of: now)!
            : threeHoursBefore
        let startHourMinute = timeFormatter.string(from: adjustedMinusDate)

        // MARK: - +3시간 계산 (다음 날짜면 2359 고정)
        let threeHoursLater = calendar.date(byAdding: .hour, value: 3, to: now)!
        let isAfterToday = !calendar.isDate(threeHoursLater, inSameDayAs: now)
        let adjustedPlusDate = isAfterToday
            ? calendar.date(bySettingHour: 23, minute: 59, second: 0, of: now)!
            : threeHoursLater
        let endHourMinute = timeFormatter.string(from: adjustedPlusDate)

        // MARK: - 오늘 날짜 (yyyyMMdd 형식)
        let activeDate = dateFormatter.string(from: now)

        // 디버그 출력
        print("\(startHourMinute) ~ \(endHourMinute)")

        // 저장
        self.stHourMin = startHourMinute
        self.enHourMin = endHourMinute
        self.actDate = activeDate
        
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
