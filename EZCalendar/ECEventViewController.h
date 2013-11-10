//
//  ECEventViewController.h
//  EZCalendar
//
//  Created by scott mehus on 11/8/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECEvent.h"
#import <EventKit/EventKit.h>

@class ECEventViewController;
@protocol ECEventViewControllerDelegate <NSObject>

- (void)ECAddEventViewRefresh;

@end


@interface ECEventViewController : UIViewController

@property (nonatomic, strong) ECEvent *event;
@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic, weak) id <ECEventViewControllerDelegate> delegate;

@end
