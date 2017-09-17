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
                template.headerTextProvider = CLKSimpleTextProvider(text: "??:??-??:??")
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
        
        var smallTime = "??:??"
        var largeTime = "??:??-??:??"
        var largeText1 = "No classes"
        var largeText2 = "-------"
        
        if let timetable = database?.getClassNow() {
            smallTime = timetable.timeStart
            largeTime = timetable.timeStart + "-" + timetable.timeEnd
            largeText1 = timetable.moduleName
            largeText2 = timetable.roomNo
        }
        
        switch complication.family {
            
            case .modularSmall:
                let template = CLKComplicationTemplateModularSmallSimpleText()
                template.textProvider = CLKSimpleTextProvider(text: smallTime)
                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                return entry
                
            case .utilitarianSmall:
                let template = CLKComplicationTemplateUtilitarianSmallRingText()
                template.textProvider = CLKSimpleTextProvider(text: smallTime)
                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                return entry
                
            case .modularLarge:
                let template = CLKComplicationTemplateModularLargeStandardBody()
                template.headerTextProvider = CLKSimpleTextProvider(text: largeTime)
                template.body1TextProvider = CLKSimpleTextProvider(text: largeText1)
                template.body2TextProvider = CLKSimpleTextProvider(text: largeText2)
                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                return entry
            case .utilitarianLarge:
                let template = CLKComplicationTemplateUtilitarianLargeFlat()
                template.textProvider = CLKSimpleTextProvider(text: smallTime)
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
        
        guard let timetables = database?.getDayTimetable(dayNo: indexVal) else {
            return entries
        }
        
        for (index, timetable ) in timetables.enumerated() {
            
            let smallTime = timetable.timeStart
            let largeTime = timetable.timeStart + "-" + timetable.timeEnd
            let largeText1 = timetable.moduleName
            let largeText2 = timetable.roomNo
            
            //let calendar = Calendar.current
            //let date = calendar.date(byAdding: .hour, value: index, to: Date())
        
            switch complication.family {
                
                case .modularSmall:
                    let template = CLKComplicationTemplateModularSmallSimpleText()
                    template.textProvider = CLKSimpleTextProvider(text: smallTime)
                    let entry = CLKComplicationTimelineEntry(date: timetable.timeStartDate, complicationTemplate: template)
                    entries.append(entry)
                    
                case .utilitarianSmall:
                    let template = CLKComplicationTemplateUtilitarianSmallRingText()
                    template.textProvider = CLKSimpleTextProvider(text: smallTime)
                    let entry = CLKComplicationTimelineEntry(date: timetable.timeStartDate, complicationTemplate: template)
                    entries.append(entry)
                    
                case .modularLarge:
                    let template = CLKComplicationTemplateModularLargeStandardBody()
                    template.headerTextProvider = CLKSimpleTextProvider(text: largeTime)
                    template.body1TextProvider = CLKSimpleTextProvider(text: largeText1)
                    template.body2TextProvider = CLKSimpleTextProvider(text: largeText2)
                    let entry = CLKComplicationTimelineEntry(date: timetable.timeStartDate, complicationTemplate: template)
                    entries.append(entry)
                
                case .utilitarianLarge:
                    let template = CLKComplicationTemplateUtilitarianLargeFlat()
                    template.textProvider = CLKSimpleTextProvider(text: smallTime)
                    let entry = CLKComplicationTimelineEntry(date: timetable.timeStartDate, complicationTemplate: template)
                    entries.append(entry)

                default:
                    NSLog("%@", "Unknown complication type: \(complication.family)")
            }
        }
        
        return entries
    }
}
