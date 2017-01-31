//
//  CaughtException.h
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 30/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef CaughtException_h
#define CaughtException_h

volatile void exceptionHandler(NSException *exception);
extern NSUncaughtExceptionHandler *exceptionHandlerPtr;

#endif /* CaughtException_h */
