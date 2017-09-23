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
    
    init() {}
    
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
        
        let defaults = UserDefaults()
        guard let currentTimetableOjbects = defaults.array(forKey: "todaytimetable") else {
            return nil
        }
        
        if currentTimetableOjbects.count > 0 {
        
            for currentTimetableObject in currentTimetableOjbects {
                
                guard let timetableDic = currentTimetableObject as? [String: AnyObject] else {
                    continue
                }
            
                let timetable = Timetable(dict: timetableDic)
                
                let nowTime = Date()
                let hour = nowTime.hour()
                let classTimeParts = timetable.timeStart.components(separatedBy: ":")
                let classTimeEndParts = timetable.timeEnd.components(separatedBy: ":")
                
                guard let classTimeHr = Int(classTimeParts[0]) else {
                    continue
                }
                
                guard let classTimeEndHr = Int(classTimeEndParts[0]) else {
                    continue
                }
                
                if(classTimeHr >= hour || hour < classTimeEndHr ) {
                
                    smallTime = timetable.timeStart.convertToCurrentTimeFormat(false)
                    largeTime = timetable.timeStart.convertToCurrentTimeFormat() + "-" + timetable.timeEnd.convertToCurrentTimeFormat()
                    largeText1 = timetable.moduleName
                    largeText2 = timetable.roomNo
                }
            }
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
        
        let defaults = UserDefaults()
        guard let currentTimetableObjects = defaults.array(forKey: "todaytimetable") else {
            return nil
        }
        
        if currentTimetableObjects.count > 0 {
            
            for currentTimetableObject in currentTimetableObjects {
                
                guard let timetableDic = currentTimetableObject as? [String: AnyObject] else {
                    continue
                }
                
                let timetable = Timetable(dict: timetableDic)
            
                let smallTime = timetable.timeStart.convertToCurrentTimeFormat(false)
                let largeTime = timetable.timeStart.convertToCurrentTimeFormat() + "-" + timetable.timeEnd.convertToCurrentTimeFormat()
                let largeText1 = timetable.moduleName
                let largeText2 = timetable.roomNo
            
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
        }
        
        return entries
    }
}
