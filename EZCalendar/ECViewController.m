//
//  ECViewController.m
//  EZCalendar
//
//  Created by scott mehus on 11/7/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import <EventKit/EventKit.h>
#import "ECViewController.h"
#import "ECEvent.h"
#import <QuartzCore/QuartzCore.h>
#import "ECEventCell.h"
#import "ECEventViewController.h"
#import "ECHeaderView.h"
#import "ECAddEventViewController.h"
#import "ECCollectionViewFlowLayout.h"
#import "StackedGridLayout.h"
#import "ECEventStore.h"

@interface ECViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, StackedGridLayoutDelegate>



@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic, strong) NSMutableArray *eventsArray;

@property (nonatomic, strong) NSMutableArray *firstEventsArray;
@property (nonatomic, strong) NSMutableArray *secondEventsArray;
@property (nonatomic, strong) NSMutableArray *thirdEventsArray;
@property (nonatomic, strong) NSMutableArray *fourthEventsArray;

@property (nonatomic, strong)ECCollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) StackedGridLayout *stackedLayout;

- (IBAction)addEvent:(id)sender;

@end

@implementation ECViewController {
    
    NSString *firstHeader;
    NSString *secondHeader;
    NSString *thirdHeader;
    NSString *fourthHeader;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"*** VIEW DID LOAD CALLED");
    
    self.flowLayout = [[ECCollectionViewFlowLayout alloc] init];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessEventStore) name:@"BecomeActive" object:nil];
    
    //self.collectionView.collectionViewLayout = self.flowLayout;

    
    self.stackedLayout = [[StackedGridLayout alloc] init];
    self.stackedLayout.headerHeight = 90.0f;
    self.collectionView.collectionViewLayout = self.stackedLayout;
    
    self.eventsArray = [[NSMutableArray alloc] initWithCapacity:20];
    self.firstEventsArray = [[NSMutableArray alloc] initWithCapacity:20];
    self.secondEventsArray = [[NSMutableArray alloc] initWithCapacity:20];
    self.thirdEventsArray = [[NSMutableArray alloc] initWithCapacity:20];
    self.fourthEventsArray = [[NSMutableArray alloc] initWithCapacity:20];

    /*

    [self.collectionView registerClass:[ECHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ECHeaderView"];
    */
    
    
    //[self.collectionView registerClass:[ECEventCell class] forCellWithReuseIdentifier:@"EventCell"];
    [self accessEventStore];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)accessEventStore {
    /*
    self.eventStore = nil;
    self.eventStore = [[EKEventStore alloc] init];
     */
    
    self.eventStore = [[ECEventStore sharedInstance] getThisEventStore];
    
 [[ECEventStore sharedInstance] accessEventStore:self.eventStore WithCompletion:^(NSMutableArray *events) {
     
     [self parseOutEvents:events];
 }];
 
    //[self.collectionView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)formatDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    //[formatter setDateStyle:NSDateFormatterShortStyle];
    //[formatter setTimeStyle:NSDateFormatterShortStyle];
    
    return [formatter stringFromDate:date];
}

- (void)parseOutEvents:(NSArray *)events {
    
    
    [self.eventsArray removeAllObjects];
    for (EKEvent *event in events) {

        
        NSDate *aDate = [event valueForKey:@"startDate"];
        NSString *startDate = [self formatDate:aDate];
        
        NSString *noYear = [startDate stringByReplacingOccurrencesOfString:@"2014" withString:@""];
        NSString *finalStartDate = [noYear stringByReplacingOccurrencesOfString:@"2013" withString:@""];
        
        
        NSArray *stringArray = [finalStartDate componentsSeparatedByString:@","];
        NSString *dayString = [self parseDay:[stringArray objectAtIndex:0]];
        NSString *monthString = [stringArray objectAtIndex:1];
        
        NSArray *monthArray = [monthString componentsSeparatedByString:@" "];
        NSString *month = [self parseMonth:[monthArray objectAtIndex:1]];
        NSString *numberDate = [monthArray objectAtIndex:2];
   
        
        
        ECEvent *newEvent = [[ECEvent alloc] init];
        newEvent.eventDay = dayString;
        newEvent.eventMonth = month;
        newEvent.numberDate = numberDate;
        newEvent.eventTitle = [event valueForKey:@"title"];
        newEvent.eventFullDate = startDate;
        newEvent.thisEvent = event;
        
        //NSLog(@"TITLE: %@", newEvent.eventTitle);
        

        //NSLog(@"DAY %@, MONTH: %@ NUMBER: %@", dayString, month, numberDate);
        
        [self.eventsArray addObject:newEvent];
    }
    
    
    [self parseOutMonths];
    
    dispatch_async(dispatch_get_main_queue(), ^{
         [self.collectionView reloadData];
        [self.view setNeedsDisplay];
    });
   
    //NSLog(@"EVENTS ARRAY: %@", self.eventsArray);
}


//TRYING TO SEPARATE MONTHS INTO DIFFERENT SECTIONS

