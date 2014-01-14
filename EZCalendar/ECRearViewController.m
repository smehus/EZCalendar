//
//  ECRearViewController.m
//  EZCalendar
//
//  Created by scott mehus on 12/13/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import "ECRearViewController.h"
#import "ECViewController.h"
#import "SWRevealViewController.h"
#import "TSQCalendarView.h"
#import "ECCustomCell.h"


@interface ECRearViewController ()

@end

@implementation ECRearViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    
    self.tableView.backgroundColor = [UIColor colorWithRed: 123/255.0 green: 104/255.0 blue: 238/255.0 alpha:1];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void) prepareForSegue: (UIStoryboardSegue *)segue sender: (id) sender
{
  
    
    // configure the segue.
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        SWRevealViewControllerSegue* rvcs = (SWRevealViewControllerSegue*) segue;
        
        SWRevealViewController* rvc = self.revealViewController;
        NSAssert( rvc != nil, @"oops! must have a revealViewController" );
        
        NSAssert( [rvc.frontViewController isKindOfClass: [UINavigationController class]], @"oops!  for this segue we want a permanent navigation controller in the front!" );
        
        rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc)
        {
            UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:dvc];
            [rvc setFrontViewController:nc animated:YES];
        };
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{


    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{


    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdent";
    ECCustomCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (indexPath.row == 0) {
        cell.customLabel.text = @"Today";
    } else if (indexPath.row == 1) {
        cell.customLabel.text = @"Scheduler";
    } else if (indexPath.row == 2) {
        cell.customLabel.text = @"Month";
    }

    
    cell.customLabel.textColor = [UIColor colorWithRed: 102/255.0 green: 205/255.0 blue: 170/255.0 alpha:1];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"TodaySegue" sender:nil];
    } else if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"OverviewSegue" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"MonthSegue" sender:nil];
    }
}



@end
