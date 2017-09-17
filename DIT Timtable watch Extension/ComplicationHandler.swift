//
//  ComplicationHandler.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 17/09/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import ClockKit

class ComplicationHandler {
    
    var database: Database?
    
    init() {
        database = Database()
    }
    
    func getTimelineSampleData(complication: CLKComplication) -> CLKComplicationTemplate? {
        
        switch complication.family {
            
            case .modularSmall:
                let template = CLKComplicationTemplateModularSmallSimpleText()
                template.textProvider = CLKSimpleTextProvider(text: "??:??")
                return template
                
            case .utilitarianSmall:
                let template = CLKComplicationTemplateUtilitarianSmallRingText()
                template.textProvider = CLKSimpleTextProvider(text: "??:??")
                return template
            
            case .modularLarge:
                let template = CLKComplicationTemplateModularLargeStandardBody()
                template.headerTextProvider = CLKSimpleTextProvider(text: "??:??")
                template.body1TextProvider = CLKSimpleTextProvider(text: "class name")
                template.body2TextProvider = CLKSimpleTextProvider(text: "class room")
                return template
            case .utilitarianLarge:
                let template = CLKComplicationTemplateUtilitarianLargeFlat()
                template.textProvider = CLKSimpleTextProvider(text: "??:??")
                return template
            default:
                NSLog("%@", "Unknown complication type: \(complication.family)")
                return nil
        }
    }

    
    func getCurrentTimelineEntry(complication: CLKComplication) -> CLKComplicationTimelineEntry? {
        
        guard let timetables = database?.getDayTimetable(dayNo: 0) else {
            return nil
        }
        
        switch complication.family {
            
            case .modularSmall:
                let template = CLKComplicationTemplateModularSmallSimpleText()
                template.textProvider = CLKSimpleTextProvider(text: timetables[0].timeStart)
                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                return entry
                
            case .utilitarianSmall:
                let template = CLKComplicationTemplateUtilitarianSmallRingText()
                template.textProvider = CLKSimpleTextProvider(text: timetables[0].timeStart)
                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                return entry
                
            case .modularLarge:
                let template = CLKComplicationTemplateModularLargeStandardBody()
                template.headerTextProvider = CLKSimpleTextProvider(text: timetables[0].timeStart)
                template.body1TextProvider = CLKSimpleTextProvider(text: timetables[0].moduleName)
                template.body2TextProvider = CLKSimpleTextProvider(text: timetables[0].roomNo)
                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                return entry
            case .utilitarianLarge:
                let template = CLKComplicationTemplateUtilitarianLargeFlat()
                template.textProvider = CLKSimpleTextProvider(text: timetables[0].timeStart)
                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                return entry
            default:
                NSLog("%@", "Unknown complication type: \(complication.family)")
                return nil
        }
    }
    
    func getTimelineEntriesAfter(complication: CLKComplication) -> [CLKComplicationTimelineEntry]? {
        
        var entries = [CLKComplicationTimelineEntry]()
        
        let today = Date()
        let day = today.weekday()
        let indexVal = (day+5) % 7
        
        guard let timetables = database?.getDayTimetable(dayNo: 0) else {
            return entries
        }
        
        for (index, timetable ) in timetables.enumerated() {
            
            let calendar = Calendar.current
            let date = calendar.date(byAdding: .hour, value: index, to: Date())
        
            switch complication.family {
                
                case .modularSmall:
                    let template = CLKComplicationTemplateModularSmallSimpleText()
                    template.textProvider = CLKSimpleTextProvider(text: timetable.timeStart)
                    let entry = CLKComplicationTimelineEntry(date: date!, complicationTemplate: template)
                    entries.append(entry)
                    
                case .utilitarianSmall:
                    let template = CLKComplicationTemplateUtilitarianSmallRingText()
                    template.textProvider = CLKSimpleTextProvider(text: timetable.timeStart)
                    let entry = CLKComplicationTimelineEntry(date: date!, complicationTemplate: template)
                    entries.append(entry)
                    
                case .modularLarge:
                    let template = CLKComplicationTemplateModularLargeStandardBody()
                    template.headerTextProvider = CLKSimpleTextProvider(text: timetable.timeStart)
                    template.body1TextProvider = CLKSimpleTextProvider(text: timetable.moduleName)
                    template.body2TextProvider = CLKSimpleTextProvider(text: timetable.roomNo)
                    let entry = CLKComplicationTimelineEntry(date: date!, complicationTemplate: template)
                    entries.append(entry)
                
                case .utilitarianLarge:
                    let template = CLKComplicationTemplateUtilitarianLargeFlat()
                    template.textProvider = CLKSimpleTextProvider(text: timetable.timeStart)
                    let entry = CLKComplicationTimelineEntry(date: date!, complicationTemplate: template)
                    entries.append(entry)

                default:
                    NSLog("%@", "Unknown complication type: \(complication.family)")
            }
        }
        
        return entries
    }
}
