import UIKit
import SwiftUI

public struct MapComponentViewRepresentable: UIViewRepresentable {
    var config: MapComponentConfiguration
    
    public init(config: MapComponentConfiguration) {
        self.config = config
    }
    
    public func makeUIView(context: Context) -> MapComponentView {
        let mapView = MapComponentView()
        mapView.configure(with: config)
        return mapView
    }
    
    public func updateUIView(_ uiView: MapComponentView, context: Context) {
        uiView.configure(with: config)
    }
}
