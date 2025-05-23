//
//  ScheduleListView.swift
//  KoreaAirportInfo
//
//  Created by eunsoo on 5/11/25.
//

import SwiftUI

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

struct ScheduleListView: View {
    @StateObject var viewModel = FlightViewModel()
    
    @State var seletedAirport: String = "김해국제공항"
    @State var seletedAirline: Flight?
    @State private var showAlert = false
    
    var airportNames: [String] = [
//        "인천국제공항",
        "김포국제공항",
        "김해국제공항",
        "제주국제공항",
//        "무안국제공항",
//        "양양국제공항",
        "청주국제공항",
        "대구국제공항",
//        "포항경주공항"
        
//        "원주공항",
//        "울산공항",
//        "사천공항",
//        "군산공항",
//        "광주공항",
//        "여수공항"
    ]
    
    func printAirportName(IATA: String) -> String{
        var airportName: String = ""
        /*
         "인천국제공항",
         "김포국제공항",
         "김해국제공항",
         "제주국제공항",
         "무안국제공항",
         "양양국제공항",
         "청주국제공항",
         "대구국제공항",
         "포항경주공항"
         */
        switch IATA {
        case "ICN":
            airportName = "인천국제공항"
        case "GMP":
            airportName = "김포국제공항"
        case "PUS":
            airportName = "김해국제공항"
        case "CJU":
            airportName = "제주국제공항"
        case "MWX":
            airportName = "무안국제공항"
        case "YNY":
            airportName = "양양국제공항"
        case "CJJ":
            airportName = "청주국제공항"
        case "TAE":
            airportName = "대구국제공항"
        case "KPO":
            airportName = "포항경주공항"
        default:
            airportName = "알 수 없는 공항"
        }
        
        return airportName
    }
    func printIATA(airportName: String) -> String{
        var airportIATA: String = ""
        
        switch airportName {
        case "인천국제공항":
            airportIATA = "ICN"
        case "김포국제공항":
            airportIATA = "GMP"
        case "김해국제공항":
            airportIATA = "PUS"
        case "제주국제공항":
            airportIATA = "CJU"
        case "무안국제공항":
            airportIATA = "MWX"
        case "양양국제공항":
            airportIATA = "YNY"
        case "청주국제공항":
            airportIATA = "CJJ"
        case "대구국제공항":
            airportIATA = "TAE"
        case "포항경주공항":
            airportIATA = "KPO"
        default:
            airportIATA = "PUS"
        }
        
        
        return airportIATA
    }
    
    var body: some View {
            NavigationView {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(printAirportName(IATA: viewModel.airportName))")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                        
                        Picker("공항 선택", selection: $seletedAirport) {
                            ForEach(airportNames, id: \.self) { airport in
                                Text(airport)
                            }
                        }.onChange(of: seletedAirport){
                            viewModel.airportName = printIATA(airportName: $0)
                            Task{
                                await viewModel.fetchFlights()
                            }
                        }
                    }
                    .padding()

                    
                    
                    //MARK: - 상단 주시 항공편 블록
                    ZStack(alignment: .leading){
//                        ZStack{
//                            Button(action: {
//                                seletedAirline = nil
//                            }, label: {
//                                Image(systemName: "star.fill")
//                                    .foregroundStyle(.white)
//                            })
//                        }.frame(maxWidth: .infinity)
                        
                        if let tmpAirline = seletedAirline{
                            VStack(alignment: .leading){
                                HStack(alignment: .bottom){
                                    Text(tmpAirline.airline)
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                    Text(tmpAirline.flightNumber)
                                        .foregroundStyle(.white)
                                }
                                .fontWeight(.heavy)
                                
                                HStack{
                                    Text("\(tmpAirline.destination ?? "⚠️") 행")
                                        .foregroundStyle(.white)
                                        .font(.subheadline)
                                
                                    Text("출발시간: \(tmpAirline.etd.prefix(2)):\(tmpAirline.etd.suffix(2))")
                                        .font(.subheadline)
                                        .foregroundStyle(.white)
                                    
                                    Text("탑승구: \(tmpAirline.gate ?? "⚠️")")
                                        .font(.subheadline)
                                        .foregroundStyle(.white)
                                    
                                    if let status = tmpAirline.status {
                                        Text(status)
                                            .font(.caption)
                                            .foregroundColor(status.contains("사전결항") ? .orange : .blue)
                                    }
                                }
                                .fontWeight(.heavy)
                            }
                            .padding()
                            
                            
                            
                        }else{
                            HStack{
                                Text("저장된 항공편이 없습니다.")
                                    .foregroundStyle(.white)
                                    .font(.title2)
                                    .fontWeight(.heavy)
                            }
                            .padding()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 140)
                    .background(.blue)
                    .cornerRadius(15)
                    .padding(8)
                    .onTapGesture {
                        showAlert.toggle()
                        
                    }.alert("저장된 항공편을 삭제합니다.", isPresented: $showAlert) {
                        Button("Delete", role: .destructive) {
                            seletedAirline = nil
                        }
                      }
                    
                    //MARK: - 항공편 리스트
                    List(viewModel.flights) { flight in
                        VStack(alignment: .leading) {
                            HStack(spacing: 4) {
                                Text("\(flight.flightNumber) |  \(flight.airline)")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Button(action: {
                                    seletedAirline = flight
                                }){
                                    if seletedAirline?.flightNumber == flight.flightNumber {
                                       Image(systemName: "star.fill")
                                    }else{
                                        Image(systemName: "star")
                                    }
                                }
                                
                            }
                            
                            HStack{
                                Text("\(flight.destination ?? "⚠️")")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                
                                if flight.std == flight.etd {
                                    Text("\(flight.etd.prefix(2)):\(flight.etd.suffix(2))")
                                        .font(.subheadline)
                                }else{
//                                    Text("출발시간 :")
//                                        .font(.subheadline)
                                    Text("\(flight.std.prefix(2)):\(flight.std.suffix(2))")
                                        .font(.subheadline)
                                        .strikethrough()
                                        .foregroundStyle(.gray)
                                    
                                    Text("→  \(flight.etd.prefix(2)):\(flight.etd.suffix(2))")
                                        .font(.subheadline)
                                }
                                
                                Text("탑승구: \(flight.gate ?? "⚠️")")
                                    .font(.subheadline)
                                    
                                
                                if let status = flight.status {
                                    Text(status)
                                        .font(.caption)
//                                        .foregroundColor(status.contains("지연") ? .red : .blue)
                                        .foregroundColor(status.contains("사전결항") ? .orange : .blue)
                                }
                            }
                        }
                        .padding(.vertical, 6)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
                .navigationTitle("") // 제목은 직접 텍스트로
                .navigationBarHidden(true)
                .task {
                    await viewModel.fetchFlights()
                }
            }
        }
    }
#Preview {
    ScheduleListView()
}
