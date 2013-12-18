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
#import "SWRevealViewController.h"
#import "ECEventStore.h"


@interface ECCalendarViewController () <UITableViewDataSource, UITableViewDelegate, TSQCalendarViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButtonItem;
@property (nonatomic, strong) NSArray *daysEvents;

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
    TSQCalendarView *calendarView = [[TSQCalendarView alloc] initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height/2)];
    calendarView.delegate = self;
    calendarView.firstDate = startDate;
    calendarView.lastDate = endDAte;
    //calendarView.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:calendarView];
    [self.view bringSubviewToFront:calendarView];
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    
    if (self.eventStore == nil) {
        
        self.eventStore = [[ECEventStore sharedInstance] getThisEventStore];
    }
    
    
    
	// Do any additional setup after loading the view.
}

- (NSArray *)accessDaysEventsWithDate:(NSDate *)date {
    
    
    EKCalendar *calendar = [self.eventStore defaultCalendarForNewEvents];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    NSDate *startDate = date;
    NSDate *eightWeeks = [startDate dateByAddingTimeInterval:secondsPerDay];
    NSArray *calendars = @[calendar];
    
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate endDate:eightWeeks calendars:calendars];
    
    NSArray *events = [self.eventStore eventsMatchingPredicate:predicate];
    for (EKEvent *event in events) {
        NSLog(@"TITLE: %@", event.title);
    }
    
    
    return events;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.daysEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdent = @"CellIdent";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdent];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdent];
    }
    
    EKEvent *event = [self.daysEvents objectAtIndex:indexPath.row];
    
    
    
    cell.textLabel.text = event.title;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"SELECTED A ROW");
}


#pragma mark - TSQCalendarDelegate


- (void)calendarView:(TSQCalendarView *)calendarView didSelectDate:(NSDate *)date {
    
    // SET THE TABLE VIEW TO THE DATE SELECTED
    NSLog(@"DIDSELECTDATE: %@", date);

    self.daysEvents = [self accessDaysEventsWithDate:date];
    [self.tableView reloadData];

}














@end
