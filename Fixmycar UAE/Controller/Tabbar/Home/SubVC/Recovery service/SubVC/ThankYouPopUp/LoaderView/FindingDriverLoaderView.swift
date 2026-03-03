//
//  FindingDriverLoaderView.swift
//  Fixmycar UAE
//
//  Created by Kenil on 03/03/26.
//

import UIKit

class FindingDriverLoaderView: UIView {
    
    private let dashedCircle = CAShapeLayer()
    private let innerCircle = CAShapeLayer()
    private let pinView = UIImageView()
    
    private let carContainer = UIView()
    private let carView = UIImageView()
    
    private let orbitRadius: CGFloat = 45
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dashedCircle.frame = bounds
        innerCircle.frame = bounds
        carContainer.frame = bounds
        
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        
        // Update circle paths based on real bounds
        let dashedPath = UIBezierPath(
            ovalIn: bounds.insetBy(dx: 10, dy: 10)
        )
        dashedCircle.path = dashedPath.cgPath
        
        let innerPath = UIBezierPath(
            ovalIn: bounds.insetBy(dx: 25, dy: 25)
        )
        innerCircle.path = innerPath.cgPath
        
        // Center Pin
        pinView.center = centerPoint
        
        // Place car at top of circle
        carView.center = CGPoint(
            x: centerPoint.x,
            y: centerPoint.y - orbitRadius
        )
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .clear
        
        // Dashed Circle
        dashedCircle.fillColor = UIColor.clear.cgColor
        dashedCircle.strokeColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        dashedCircle.lineWidth = 2
        dashedCircle.lineDashPattern = [6,6]
        layer.addSublayer(dashedCircle)
        
        // Inner Red Circle
        innerCircle.fillColor = UIColor.systemRed.withAlphaComponent(0.1).cgColor
        innerCircle.strokeColor = UIColor.systemRed.withAlphaComponent(0.3).cgColor
        innerCircle.lineWidth = 2
        layer.addSublayer(innerCircle)
        
        // Center Pin
        pinView.image = UIImage(named: "ic_location_pin")
        pinView.tintColor = .systemRed
        pinView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        addSubview(pinView)
        
        // Car Container
        addSubview(carContainer)
        
        // Car Image
        carView.image = UIImage(systemName: "car.side.fill")
        carView.tintColor = .black
        carView.frame = CGRect(x: 0, y: 0, width: 36, height: 22)
        carView.transform = CGAffineTransform(scaleX: -1, y: 1)
        carContainer.addSubview(carView)
    }
    
    // MARK: - Start Animation When Visible
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if window != nil {
            startRotation()
        }
    }
    
    private func startRotation() {
        
        // Remove old animation if exists
        carContainer.layer.removeAnimation(forKey: "orbitRotation")
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 2.0
        rotation.repeatCount = .infinity
        rotation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        carContainer.layer.add(rotation, forKey: "orbitRotation")
    }
}
