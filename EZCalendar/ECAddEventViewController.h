//
//  ECAddEventViewController.h
//  EZCalendar
//
//  Created by scott mehus on 11/10/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@class ECAddEventViewController;

@protocol ECAddEventViewControllerDelegate <NSObject>

- (void)ECAddEventViewRefresh;

@end

@interface ECAddEventViewController : UITableViewController

@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic, weak) id <ECAddEventViewControllerDelegate> delegate;

@end
