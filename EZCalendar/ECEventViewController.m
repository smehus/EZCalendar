//
//  ECEventViewController.m
//  EZCalendar
//
//  Created by scott mehus on 11/8/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import "ECEventViewController.h"
#import "ECAddEventViewController.h"

@interface ECEventViewController ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UILabel *lengthLabel;
@property (nonatomic, weak) IBOutlet UILabel *attendeesLabel;


@property (nonatomic, strong) IBOutlet UIView *detailView;

- (IBAction)close:(id)sender;
- (IBAction)removeEvent:(id)sender;
- (IBAction)editEvent:(id)sender;

@end

@implementation ECEventViewController {
    
    UIGravityBehavior *_gravity;
    UIDynamicAnimator *_animator;
    CGPoint _previousTouchPoint;
    BOOL _draggingView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    
    _animator = [[UIDynamicAnimator alloc]
                 initWithReferenceView:self.view];
    
    _gravity = [[UIGravityBehavior alloc] init];
    [_animator addBehavior:_gravity];
    _gravity.magnitude = 4.0f;
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.detailView]];
    [_animator addBehavior:collision];
    
    //set boundary to stop
    
    CGPoint boundaryStart = CGPointMake(0.0, 450.0f);
    CGPoint boundaryEnd = CGPointMake(self.view.bounds.size.width, 450.0f);
    
    [collision addBoundaryWithIdentifier:@1 fromPoint:boundaryStart toPoint:boundaryEnd];
    
    [_gravity addItem:self.detailView];
    
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.detailView]];
    itemBehavior.elasticity = 0.4;
    [_animator addBehavior:itemBehavior];
    
    
    [self setLabels];
    
}

- (void)setLabels {
    
    self.titleLabel.text = self.event.eventTitle;
    self.dateLabel.text = self.event.eventFullDate;
    self.locationLabel.text = self.event.eventLocation;
    self.timeLabel.text = self.event.eventTime;

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    
    
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)dealloc {
    
    NSLog(@"DEALLOC: %@", self);
}


- (IBAction)removeEvent:(id)sender {
    
    NSError *err;
    [self.eventStore removeEvent:self.event.thisEvent span:EKSpanThisEvent commit:YES error:&err];
    
    
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [self.delegate ECAddEventViewRefresh];
    
    
}


- (IBAction)editEvent:(id)sender {
    
    NSLog(@"@EDIT EVENT");
    
    [self.delegate ECEditEventWithEvent:self.event];
}













@end
