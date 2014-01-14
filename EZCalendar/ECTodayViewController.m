//
//  ECTodayViewController.m
//  EZCalendar
//
//  Created by scott mehus on 12/26/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import "ECTodayViewController.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "ECAppDelegate.h"
#import "ECWeather.h"
#import "UIImageView+AFNetworking.h"
#import "ECEventStore.h"
#import <EventKitUI/EventKitUI.h>




@interface ECTodayViewController () <CLLocationManagerDelegate, EKEventEditViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButtonItem;
@property (nonatomic, weak) IBOutlet UIView *firstView;
@property (nonatomic, weak) IBOutlet UIView *secondView;
@property (nonatomic, weak) IBOutlet UIView *thirdView;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *tempLabel;
@property (nonatomic, weak) IBOutlet UILabel *weatherLabel;
@property (nonatomic, weak) IBOutlet UILabel *dayLabel;
@property (nonatomic, weak) IBOutlet UIImageView *iconView;
@property (nonatomic, weak) IBOutlet UILabel *eventTitle;
@property (nonatomic, weak) IBOutlet UILabel *eventLocation;
@property (nonatomic, weak) IBOutlet UILabel *eventStartTime;

@property (nonatomic, weak) IBOutlet UITableView *tableView;



@property (nonatomic, strong) EKEventStore *eventStore;


- (IBAction)updateWeather:(id)sender;


@property (nonatomic, strong) ECWeather *weather;
@property (nonatomic, strong) NSArray *daysEvents;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) EKEvent *nextEvent;



@end

@implementation ECTodayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

      
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"VIEW LOADE");
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateWeather)
                                                 name:@"WeatherReceived" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUpdateWeather) name:@"becameActive" object:nil];
    
    
    [self accessEventStore];
    self.daysEvents = [self accessDaysEventsWithDate:[NSDate date]];
    [self updateNextEvent];
    [self updateWeather];
    [self didUpdateWeather];
    
    

    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"snow.jpg"]];
    
    UIColor *blackColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
    UIColor *blackColorFaded = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    
    self.firstView.backgroundColor = [UIColor blackColor];
    //self.firstView.layer.cornerRadius = 5.0f;
 
    self.secondView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editEvent)];
    [self.secondView addGestureRecognizer:tapGesture];
    //self.secondView.layer.cornerRadius = 5.0f;
    
    self.thirdView.backgroundColor = [UIColor blackColor];
    //self.thirdView.layer.cornerRadius = 5.0f;
    
    CAGradientLayer *gradientOne = [CAGradientLayer layer];
    gradientOne.frame = self.firstView.bounds;
    gradientOne.colors = [NSArray arrayWithObjects:(id)[blackColor CGColor], (id)[blackColorFaded CGColor], nil];
    self.firstView.layer.mask = gradientOne;
    
    
    CAGradientLayer *gradientTwo = [CAGradientLayer layer];
    gradientTwo.frame = self.secondView.bounds;
    gradientTwo.colors = [NSArray arrayWithObjects:(id)[blackColor CGColor], (id)[blackColorFaded CGColor], nil];
    self.secondView.layer.mask = gradientTwo;
    
    CAGradientLayer *gradientThree = [CAGradientLayer layer];
    gradientThree.frame = self.thirdView.bounds;
    gradientThree.colors = [NSArray arrayWithObjects:(id)[blackColor CGColor], (id)[blackColorFaded CGColor], nil];
    self.thirdView.layer.mask = gradientThree;
    
    
    //NSString *todaysDate = [self formatDate:[NSDate date] withIndex:0];
    //NSString *todaysDay = [self formatDate:[NSDate date] withIndex:1];
    //self.dateLabel.text = todaysDate;
    //self.dayLabel.text = todaysDay;


    self.tableView.backgroundColor = [UIColor clearColor];
    
}

- (void)updateNextEvent {
    
    
    if (self.daysEvents) {
        self.nextEvent = [self.daysEvents firstObject];
        NSLog(@"NEXT EVENT: %@", self.nextEvent);
        NSDate *nextDate = [self.nextEvent valueForKey:@"startDate"];
        NSString *time = [self formatTime:nextDate];
        if (time.length < 1) {
            time = @"N/A";
        }
        NSString *thisLocation = [self.nextEvent valueForKey:@"location"];
        if (thisLocation.length < 1) {
            thisLocation = @"No Location";
        }
        
        self.eventTitle.text = [self.nextEvent valueForKey:@"title"];
        self.eventStartTime.text = time;
        self.eventLocation.text = thisLocation;
        
    } else {
        
        self.eventTitle.text = @"Free As A Bird! Tweet!";
        self.eventStartTime.text = @"";
        self.eventLocation.text = @"";
    }
    

}

