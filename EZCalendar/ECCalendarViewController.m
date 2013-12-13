//
//  ECCalendarViewController.m
//  EZCalendar
//
//  Created by scott mehus on 12/13/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import "ECCalendarViewController.h"
#import "TSQCalendarView.h"
#import "TSQCalendarMonthHeaderCell.h"
#import "TSQCalendarCell.h"
#import "TSQCalendarRowCell.h"


@interface ECCalendarViewController ()

@end

@implementation ECCalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"CALENDAR VIEW LOADED");
    
    NSDate *startDate = [NSDate date];
    NSDate *endDAte = [NSDate dateWithTimeIntervalSinceNow:60];
    TSQCalendarView *calendarView = [[TSQCalendarView alloc] initWithFrame:CGRectMake(0, 75, self.view.bounds.size.width, self.view.bounds.size.height)];
    calendarView.firstDate = startDate;
    calendarView.lastDate = endDAte;
    //calendarView.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:calendarView];
    [self.view bringSubviewToFront:calendarView];
    
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
