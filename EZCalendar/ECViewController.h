//
//  ECViewController.h
//  EZCalendar
//
//  Created by scott mehus on 11/7/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECAddEventViewController.h"

@interface ECViewController : UIViewController <ECAddEventViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

- (void)accessEventStore;

@end
