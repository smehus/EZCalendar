//
//  ECAppDelegate.m
//  EZCalendar
//
//  Created by scott mehus on 11/7/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import "ECAppDelegate.h"
#import "ECViewController.h"
#import "SWRevealViewController.h"
#import "ECRearViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ECTodayViewController.h"
#import "ECWeather.h"





@implementation ECAppDelegate {
    
    BOOL _notFirstRun;
   
        CLLocationManager *locationManager;
        CLLocation *location;
        CLGeocoder *geocoder;
 
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	//self.window = window;
    
    _notFirstRun = NO;
    [[UINavigationBar appearance] setBackgroundColor:[UIColor blueColor]];
    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"2-orange-menu-bar"] forBarMetrics:UIBarMetricsDefault];
    /*
    ECRearViewController *rearViewController = [[ECRearViewController alloc] init];
     ECOpeningViewController *frontViewController = [[ECOpeningViewController alloc] init];
    
    SWRevealViewController *mainRevealController = [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:frontViewController];
    
    mainRevealController.rearViewRevealWidth = 60;
    mainRevealController.rearViewRevealOverdraw = 120;
    mainRevealController.bounceBackOnOverdraw = NO;
    mainRevealController.stableDragOnOverdraw = YES;
    
    mainRevealController.delegate = self;
    
    self.window.rootViewController = mainRevealController;
    //[self.window makeKeyAndVisible];
    
*/
    
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    [self startLocationManager];
    

    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    _notFirstRun = YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
 
   
   
   

    

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"DID ENTER FOREGROUND");
    
    if (_notFirstRun) {
        NSLog(@"***SETTING UP NOTIFICATIONS***");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BecomeActive" object:nil];
    }
    
   
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
        
        NSString *stateRep = [state stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        NSString *cityRep = [city stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        
        [self getWeatherWithState:stateRep andCity:cityRep];
        
        //NSLog(@"state: %@ city : %@", state, city);
        
        
    }];
    
}


- (void)getWeatherWithState:(NSString *)state andCity:(NSString *)city {
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.wunderground.com/api/9b9f71223c68aef5/conditions/q/%@/%@.json", state, city];
    
    
    
    

    
    [[session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        //NSLog(@"DATA %@ RESPONSE %@ ERROR %@", data, response, error);
        
        NSError *err;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        
        [self parseOutJSON:dict];
        

    
        
        //NSLog(@"JSON: %@", responseJson);
        
    }] resume];
 
}

- (void)parseOutJSON:(NSDictionary *)dict {
    
    NSDictionary *currentObs = [dict objectForKey:@"current_observation"];
    NSString *feelsLike = [currentObs objectForKey:@"temperature_string"];
    NSString *weatherString = [currentObs objectForKey:@"weather"];
    NSString *iconURL = [currentObs objectForKey:@"icon_url"];
    
    self.weatherObject = [[ECWeather alloc] init];
    self.weatherObject.temp = feelsLike;
    self.weatherObject.weather = weatherString;
    self.weatherObject.iconURL = iconURL;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WeatherReceived" object:nil];

    //NSLog(@"dict: %@", currentObs);
    
    
    
    
}



















 

@end
