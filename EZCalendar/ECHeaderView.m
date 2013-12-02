//
//  ECHeaderView.m
//  EZCalendar
//
//  Created by scott mehus on 11/9/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import "ECHeaderView.h"

@interface ECHeaderView ()

@property (weak) IBOutlet UIImageView *backgroundImageView;
@property (weak) IBOutlet UILabel *sectionLabel;
@end

@implementation ECHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
   
        
    }
    return self;
}

- (void)setSearchText:(NSString *)text {
    
    UIImage *shareButtonImage = [[UIImage imageNamed:@"header_bg.png"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(68, 68, 68, 68)];
    
    self.backgroundImageView.image = shareButtonImage;
    self.sectionLabel.textColor = [UIColor blackColor];
    self.sectionLabel.text = text;
    
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
