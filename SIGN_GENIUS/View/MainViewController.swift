import UIKit
import Vision
import CoreMedia
import AVFoundation

class MainViewController: UIViewController {

    @IBOutlet weak var videoPreview: UIView!
    @IBOutlet weak var boxesView: DrawingBoundingBoxView!
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    {
        didSet {
            logoutButton.titleLabel?.font = UIConfiguration.buttonFont
            logoutButton.layer.borderWidth = 1
            logoutButton.layer.borderColor = UIColor.black.cgColor
            logoutButton.layer.cornerRadius = logoutButton.frame.height / 2
            logoutButton.clipsToBounds = true
        }
    }
    @IBOutlet weak var changeCamera: UIButton!
    {
        didSet {
            changeCamera.titleLabel?.font = UIConfiguration.buttonFont
        }
    }
    lazy var handDectectionModel = { return try? handDectection() }()
    lazy var handClasificationModel = { return try? handClasification() }()
    
    // MARK: - Vision Properties
    var handDectectionRequest: VNCoreMLRequest?
    var handDectectionMLModel: VNCoreMLModel?
    var handClasificationRequest: VNCoreMLRequest?
    var handClasificationMLModel: VNCoreMLModel?
    let speechSynthesizer = AVSpeechSynthesizer()
    var isSpeaking = false
    
    // MARK: - AV Property
    var videoCapture: VideoCapture!
    let semaphore = DispatchSemaphore(value: 1)
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the model
        setUpModel()
        
        // setup camera
        setUpCamera()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.videoCapture.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.videoCapture.stop()
    }
    
    // MARK: - Setup Core ML
    func setUpModel() {
        guard let handDectectionModel = handDectectionModel else { fatalError("fail to load the model") }
        if let visionModel = try? VNCoreMLModel(for: handDectectionModel.model) {
            self.handDectectionMLModel = visionModel
            handDectectionRequest = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
            handDectectionRequest?.imageCropAndScaleOption = .scaleFill
        } else {
            fatalError("fail to create vision model")
        }
        
        guard let handClasificationModel = handClasificationModel else { fatalError("fail to load the handClasification model") }
        if let visionModel = try? VNCoreMLModel(for: handClasificationModel.model) {
            self.handClasificationMLModel = visionModel
        } else {
            fatalError("fail to create vision model for handClasification")
        }
    }

    // MARK: - SetUp Video
    func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.fps = 30
        videoCapture.setUp(sessionPreset: .vga640x480) { success in
            
            if success {
                if let previewLayer = self.videoCapture.previewLayer {
                    self.videoPreview.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }
                
                self.videoCapture.start()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizePreviewLayer()
    }
    
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = videoPreview.bounds
    }
    
    var logoutAction: (() -> Void)?
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        logoutAction?()
    }
    @IBAction func changeCamera(_ sender: Any) {
        self.videoPreview.layer.removeAllAnimations()
        speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        self.videoCapture.stop()
        self.videoCapture.switchCamera(){ success in
            
            if success {
                if let previewLayer = self.videoCapture.previewLayer {
                    self.videoPreview.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }
                
                self.videoCapture.start()
            }
        }
    }
}

// MARK: - VideoCaptureDelegate
extension MainViewController: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        if let pixelBuffer = pixelBuffer {
            self.predictUsingVision(pixelBuffer: pixelBuffer)
        }
    }
}

extension MainViewController {
    func predictUsingVision(pixelBuffer: CVPixelBuffer) {
        guard let request = handDectectionRequest else { fatalError() }
        self.semaphore.wait()
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }
    
    // MARK: - Post-processing
    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        if let predictions = request.results as? [VNRecognizedObjectObservation] {
            DispatchQueue.main.async {
                self.boxesView.predictedObjects = predictions
            }
            processPredictions(predictions: predictions)

        }
        self.semaphore.signal()
    }
    
    func processPredictions(predictions: [VNRecognizedObjectObservation]) {
        guard let handClasificationModel = handClasificationModel else { fatalError("fail to load the handClasification model") }
        
        for prediction in predictions {
            guard let pixelBuffer = videoCapture.currentPixelBuffer else {
                return
            }
            let croppedPixelBuffer = cropPixelBuffer(pixelBuffer, prediction.boundingBox)
            let handler = VNImageRequestHandler(cvPixelBuffer: croppedPixelBuffer, options: [:])
            let request = VNCoreMLRequest(model: handClasificationMLModel!) { request, error in
                if let results = request.results as? [VNClassificationObservation], let topResult = results.first {
                    for result in results {
                     print("Class: \(result.identifier), Confidence: \(result.confidence)")
                     }
                    DispatchQueue.main.async {
                        if !self.isSpeaking {
                            self.isSpeaking = true
                            self.speak(text: topResult.identifier)
                        }
                    }
                    
                }
            }
            try? handler.perform([request])
        }
    }
    
    func speak(text: String) {
        self.predictionLabel.text = text.uppercased()
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = preferredVoice(for: "es_ES")
        speechUtterance.rate = 0.2
        speechUtterance.volume = 1.0
        speechSynthesizer.delegate = self
        speechSynthesizer.speak(speechUtterance)
    }
    
    func preferredVoice(for language: String) -> AVSpeechSynthesisVoice {
        if let availableVoice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.language == language }) {
            return availableVoice
        } else {
            return AVSpeechSynthesisVoice()
        }
    }
    
    func cropPixelBuffer(_ pixelBuffer: CVPixelBuffer, _ boundingBox: CGRect) -> CVPixelBuffer {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)

         let imageSize = CGSize(width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))

         let topLeft = CGPoint(x: boundingBox.origin.x * imageSize.width, y: (1 - boundingBox.origin.y - boundingBox.size.height) * imageSize.height)
         let bottomRight = CGPoint(x: (boundingBox.origin.x + boundingBox.size.width) * imageSize.width, y: (1 - boundingBox.origin.y) * imageSize.height)
         let croppedRect = CGRect(x: topLeft.x, y: topLeft.y, width: bottomRight.x - topLeft.x, height: bottomRight.y - topLeft.y)

         let croppedImage = ciImage.cropped(to: croppedRect)

         let context = CIContext()
         var croppedPixelBuffer: CVPixelBuffer?
         let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(croppedRect.width), Int(croppedRect.height), kCVPixelFormatType_32BGRA, nil, &croppedPixelBuffer)

         if status != kCVReturnSuccess {
             fatalError("Error: Could not create cropped CVPixelBuffer.")
         }

         if let croppedPixelBuffer = croppedPixelBuffer {
             context.render(croppedImage, to: croppedPixelBuffer)
         } else {
             fatalError("Error: Cropped pixel buffer is nil.")
         }

         return croppedPixelBuffer!
    }
}

extension MainViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("Habló la frase: \(utterance)")
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) {_ in
            self.isSpeaking = false
        }
    }
}
