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




@interface ECTodayViewController () <CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *revealButtonItem;
@property (nonatomic, weak) IBOutlet UIView *firstView;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

@property (nonatomic, strong) CLLocation *currentLocation;



@end

@implementation ECTodayViewController {
    
    CLLocationManager *locationManager;
    CLLocation *location;
    CLGeocoder *geocoder;
}

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
    NSLog(@"LOCATION MANAGER %@", locationManager);
    
    // DON'T WANT TO GRAB WEATHER & DATE EVERYTIME YOU MOVE BACK TO THIS PAGE
    // SHOULD CACHE THE WEATHER AND DATE
    // USING APP DELEGATE?
    
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    [self startLocationManager];
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"snow.jpg"]];
    
    UIColor *blackColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
    UIColor *blackColorFaded = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    
    self.firstView.backgroundColor = [UIColor blackColor];
    self.firstView.layer.cornerRadius = 10.0f;
    
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.firstView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[blackColor CGColor], (id)[blackColorFaded CGColor], nil];
    self.firstView.layer.mask = gradient;
    
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


- (void)startLocationManager {
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        [locationManager startUpdatingLocation];
    } else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops@"
                                                            message:@"You will need to allow location services" delegate:Nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)stopLocationManager {
    
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *thisLocation = [locations lastObject];
    if (thisLocation.horizontalAccuracy < 200) {
        [self stopLocationManager];
    }
    
    [geocoder reverseGeocodeLocation:thisLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        NSString *state = [[placemarks lastObject] administrativeArea];
        NSString *city = [[placemarks lastObject] locality];
        
        [self getWeather];
        
        NSLog(@"state: %@ city : %@", state, city);
        
        
    }];
   
}


- (void)getWeather {
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *urlString = @"http://api.wunderground.com/api/9b9f71223c68aef5/conditions/q/MN/Maple_Grove.json";
    
    [[session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        //NSLog(@"DATA %@ RESPONSE %@ ERROR %@", data, response, error);
        
        NSError *err;
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        
        NSLog(@"JSON: %@", responseJson);
        
    }] resume];
    
    
}












@end
