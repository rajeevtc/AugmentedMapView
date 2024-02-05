//
//  AnnotationView.swift
//  AugmentedMapView
//
//  Created by Rajeev TC on 2024/02/05.
//

import UIKit
import HDAugmentedReality
import Combine

class AnnotationView: ARAnnotationView {
    var tapPublisher = PassthroughSubject<AnnotationView, Never>()

    var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = UIColor.white
        return label
    }()

    var distanceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.green
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        loadUI()
    }

    func loadUI() {
        backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        titleLabel.removeFromSuperview()
        distanceLabel.removeFromSuperview()

        titleLabel.frame = CGRect(x: 10, y: 0, width: self.frame.size.width - 10, height: 30)
        self.addSubview(titleLabel)

        distanceLabel.frame = CGRect(x: 10, y: 30, width: self.frame.size.width - 10, height: 20)
        self.addSubview(distanceLabel)

        if let annotation = annotation as? Place {
            titleLabel.text = annotation.placeName
            distanceLabel.text = String(format: "%.2f km", annotation.distanceFromUser / 1000)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 10, y: 0, width: self.frame.size.width - 10, height: 30)
        distanceLabel.frame = CGRect(x: 10, y: 30, width: self.frame.size.width - 10, height: 20)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tapPublisher.send(self)
    }
}
