//
//  ECAddEventViewController.h
//  EZCalendar
//
//  Created by scott mehus on 11/10/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@class ECEvent;

@class ECAddEventViewController;

@protocol ECAddEventViewControllerDelegate <NSObject>

- (void)ECAddEventViewRefresh;

@end

@interface ECAddEventViewController : UITableViewController

@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic, weak) id <ECAddEventViewControllerDelegate> delegate;
@property (nonatomic, strong) ECEvent *event;
@property (nonatomic, assign) BOOL editingEvent;


- (id)initWithEvent:(ECEvent *)event;

@end
