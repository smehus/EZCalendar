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


@interface ECCalendarViewController () <UITableViewDataSource, UITableViewDelegate>

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdent = @"CellIdent";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdent];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdent];
    }
    
    
    
    cell.textLabel.text = @"This Works";
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"SELECTED A ROW");
}
















@end
