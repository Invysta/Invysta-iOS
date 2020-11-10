//
//  ViewController.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit
import Lottie
import Alamofire

class ViewController: UIViewController, URLSessionDelegate {

    private var identifierManager: IdentifierManager?
    private var networkManager: NetworkManager?
    private var browserData: BrowserData?
    
    private let loadingView: AnimationView = {
        let view = AnimationView()
        view.animation = Animation.named("loading")
        view.animationSpeed = 1
        view.loopMode = .loop
        view.play()
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(_ browserData: BrowserData) {
        super.init(nibName: nil, bundle: nil)
        networkManager = NetworkManager()
        identifierManager = IdentifierManager(browserData, [
                                                VendorIdentifier(),
                                                AdvertiserIdentifier(),
                                                CustomIdentifier(),
                                                DeviceModelIdentifier(),
                                                DeviceCheckIdentifier(),
                                                AccessibilityIdentifier()])
        self.browserData = browserData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = UIColor.white
        }
        
        displaySettingButton()
        
        if let browserData = self.browserData {
            displayLoadingView()
            requestXACIDKey(browserData)
            
            if FeatureFlag.showDebuggingTextField {
                let text = """
                            action: \(browserData.action!)\n
                            encData: \(browserData.encData!)\n
                            magic: \(browserData.magic ?? "na")\n
                            oneTimeCode: \(browserData.oneTimeCode!)
                    """
                createDebuggingField(text)
            }
            
        }
    }
 
    func requestXACIDKey(_ browserData: BrowserData) {
        let requestURL = RequestURL(requestType: .get, action: browserData.action)
        networkManager?.call(requestURL, completion: { [weak self] (data, response, error) in
            guard let res = response as? HTTPURLResponse else { return }
            if let xacid = res.allHeaderFields["X-ACID"] as? String {
                print("X-ACID",xacid)
                if requestURL.action! == "reg" {
                    self?.register(xacid)
                } else if requestURL.action! == "log" {
                    self?.authenticate(with: xacid)
                }
            }
        })
    }
    
    func register(_ xacid: String) {
        let headers: HTTPHeaders = [.authorization(bearerToken: browserData!.encData!), .accept("text/html")]

//        let x: HTTPHeaders = [.authorization(bearerToken: browserData!.encData!)]
        AF.request("https://invystasafe.com/register", method: .post, headers: headers).responseString { (response) in
            print(response)
        }
        
    }
    
//    func register(_ xacid: String) {
//        let session = URLSession.shared
//        let body = identifierManager?.compileSources()
//        var urlRequest = URLRequest(url: URL(string: "https://invystasafe.com/register")!)
//        urlRequest.httpMethod = "POST"
//
////        urlRequest.httpBody
//        urlRequest.setValue(xacid, forHTTPHeaderField: "X-ACID")
//        urlRequest.setValue(browserData!.encData!, forHTTPHeaderField: "Authorization")
//        urlRequest.setValue("text/html", forHTTPHeaderField: "Content-Type")
//
//        session.dataTask(with: urlRequest) { (data, response, error) in
//            guard let res = response as? HTTPURLResponse else { return }
//            print("Response",res)
//            if (200...299).contains(res.statusCode) {
//                print("Worked!")
//            }
//        }.resume()
//    }
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
         
    }
    func registerDevice(with xacid: String) {
        let body = identifierManager?.compileSources()
        var requestURL = RequestURL(requestType: .post, body: body, xacid: xacid, action: browserData!.action!)
        requestURL.userIDAndPassword = browserData?.encData ?? "encData nil"
        
        networkManager?.call(requestURL, completion: { (data, response, error) in
            guard let res = response as? HTTPURLResponse else { return }
            print("Response",res)
            if (200...299).contains(res.statusCode) {
                print("Worked!")
            }
        })
    }
    
    func authenticate(with xacid: String) {
        let body = identifierManager?.compileSources()
        let requestURL = RequestURL(requestType: .post, body: body, xacid: xacid, action: browserData!.action)
        
        networkManager?.call(requestURL, completion: { (data, response, error) in
            guard let res = response as? HTTPURLResponse else { return }
            if (200...299).contains(res.statusCode) {
                print("Worked!")
            }
        })
    }
    
    private func createDebuggingField(_ text: String) {
        let debuggingTextField = UITextView()
        debuggingTextField.text = text
        debuggingTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(debuggingTextField)
        
        NSLayoutConstraint.activate([debuggingTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     debuggingTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     debuggingTextField.heightAnchor.constraint(equalToConstant: 150),
                                     debuggingTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }

    @objc
    func moveToSettings() {
        let vc = SettingsController()
        let nav = UINavigationController()
        nav.viewControllers = [vc]
        present(nav, animated: true, completion: nil)
    }
    
    func displaySettingButton() {
        let settingButton = UIButton()
        settingButton.setImage(UIImage(named: "settings"), for: .normal)
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        settingButton.addTarget(self, action: #selector(moveToSettings), for: .touchUpInside)
        view.addSubview(settingButton)
        
        let padding: CGFloat = 15
        let size: CGFloat = 25
        
        NSLayoutConstraint.activate([
            settingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            settingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            settingButton.heightAnchor.constraint(equalToConstant: size),
            settingButton.widthAnchor.constraint(equalToConstant: size)
        ])
        view.layoutIfNeeded()
    }
    
    func displayLoadingView() {
        let loadingViewFrame: CGFloat = 200
        
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([loadingView.heightAnchor.constraint(equalToConstant: loadingViewFrame),
                                     loadingView.widthAnchor.constraint(equalToConstant: loadingViewFrame),
                                     loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        
        view.layoutIfNeeded()
    }
}
