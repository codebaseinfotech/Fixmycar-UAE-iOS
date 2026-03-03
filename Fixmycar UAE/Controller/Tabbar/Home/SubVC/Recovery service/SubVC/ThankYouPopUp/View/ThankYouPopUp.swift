//
//  ThankYouPopUp.swift
//  Fixmycar UAE
//
//  Created by Kenil on 03/03/26.
//

import UIKit

class ThankYouPopUp: UIViewController {
    
    @IBOutlet weak var viewLoader: UIView!
    
    var loader: FindingDriverLoaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLoader()
        // Do any additional setup after loading the view.
    }
    
    func setupLoader() {
        loader = FindingDriverLoaderView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        
        viewLoader.addSubview(loader)
        
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: viewLoader.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: viewLoader.centerYAnchor),
            loader.widthAnchor.constraint(equalToConstant: 120),
            loader.heightAnchor.constraint(equalToConstant: 120)
        ])
    }

    @IBAction func tappedClose(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
}
