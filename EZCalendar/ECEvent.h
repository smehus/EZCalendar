//
//  ECEvent.h
//  EZCalendar
//
//  Created by scott mehus on 11/7/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface ECEvent : NSObject

@property (nonatomic, strong) NSString *eventTitle;
@property (nonatomic, strong) NSString *eventLocation;
@property (nonatomic, strong) NSDictionary *eventCalendar;
@property (nonatomic, strong) NSArray *eventAlarms;
@property (nonatomic, strong) NSString *eventURL;
@property (nonatomic, strong) NSString *eventDay;
@property (nonatomic, strong) NSString *eventMonth;
@property (nonatomic, strong) NSString *numberDate;
@property (nonatomic, strong) NSString *eventTime;
@property (nonatomic, strong) NSString *eventEndDate;
@property (nonatomic, assign) BOOL eventAllDay;
@property (nonatomic, strong) NSArray *eventAttendees;
@property (nonatomic, strong) NSString *eventFullDate;
@property (nonatomic, strong) EKEvent *thisEvent;


@end
