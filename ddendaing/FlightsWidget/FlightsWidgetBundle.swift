//
//  FlightsWidgetBundle.swift
//  FlightsWidget
//
//  Created by lee eunsoo on 8/30/25.
//

import WidgetKit
import SwiftUI

@main
struct FlightsWidgetBundle: WidgetBundle {
    var body: some Widget {
        FlightsWidget()
        FlightsWidgetControl()
        FlightsWidgetLiveActivity()
    }
}
