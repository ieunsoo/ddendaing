#  api 필드들에 대한 설명

| 필드명         | 예측 의미 (설명)                                   |
|----------------|---------------------------------------------------|
| STD            | Scheduled Time of Departure (예정 출발 시각, 24시간제)[6] |
| ETD            | Estimated Time of Departure (예상 출발 시각, 24시간제)[2] |
| ETD1           | 추가/예비 예상 출발 시각 (ETD와 동일한 경우 많음)      |
| AIRPORT        | 출발 공항 코드 (예: TAE = 대구)                       |
| BOARDING_KOR   | 출발 공항 한글명 (예: 대구)                            |
| BOARDING_ENG   | 출발 공항 영문명 (예: DAEGU)                           |
| ARRIVED_KOR    | 도착지 한글명 (예: 오사카/간사이)                      |
| ARRIVED_ENG    | 도착지 영문명 (예: KANSAI)                             |
| VIA            | 경유지 IATA 코드 (예: KIX = 간사이)                    |
| VIA_KOR        | 경유지 한글명 (예: 오사카/간사이)                      |
| VIA_ENG        | 경유지 영문명 (예: KANSAI)                             |
| CITY           | 목적지 도시 IATA 코드 (예: KIX)                        |
| AIR_FLN        | 항공편 번호 (항공사 코드+숫자, 예: TW313)              |
| FLN            | 항공편 숫자 부분 (예: 313)                             |
| AIR_KOR        | 항공사 한글명 (예: 티웨이항공)                         |
| AIR_ENG        | 항공사 영문명 (예: T'WAY AIR CO.LTD)                   |
| AIR_IATA       | 항공사 IATA 코드 (예: TW)                              |
| AIR_ICAO       | 항공사 ICAO 코드 (예: TWB)                             |
| GATE           | 탑승구 번호 (예: 5)                                    |
| LINE           | 터미널/라인 구분 (예: I = 국제선, D = 국내선)          |
| IO             | 출입국 구분 (O = 출국, I = 입국)                       |
| RMK_KOR        | 상태 한글 (예: 탑승중, 지연, 수속중 등)                |
| RMK_ENG        | 상태 영문 (예: BOARDING, DELAY, PROCESSING 등)         |
| RMK_JPN        | 상태 일본어                                            |
| RMK_CHN        | 상태 중국어                                            |
| ACT_C_DATE     | 실제 운항일 (YYYYMMDD, 예: 20250511)                   |
| LINK_URL       | 항공사/항공편 관련 링크 (예: 항공사 홈페이지)           |

---

### 참고 및 추가 설명

- **STD/ETD/ETD1**:  
  - STD는 "스케줄상 출발 예정 시각",  
  - ETD는 "실제 또는 최신 예상 출발 시각"을 의미합니다[2][6].  
  - 두 값이 다르면 지연 등 상황 반영.
- **AIR_FLN/FLN**:  
  - AIR_FLN은 공식 항공편 번호(항공사코드+숫자),  
  - FLN은 그 중 숫자 부분만 따로 표기.
- **LINE/IO**:  
  - LINE은 노선 구분(국내선 D, 국제선 I 등),  
  - IO는 출입국 방향(Outbound/Inbound) 구분.
- **RMK_***:  
  - 각 언어별 상태 메시지(예: 수속중, 탑승중, 지연 등).
- **ACT_C_DATE**:  
  - 실제 운항일자(YYYYMMDD).
- **VIA/VIA_KOR/VIA_ENG**:  
  - 경유지 정보(없으면 직항).
- **GATE**:  
  - 탑승구 번호.
- **LINK_URL**:  
  - 관련 항공사/항공편 안내 링크.

---

