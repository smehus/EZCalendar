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

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
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


    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdent";
    UITableViewCell *cell;
    if (indexPath.row == 0) {
       cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.textLabel.text = @"Scheduler";
    } else {
        
         cell = [tableView dequeueReusableCellWithIdentifier:@"calendar"];
        cell.textLabel.text = @"Calendar";
    }
    
    
    
    
    return cell;
}



@end
