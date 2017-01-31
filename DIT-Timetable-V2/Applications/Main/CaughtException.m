//
//  CaughtException.m
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 30/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

#import <Foundation/Foundation.h>

void exceptionHandler(NSException *exception) {
    printf("whatever you want to print");
}
NSUncaughtExceptionHandler *exceptionHandlerPointer = &exceptionHandler;
