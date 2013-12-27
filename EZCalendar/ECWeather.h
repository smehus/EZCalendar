//
//  ECWeather.h
//  EZCalendar
//
//  Created by scott mehus on 12/27/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECWeather : NSObject


@property (nonatomic, strong) NSString *temp;
@property (nonatomic, strong) NSString *weather;
@property (nonatomic, strong) NSString *iconURL;

@end
