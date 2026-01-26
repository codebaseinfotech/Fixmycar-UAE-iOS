//
//  UIView+Extention.swift
//  Fixmycar UAE
//
//  Created by Ankit on 07/01/26.
//

import Foundation
import UIKit

@IBDesignable
class AllSideCornerView: UIView {

    // MARK: - Inspectable Flags
    @IBInspectable var enableLeftTopCorner: Bool = false { didSet { setNeedsLayout() } }
    @IBInspectable var enableRightTopCorner: Bool = false { didSet { setNeedsLayout() } }
    @IBInspectable var enableLeftBottomCorner: Bool = false { didSet { setNeedsLayout() } }
    @IBInspectable var enableRightBottomCorner: Bool = false { didSet { setNeedsLayout() } }

    // MARK: - Corner Radius
    @IBInspectable var cornerRadiusSide: CGFloat = 12 {
        didSet { setNeedsLayout() }
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        applyCorners()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyCorners()
    }

    // MARK: - Corner Logic
    private func applyCorners() {

        var corners: UIRectCorner = []

        if enableLeftTopCorner { corners.insert(.topLeft) }
        if enableRightTopCorner { corners.insert(.topRight) }
        if enableLeftBottomCorner { corners.insert(.bottomLeft) }
        if enableRightBottomCorner { corners.insert(.bottomRight) }

        // Reset if no corner selected
        guard !corners.isEmpty else {
            layer.mask = nil
            return
        }

        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: cornerRadiusSide, height: cornerRadiusSide)
        )

        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = bounds
        shapeLayer.path = path.cgPath
        layer.mask = shapeLayer

        clipsToBounds = true
    }
}

extension UIView {
    func addGlassEffect(to view: UIView) {
        let blur = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurView, at: 0)
    }

}


class GlassButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setup() {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        blur.frame = bounds
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blur.layer.cornerRadius = bounds.height / 2
        blur.clipsToBounds = true

        insertSubview(blur, at: 0)

        backgroundColor = UIColor.white.withAlphaComponent(0.15)
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor
        layer.cornerRadius = bounds.height / 2
    }
}

extension UITableView {

    /// Check if indexPath is last row of last section
    func isLastRow(at indexPath: IndexPath) -> Bool {
        let lastSection = numberOfSections - 1
        let lastRow = numberOfRows(inSection: indexPath.section) - 1

        return indexPath.section == lastSection &&
               indexPath.row == lastRow
    }

    /// Check if indexPath is last row of its section
    func isLastRowInSection(_ indexPath: IndexPath) -> Bool {
        return indexPath.row == numberOfRows(inSection: indexPath.section) - 1
    }
}
