import Foundation
import SwiftUI
import AVFoundation

// MARK: - BoardingPass 모델
struct BoardingPass {
    let passengerName: String
    let pnrCode: String
    let from: String
    let to: String
    let operatingCarrier: String
    let flightNumber: String
    let dateOfFlight: String
    let compartment: String
    let seatNumber: String
    let checkInSequence: String
    let passengerStatus: String
}

// MARK: - BCBP 파서
struct BCBPParser {
    static func parse(_ data: String) -> BoardingPass? {
        guard data.count >= 60 else {
            print("데이터 길이가 부족합니다.")
            return nil
        }
        
        let chars = Array(data)
        
        let passengerName = String(chars[2..<22]).trimmingCharacters(in: .whitespaces)
        let pnrCode = String(chars[23..<30]).trimmingCharacters(in: .whitespaces)
        let from = String(chars[30..<33])
        let to = String(chars[33..<36])
        let operatingCarrier = String(chars[36..<39])
        let flightNumber = String(chars[39..<44]).trimmingCharacters(in: .whitespaces)
        let dateOfFlight = String(chars[44..<47])
        let compartment = String(chars[47..<48])
        let seatNumber = String(chars[48..<52]).trimmingCharacters(in: .whitespaces)
        let checkInSequence = String(chars[52..<57]).trimmingCharacters(in: .whitespaces)
        let passengerStatus = String(chars[57..<58])
        
        return BoardingPass(
            passengerName: passengerName,
            pnrCode: pnrCode,
            from: from,
            to: to,
            operatingCarrier: operatingCarrier,
            flightNumber: flightNumber,
            dateOfFlight: dateOfFlight,
            compartment: compartment,
            seatNumber: seatNumber,
            checkInSequence: checkInSequence,
            passengerStatus: passengerStatus
        )
    }
}

// MARK: - ViewModel
class ScannerViewModel: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    @Published var scannedCode: String = "No code scanned yet"
    @Published var boardingPass: BoardingPass? = nil
    @Published var showPermissionAlert: Bool = false
    private var captureSession: AVCaptureSession?
    
    func startScanning() {
        guard let captureSession = captureSession else { return }
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  let stringValue = readableObject.stringValue else { return }
            
            DispatchQueue.main.async {
                self.scannedCode = stringValue
                self.boardingPass = BCBPParser.parse(stringValue)
            }
            
            captureSession?.stopRunning()
        }
    }
    
    func setupCaptureSession() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.setupSession()
                    } else {
                        self.showPermissionAlert = true
                    }
                }
            }
        default:
            showPermissionAlert = true
        }
    }
    
    private func setupSession() {
        let captureSession = AVCaptureSession()
        self.captureSession = captureSession
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch { return }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else { return }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.pdf417]
        } else { return }
        
        captureSession.startRunning()
    }
}

// MARK: - SwiftUI View
struct QRCodeScannerView: View {
    @StateObject private var scannerViewModel = ScannerViewModel()
    
    var body: some View {
        VStack {
            Text("PDF417 Boarding Pass Scanner")
                .font(.title)
                .padding()
            
            // 카메라 미리보기
            ZStack {
                ScannerView(scannerViewModel: scannerViewModel)
//                    .frame(maxWidth: .infinity, maxHeight: 300)
                
                Rectangle()
                    .fill(Color.clear)
                    .border(Color.red, width: 2)
                    .frame(width: 250, height: 150)
            }
            
            // 결과 출력
            if let bp = scannerViewModel.boardingPass {
                VStack(alignment: .leading, spacing: 8) {
                    Text("승객명: \(bp.passengerName)")
                    Text("예약번호: \(bp.pnrCode)")
                    Text("출발 → 도착: \(bp.from) → \(bp.to)")
                    Text("항공사: \(bp.operatingCarrier)")
                    Text("편명: \(bp.flightNumber)")
                    Text("출발일(Julian): \(bp.dateOfFlight)")
                    Text("좌석: \(bp.seatNumber) (\(bp.compartment))")
                    Text("체크인 순번: \(bp.checkInSequence)")
                    Text("승객 상태: \(bp.passengerStatus)")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            } else {
                Text("No boarding pass parsed yet")
                    .foregroundColor(.gray)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            scannerViewModel.setupCaptureSession()
        }
        .alert(isPresented: $scannerViewModel.showPermissionAlert) {
            Alert(
                title: Text("Camera Permission Required"),
                message: Text("Please enable camera access in Settings to scan barcodes."),
                primaryButton: .default(Text("Open Settings")) {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}

// MARK: - 카메라 미리보기 Wrapper
struct ScannerView: UIViewControllerRepresentable {
    @ObservedObject var scannerViewModel: ScannerViewModel
    
    func makeUIViewController(context: Context) -> ScannerViewController {
        let scannerViewController = ScannerViewController()
        scannerViewController.delegate = scannerViewModel
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {}
}

// MARK: - UIKit 카메라 컨트롤러
class ScannerViewController: UIViewController {
    var delegate: AVCaptureMetadataOutputObjectsDelegate?
    private var captureSession: AVCaptureSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureSession = AVCaptureSession()
        self.captureSession = captureSession
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch { return }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else { return }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.pdf417]
        } else { return }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
}

#Preview {
    QRCodeScannerView()
}
