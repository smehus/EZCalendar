//
//  ECHeaderView.h
//  EZCalendar
//
//  Created by scott mehus on 11/9/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECHeaderView : UICollectionReusableView

- (void)setSearchText:(NSString *)text;

@property (nonatomic, strong) NSString *title;
@property (weak) IBOutlet UILabel *sectionLabel;

@end
