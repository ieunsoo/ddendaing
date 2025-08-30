//
//  FlightsWidgetLiveActivity.swift
//  FlightsWidget
//
//  Created by lee eunsoo on 8/30/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct FlightsWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct FlightsWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FlightsWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension FlightsWidgetAttributes {
    fileprivate static var preview: FlightsWidgetAttributes {
        FlightsWidgetAttributes(name: "World")
    }
}

extension FlightsWidgetAttributes.ContentState {
    fileprivate static var smiley: FlightsWidgetAttributes.ContentState {
        FlightsWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: FlightsWidgetAttributes.ContentState {
         FlightsWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: FlightsWidgetAttributes.preview) {
   FlightsWidgetLiveActivity()
} contentStates: {
    FlightsWidgetAttributes.ContentState.smiley
    FlightsWidgetAttributes.ContentState.starEyes
}
