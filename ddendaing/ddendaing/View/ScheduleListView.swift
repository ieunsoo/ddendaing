import SwiftUI

struct ScheduleListView: View {
    @StateObject var viewModel = FlightViewModel()
    
    @State var seletedAirport: String = "김해국제공항"
    @State var seletedAirline: Flight?
    @State private var showAlert = false
    @State private var showBarcodeScanner = false
    
    ///picker에서 선택하기 위한 공항 종류 리스트
    var airportNames: [String] = [
        "인천국제공항",
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
    
    /// IATA코드를 한글공항이름으로 변경해주는 함수
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
    
    /// 한글공항이름을 IATA코드로 변경해주는 함수
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
                        
                        //MARK: title
                        Text("\(printAirportName(IATA: viewModel.airportName))")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                        
                        //MARK: Toolbar
                        HStack{
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
                            Spacer()
                            Button(action: {
                                showBarcodeScanner.toggle()
                            }, label: {
                                Image(systemName: "camera.aperture")
                            })
                            .popover(isPresented: $showBarcodeScanner) {
                                QRCodeScannerView()
                            }
                            
                            
                            Button("새로고침"){
                                Task{
                                    await viewModel.fetchFlights()
                                }
                            }
                        }
                    }
                    .padding()

                    
                    FocusBlock(seletedAirline: $seletedAirline, showAlert: $showAlert)
                    
                    
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
