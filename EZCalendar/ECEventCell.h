//
//  ECEventCell.h
//  EZCalendar
//
//  Created by scott mehus on 11/7/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECEventCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *dayLabel;
@property (nonatomic, weak) IBOutlet UILabel *monthLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *numberDateLabel;

@end
