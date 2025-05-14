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
    
    
    
    
    var airportName: String = "GMP"
    var actDate: String = "20250513"
    var stHourMin: String = "1000"
    var enHourMin: String = "1900"
    
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
            print(self.flights)
            
        } catch {
//            print("❌ 디코딩 실패: \(error)")
//            print("📦 응답 원문:\n", String(data: data, encoding: .utf8) ?? "데이터 없음")
            
            print("❌ 데이터 불러오기 실패: \(error.localizedDescription)")
        }
    }
}
