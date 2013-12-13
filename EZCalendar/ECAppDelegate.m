//
//  ECAppDelegate.m
//  EZCalendar
//
//  Created by scott mehus on 11/7/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import "ECAppDelegate.h"
#import "ECViewController.h"

@implementation ECAppDelegate {
    
    BOOL _notFirstRun;
    
    
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _notFirstRun = NO;
    [[UINavigationBar appearance] setBackgroundColor:[UIColor blueColor]];
    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"2-orange-menu-bar"] forBarMetrics:UIBarMetricsDefault];
   
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

@end
