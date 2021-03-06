//
//  ECAppDelegate.h
//  EZCalendar
//
//  Created by scott mehus on 11/7/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ECWeather.h"

@interface ECAppDelegate : UIResponder <UIApplicationDelegate, SWRevealViewControllerDelegate, CLLocationManagerDelegate, NSURLSessionDataDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) ECWeather *weatherObject;

@property (nonatomic, strong) NSString *weatherString;

- (void)startLocationManager;

@end
