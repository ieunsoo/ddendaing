import SwiftUI
//MARK: - 상단 주시 항공편 블록
struct FocusBlock: View {
    @Binding var seletedAirline: Flight?
    @Binding var showAlert: Bool
    
    var body: some View{
        ZStack(alignment: .leading)
        {
            
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

    }
}

                    
