//
//  PlacesDisplayViewController.swift
//  AugmentedMapView
//
//  Created by Rajeev TC on 2024/02/04.
//

import UIKit
import MapKit
import HDAugmentedReality
import Combine

class PlacesDisplayViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var arContainerView: UIView!
    private let locationManager = CLLocationManager()
    private var presenter: PlacesDisplayPresenterInput!
    private var arViewController: ARViewController!
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        presenter = PlacesDisplayPresenter(view: self, model: PlacesDisplayModel())
        configureToRetrieveLocation()
        setupArCameraView()
    }

    func configureToRetrieveLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
    }

    func setupArCameraView() {
        arViewController = ARViewController()
        arViewController.dataSource = self
        addChild(arViewController)
        arContainerView.addSubview(arViewController.view)
    }
}

extension PlacesDisplayViewController: PlacesDisplayPresenterOutput {
    @MainActor
    func showPoiListOnMap(annotation: PlaceAnnotation) {
        mapView.addAnnotation(annotation)
        arViewController.setAnnotations(presenter.places)
    }

    func handleError(error: PlacesApiError) {
        let alert = UIAlertController(title: Constants.errorTitle , message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension PlacesDisplayViewController: ARDataSource {
    func ar(
        _ arViewController: HDAugmentedReality.ARViewController,
        viewForAnnotation: HDAugmentedReality.ARAnnotation
    ) -> HDAugmentedReality.ARAnnotationView {
        // Annotation views should be lightweight views, try to avoid xibs and autolayout all together.
        let annotationView = AnnotationView()
        annotationView.annotation = viewForAnnotation
        annotationView.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { annotation in
                if let annotation = annotationView.annotation as? Place {
                    self.showInfoView(forPlace: annotation)
                }
            })
            .store(in: &cancellables)

        annotationView.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        return annotationView
    }

    func showInfoView(forPlace place: Place) {
        let alert = UIAlertController(title: place.placeName , message: place.infoText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        arViewController.present(alert, animated: true, completion: nil)
    }
}

extension PlacesDisplayViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            if location.horizontalAccuracy < 100 {
                manager.stopUpdatingLocation()
                let span = MKCoordinateSpan(latitudeDelta: 0.014, longitudeDelta: 0.014)
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                mapView.region = region
                if !presenter.startedLoadingPOIs {
                    presenter.loadNearbyPoiList(location: location, radius: 1000)
                }
            }
        }
    }
}
