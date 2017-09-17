//
//  ComplicationController.swift
//  DIT Timtable watch Extension
//
//  Created by Timothy Barnard on 17/09/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    let userCalendar = NSCalendar.current
    let dateFormatter = DateFormatter()
    
    var complicationHandler = ComplicationHandler()
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDate(handler: @escaping (Date?) -> Void) {
        handler(Date(timeIntervalSinceNow: TimeInterval(10*60)))
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        handler(self.complicationHandler.getCurrentTimelineEntry(complication: complication))
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        handler(self.complicationHandler.getTimelineEntriesAfter(complication: complication))
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        handler(self.complicationHandler.getTimelineSampleData(complication: complication))
    }
    
    /*var dayFraction : Float {
        let now = Date()
        let calendar = Calendar.current
        let componentFlags = Set<Calendar.Component>([.year, .month, .day, .weekOfYear,     .hour, .minute, .second, .weekday, .weekdayOrdinal])
        var components = calendar.dateComponents(componentFlags, from: now)
        components.hour = 0
        components.minute = 0
        components.second = 0
        let startOfDay = calendar.date(from: components)!
        return Float(now.timeIntervalSince(startOfDay)) / Float(24*60*60)
    }*/
    
}