- (void)parseOutMonths {
    
    [self.firstEventsArray removeAllObjects];
    [self.secondEventsArray removeAllObjects];
    [self.thirdEventsArray removeAllObjects];
    [self.fourthEventsArray removeAllObjects];
    
    int eventIndexPath = 1;
    
    for (int i = 0; i < [self.eventsArray count]; i++) {
        
        ECEvent *currentMonth = [self.eventsArray objectAtIndex:i];
        ECEvent *previousMonth;
        if (i == 0) {
            [self.firstEventsArray addObject:currentMonth];
            firstHeader = currentMonth.eventMonth;
        } else if (i > 0) {
        previousMonth = [self.eventsArray objectAtIndex:i-1];
            
            if ([currentMonth.eventMonth isEqualToString:previousMonth.eventMonth]) {
               // NSLog(@"ISEQUAL TO LAST MONTH: %@", currentMonth.eventMonth);
                
                if (eventIndexPath == 1) {
                    [self.firstEventsArray addObject:currentMonth];
                    firstHeader = currentMonth.eventMonth;
                } else if (eventIndexPath == 2) {
                    [self.secondEventsArray addObject:currentMonth];
                    secondHeader = currentMonth.eventMonth;
                } else if (eventIndexPath == 3) {
                    [self.thirdEventsArray addObject:currentMonth];
                    thirdHeader = currentMonth.eventMonth;
                } else {
                    [self.fourthEventsArray addObject:currentMonth];
                    fourthHeader = currentMonth.eventMonth;
                }
                
                
                
                
                
            } else {
                //NSLog(@"ISDIFF FROM LAST MONTH: %@", currentMonth.eventMonth);
               
                
                if (eventIndexPath == 1) {
                     [self.secondEventsArray addObject:currentMonth];
                } else if (eventIndexPath == 2) {
                    [self.thirdEventsArray addObject:currentMonth];
                } else {
                    [self.fourthEventsArray addObject:currentMonth];
                }
                 eventIndexPath++;
                
               
            }
        }
    }
    
   NSLog(@"FIRSTEVENT ARRAY: %@", self.firstEventsArray);
    NSLog(@"SECONDEVENT ARRAY: %@", self.secondEventsArray);
    NSLog(@"THIRDEVENT ARRAY: %@", self.thirdEventsArray);
    NSLog(@"FOURTHEVENT ARRAY: %@", self.fourthEventsArray);
    
}

- (NSString *)parseMonth:(NSString *)month {
    
    if ([month isEqualToString:@"January"]) {
        return @"JAN";
    } else if ([month isEqualToString:@"February"] ) {
        return @"FEB";
    } else if ([month isEqualToString:@"March"]) {
        return @"MAR";
    } else if ([month isEqualToString:@"April"]) {
        return @"APR";
    } else if ([month isEqualToString:@"May"]) {
        return @"MAY";
    } else if ([month isEqualToString:@"June"]) {
        return @"JUN";
    } else if ([month isEqualToString:@"July"]) {
        return @"JUL";
    } else if ([month isEqualToString:@"August"]) {
        return @"AUG";
    } else if ([month isEqualToString:@"September"]) {
        return @"SEP";
    } else if ([month isEqualToString:@"October"]) {
        return @"OCT";
    } else if ([month isEqualToString:@"November"]) {
        return @"NOV";
    } else {
        return @"DEC";
    }
}

- (NSString *)parseDay:(NSString *)day {
    
    if ([day isEqualToString:@"Monday"]) {
        return @"MON";
    } else if ([day isEqualToString:@"Tuesday"]) {
        return @"TUE";
    } else if ([day isEqualToString:@"Wednesday"] ) {
        return @"WED";
    } else if ([day isEqualToString:@"Thursday"]) {
        return @"THUR";
    } else if ([day isEqualToString:@"Friday"]) {
        return @"FRI";
    } else if ([day isEqualToString:@"Saturday"] ) {
        return @"SAT";
    } else {
        
        return @"SUN";
    }
}





- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    ECHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ECHeaderView" forIndexPath:indexPath];
    NSLog(@"FIRST HEADER: %@", firstHeader);
    
    switch (indexPath.section) {
        case 0:
            [headerView setSearchText:firstHeader];
            break;
        case 1:
            [headerView setSearchText:secondHeader];
            break;
        case 2:
            [headerView setSearchText:thirdHeader];
            break;
        case 3:
            [headerView setSearchText:fourthHeader];
            break;
            
        default:
            break;
    }
    
     
    //headerView.backgroundColor = [UIColor redColor];
    
     
    return headerView;
    
    
    
}


-(UIColor*)colorForIndex:(NSInteger) index {
    NSUInteger itemCount = self.firstEventsArray.count - 1;
    float val = ((float)index / (float)itemCount) * 0.6;
    return [UIColor colorWithRed: 1.0 green:val blue: 0.0 alpha:1.0];
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        return [self.firstEventsArray count];
    } else if (section == 1) {
        return [self.secondEventsArray count];
    } else if (section == 2) {
        return [self.thirdEventsArray count];
    } else {
        return [self.fourthEventsArray count];
    }
}

