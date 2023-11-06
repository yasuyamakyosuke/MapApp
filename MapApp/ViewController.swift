//
//  ViewController.swift
//  MapApp
//
//  Created by 泰山恭輔 on 2023/10/03.
//

import UIKit
import GoogleMaps
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var openMapButton: UIButton!
    
    private let dispose = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        openMapButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] in
                self?.openGoogleMaps()
            })
            .disposed(by: dispose)
    }
    
    private func openGoogleMaps() {
        guard let address = addressTextField.text, !address.isEmpty else {
            print("Please enter an address.")
            return
        }
        
        let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "https://www.google.com/maps/search/?api=1&query=\(encodedAddress)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.open(URL(string: "https://www.google.com/maps/search/?api=1&query=\(encodedAddress)")!, options: [:], completionHandler: nil)
            }
        } else {
            print("あわわわわ")
            print("Please enter an address.")
            print("コンフリクトを発生させます")
        }
    }
}
