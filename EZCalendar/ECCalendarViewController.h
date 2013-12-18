//
//  ECCalendarViewController.h
//  EZCalendar
//
//  Created by scott mehus on 12/13/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface ECCalendarViewController : UIViewController

@property (nonatomic, strong) EKEventStore *eventStore;

@end