- (NSInteger)collectionView:(UICollectionView*)cv layout:(UICollectionViewLayout*)cvl
   numberOfColumnsInSection:(NSInteger)section {
    return 3;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView*)cv layout:(UICollectionViewLayout*)cvl
   itemInsetsForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
}

- (CGSize)collectionView:(UICollectionView*)cv layout:(UICollectionViewLayout*)cvl
    sizeForItemWithWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    //NSString *searchTerm = self.searches[indexPath.section]; FlickrPhoto *photo =
    //self.searchResults[searchTerm][indexPath.item];
    //CGSize picSize = photo.thumbnail.size.width > 0.0f ? photo.thumbnail.size : CGSizeMake(100.0f, 100.0f);
    //picSize.height += 35.0f; picSize.width += 35.0f;
    CGSize retval = CGSizeMake(95.0,154.0);
        
        return retval;
    
                               
        }

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    ECEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EventCell" forIndexPath:indexPath];

    cell.layer.masksToBounds = NO;
    //cell.backgroundColor = [self colorForIndex:indexPath.row];
    cell.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.titleLabel.numberOfLines = 0;
    cell.backgroundColor = [UIColor whiteColor];
    //cell.layer.cornerRadius = 10.0f;
    //cell.layer.borderColor = [UIColor blueColor].CGColor;
    //cell.layer.borderWidth = 1.0f;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    cell.layer.shadowOpacity = 0.8f;
    cell.selectedBackgroundView.backgroundColor = [UIColor blueColor];
    cell.dayLabel.textColor = [UIColor blackColor];
    cell.dayLabel.textAlignment = NSTextAlignmentCenter;
    cell.titleLabel.textColor = [UIColor lightGrayColor];
    UIFont *yourFont = [UIFont fontWithName:@"Helvetica-BoldOblique" size:[UIFont systemFontSize]];
    cell.titleLabel.font = yourFont;
    
    
    
    //ECEvent *event = [self.eventsArray objectAtIndex:indexPath.row];
    ECEvent *event;
    if (indexPath.section == 0) {
        event = [self.firstEventsArray objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        event = [self.secondEventsArray objectAtIndex:indexPath.row];
    } else if (indexPath.section == 2) {
        event = [self.thirdEventsArray objectAtIndex:indexPath.row];
    } else {
        event = [self.fourthEventsArray objectAtIndex:indexPath.row];
    }

    

    
    
    cell.dayLabel.text = event.eventDay;
    cell.monthLabel.text = event.eventMonth;
    cell.titleLabel.text = event.eventTitle;
    cell.numberDateLabel.text = event.numberDate;
    
    
    
    
    
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"***SELECTED ITEM AT INDEX: %@", indexPath);
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    ECEventViewController *eventViewController = [[ECEventViewController alloc]
                                                  initWithNibName:@"ECEventViewController" bundle:nil];
    eventViewController.delegate = self;
    
    ECEvent *event;
    
    if (indexPath.section == 0) {
        
        event = [self.firstEventsArray objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        
        event = [self.secondEventsArray objectAtIndex:indexPath.row];
    } else if (indexPath.section == 2) {
        event = [self.thirdEventsArray objectAtIndex:indexPath.row];
    } else {
        event = [self.fourthEventsArray objectAtIndex:indexPath.row];
    }
    

    eventViewController.event = event;
    eventViewController.eventStore = self.eventStore;
    

    
    [self.view addSubview:eventViewController.view];
    [self addChildViewController:eventViewController];
    [eventViewController didMoveToParentViewController:self];
    
    
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize retval = CGSizeMake(95, 150);
    return retval;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(5, 75, 5, 5);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"AddEvent"]) {
        UINavigationController *navController = segue.destinationViewController;
        ECAddEventViewController *eventViewCont = (ECAddEventViewController *)navController.topViewController;
        eventViewCont.eventStore = self.eventStore;
        eventViewCont.delegate = self;
    }
}


- (IBAction)addEvent:(id)sender {
    
    [self performSegueWithIdentifier:@"AddEvent" sender:nil];
}

- (void)ECAddEventViewRefresh {
    
    [self accessEventStore];
}


/*
- (NSInteger)collectionView:(UICollectionView*)cv layout:(UICollectionViewLayout*)cvl
   numberOfColumnsInSection:(NSInteger)section {
    
    
    return 3;
}


- (UIEdgeInsets)collectionView:(UICollectionView*)cv layout:(UICollectionViewLayout*)cvl
   itemInsetsForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);

}



- (CGSize)collectionView:(UICollectionView*)cv layout:(UICollectionViewLayout*)cvl
    sizeForItemWithWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    NSString *searchTerm = self.searches[indexPath.section];
    
    FlickrPhoto *photo = self.searchResults[searchTerm][indexPath.item];
    
    CGSize picSize = photo.thumbnail.size.width > 0.0f ? photo.thumbnail.size : CGSizeMake(100.0f, 100.0f);
    
    picSize.height += 35.0f; picSize.width += 35.0f;
    
    CGSize retval = CGSizeMake(width, return retval;
        
                               
                               
}

*/








































@end
