//
//  ECEventViewController.m
//  EZCalendar
//
//  Created by scott mehus on 11/8/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import "ECEventViewController.h"
#import "ECAddEventViewController.h"
#import <QuartzCore/QuartzCore.h>

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
    
     self.detailView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"6-black-background.jpg"]];
    self.detailView.layer.borderColor = [UIColor orangeColor].CGColor;
    self.detailView.layer.borderWidth = 3.0f;
    self.detailView.layer.cornerRadius = 10.0f;
    self.detailView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.detailView.layer.shadowOffset = CGSizeMake(0, 5.0f);
    self.detailView.layer.shadowOpacity = 0.8f;
    
    
}

- (void)setLabels {
    
    self.titleLabel.text = self.event.eventTitle;
    self.titleLabel.textColor = [UIColor lightGrayColor];
    self.dateLabel.text = self.event.eventFullDate;
    self.locationLabel.text = self.event.eventLocation;
    self.timeLabel.text = self.event.eventTime;
   // NSLog(@"ATTENDEES: %@", self.event.eventAttendees);
    
    NSMutableArray *names = [[NSMutableArray alloc] initWithCapacity:10];
    [self.event.eventAttendees enumerateObjectsUsingBlock:^(NSDictionary *attendee, NSUInteger idx, BOOL *stop) {
        
        NSString *name = [attendee valueForKey:@"name"];
       
        [names addObject:name];
        
    }];
    // NSLog(@"NAME: %@", names);
    self.attendeesLabel.text = [NSString stringWithFormat:@"%@", [names firstObject]];

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
    
    
    // ADD AN ALERT VIEW SO YOU STOP DELETING YOU IMPORTANT EVENTS!!!!
    
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