- (void)accessEventStore {
    
    

        self.eventStore = [[ECEventStore sharedInstance] getThisEventStore];
        NSLog(@"EVENT STORE: %@", self.eventStore);
    
    [[ECEventStore sharedInstance] accessEventStore:self.eventStore WithCompletion:^(NSMutableArray *events) {
        
        [self updateNextEvent];
    }];
    
}

- (NSArray *)accessDaysEventsWithDate:(NSDate *)date {
    
    
    EKCalendar *calendar = [self.eventStore defaultCalendarForNewEvents];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    NSDate *startDate = date;
    NSDate *oneDay = [startDate dateByAddingTimeInterval:secondsPerDay];
    NSArray *calendars = @[calendar];
    
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate endDate:oneDay calendars:calendars];
    
    NSArray *events = [self.eventStore eventsMatchingPredicate:predicate];
    
    return events;

}





- (NSString *)formatDate:(NSDate *)date withIndex:(NSInteger)index {
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString *dateString;
    
    if (index == 0 ) {
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        dateString = [formatter stringFromDate:date];
    } else if (index == 1) {
        [formatter setDateStyle:NSDateFormatterFullStyle];
       dateString = [formatter stringFromDate:date];
        NSArray *stringArray = [dateString componentsSeparatedByString:@" "];
        dateString = [stringArray objectAtIndex:0];
        dateString = [dateString stringByReplacingOccurrencesOfString:@"," withString:@""];
    } else {
       [formatter setDateStyle:NSDateFormatterFullStyle];
        dateString = [formatter stringFromDate:date];
        
    }
    
    return dateString;
}

- (NSString *)formatTime:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setDateFormat:@"HH:mm:ss"];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *string = [formatter stringFromDate:date];
    //NSLog(@"TIME: %@", string);
    return string;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateWeather {
    
    self.dateLabel.text = [self formatDate:[NSDate date] withIndex:0];
    self.dayLabel.text = [self formatDate:[NSDate date] withIndex:1];

        
        ECAppDelegate *appDel = (ECAppDelegate *)[[UIApplication sharedApplication] delegate];
        self.weather = appDel.weatherObject;
        NSLog(@"TODAY'S weather: %@", self.weather.temp);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tempLabel.text = self.weather.temp;
            self.weatherLabel.text = self.weather.weather;
            [self.iconView setImageWithURL:[NSURL URLWithString:self.weather.iconURL]];
            
        });
    
    
}


- (void)dealloc {
    
    NSLog(@"DEALLOC %@", self);
    
}


- (IBAction)updateWeather:(id)sender {
    
    NSLog(@"UPDATE WEATHER");
    
    ECAppDelegate *appDel = (ECAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel startLocationManager];

}

- (void)didUpdateWeather {
    
    NSLog(@"DID UPDATE WEATHER");
    
    ECAppDelegate *appDel = (ECAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel startLocationManager];
    
    
}


- (IBAction)addEvent:(id)sender {
    
    //[self performSegueWithIdentifier:@"AddEvent" sender:nil];
    
    EKEventEditViewController *editViewController = [[EKEventEditViewController alloc] init];
    editViewController.eventStore = self.eventStore;
    editViewController.editViewDelegate = self;
    
    [self presentViewController:editViewController animated:YES completion:nil];
    
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    self.daysEvents = [self accessDaysEventsWithDate:[NSDate date]];
    [self updateNextEvent];
    [self.tableView reloadData];
}

- (void)editEvent {
    
    
    // add a custom segue for editing events so you can add the correct event
    
    // I store the actual EKEvent in the date model. So edit that event?
    
    // NSLog(@"EDITEVENTWITHEVENT: %@", event);
    //[self performSegueWithIdentifier:@"EditEvent" sender:event];
    
    EKEvent *editEvent = [self.daysEvents firstObject];
    
    EKEventEditViewController *editViewController = [[EKEventEditViewController alloc] init];
    editViewController.event = editEvent;
    editViewController.eventStore = self.eventStore;
    editViewController.editViewDelegate = self;
    
    [self presentViewController:editViewController animated:YES completion:nil];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 66;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.daysEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == Nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    EKEvent *event = [self.daysEvents objectAtIndex:indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.text = event.title;
    NSString *date = [self formatTime:event.startDate];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.text = date;
    
    
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"CELL TAPPED");
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}





@end
