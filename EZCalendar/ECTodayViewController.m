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




@interface ECTodayViewController () <CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButtonItem;
@property (nonatomic, weak) IBOutlet UIView *firstView;
@property (nonatomic, weak) IBOutlet UIView *secondView;
@property (nonatomic, weak) IBOutlet UIView *thirdView;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *tempLabel;
@property (nonatomic, weak) IBOutlet UILabel *weatherLabel;







@property (nonatomic, strong) ECWeather *weather;

@property (nonatomic, strong) CLLocation *currentLocation;



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
    
   
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateWeather)
                                                 name:@"WeatherReceived" object:nil];
    [self updateWeather];
    
    

    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"snow.jpg"]];
    
    UIColor *blackColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
    UIColor *blackColorFaded = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    
    self.firstView.backgroundColor = [UIColor blackColor];
    self.firstView.layer.cornerRadius = 5.0f;
 
    self.secondView.backgroundColor = [UIColor blackColor];
    self.secondView.layer.cornerRadius = 5.0f;
    
    self.thirdView.backgroundColor = [UIColor blackColor];
    self.thirdView.layer.cornerRadius = 5.0f;
    
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
    
    
    NSString *todaysDate = [self formatDate:[NSDate date]];
    self.dateLabel.text = todaysDate;

}

- (NSString *)formatDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    //[formatter setDateStyle:NSDateFormatterShortStyle];
    //[formatter setTimeStyle:NSDateFormatterShortStyle];
    
    return [formatter stringFromDate:date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateWeather {
    

    
    if (self.weather == nil) {
        
        ECAppDelegate *appDel = (ECAppDelegate *)[[UIApplication sharedApplication] delegate];
        self.weather = appDel.weatherObject;
        NSLog(@"TODAY'S weather: %@", self.weather.temp);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tempLabel.text = self.weather.temp;
            self.weatherLabel.text = self.weather.weather;
            
        });
    
    }
    
    

}




- (void)dealloc {
    
    NSLog(@"DEALLOC %@", self);
    
}









@end
