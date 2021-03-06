//
//  ECAddEventViewController.m
//  EZCalendar
//
//  Created by scott mehus on 11/10/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import "ECAddEventViewController.h"
#import "ECEvent.h"

#define kPickerAnimationDuration 0.40
#define kDatePickerTag 99

#define kTitleKey @"title"
#define kDateKey @"date"

#define kDateStartRow 1
#define kDateEndRow 2


static NSString *kDateCellID = @"dateCell";             //the cells with the start or end date
static NSString *kDatePickerID = @"datePicker";         // the cell containing the date picker
static NSString *kOtherCell = @"otherCell";             // the remaining cells at the end



@interface ECAddEventViewController () <UITextFieldDelegate, UIScrollViewDelegate>


@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UITextField *locationTextField;
@property (nonatomic, weak) IBOutlet UIDatePicker *pickerView;
// this button appears only when the date picker is shown
@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

// keep track which indexPath points to the cell with UIDatePicker
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *locationText;






@property (assign) NSInteger pickerCellRowHeight;




- (IBAction)closeScreen:(id)sender;
- (IBAction)finishedAdding:(id)sender;

@end

@implementation ECAddEventViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    
    }
    return self;
}

- (id)initWithEvent:(ECEvent *)event {
    
    if ((self = [super init])) {
    
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
  
    
    NSLog(@"EVENT STORE: %@", self.eventStore);
    
    if (self.editingEvent) {
        
        
            NSLog(@"EDITING IS YES WITH EVENT: %@", self.event.thisEvent);
    }

    
    /*
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gesture];
    */
    
    // setup our data source
    NSMutableDictionary *itemOne = [@{ kTitleKey : @"Tap a cell to change its date:" } mutableCopy];
    NSMutableDictionary *itemTwo = [@{ kTitleKey : @"Start Date",
                                       kDateKey : [NSDate date] } mutableCopy];
    NSMutableDictionary *itemThree = [@{ kTitleKey : @"End Date",
                                         kDateKey : [NSDate date] } mutableCopy];
    NSMutableDictionary *itemFour = [@{ kTitleKey : @"(other item1)" } mutableCopy];
    NSMutableDictionary *itemFive = [@{ kTitleKey : @"(other item2)" } mutableCopy];
    self.dataArray = @[itemOne, itemTwo, itemThree, itemFour, itemFive];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerID];
    self.pickerCellRowHeight = pickerViewCellToCheck.frame.size.height;
    
    
    // if the local changes while in the background, we need to be notified so we can update the date
    // format in the table view cells
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];

    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Locale

/*! Responds to region format or locale changes.
 */
- (void)localeChanged:(NSNotification *)notif
{
    // the user changed the locale (region format) in Settings, so we are notified here to
    // update the date format in the table view cells
    //
    [self.tableView reloadData];
}

#pragma mark - Utilities

/*! Returns the major version of iOS, (i.e. for iOS 6.1.3 it returns 6)
 */
NSUInteger DeviceSystemMajorVersion()
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    
    return _deviceSystemMajorVersion;
}


#define EMBEDDED_DATE_PICKER (DeviceSystemMajorVersion() >= 7)

/*! Determines if the given indexPath has a cell below it with a UIDatePicker.
 
 @param indexPath The indexPath to check if its cell has a UIDatePicker below it.
 */
- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasDatePicker = NO;
    
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkDatePickerCell =
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:1]];
    UIDatePicker *checkDatePicker = (UIDatePicker *)[checkDatePickerCell viewWithTag:kDatePickerTag];
    
    hasDatePicker = (checkDatePicker != nil);
    return hasDatePicker;
}

/*! Updates the UIDatePicker's value to match with the date of the cell above it.
 */
- (void)updateDatePicker
{
    if (self.datePickerIndexPath != nil)
    {
        UITableViewCell *associatedDatePickerCell = [self.tableView cellForRowAtIndexPath:self.datePickerIndexPath];
        
        UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:kDatePickerTag];
        if (targetedDatePicker != nil)
        {
            // we found a UIDatePicker in this cell, so update it's date value
            //
            NSDictionary *itemData = self.dataArray[self.datePickerIndexPath.row - 1];
            [targetedDatePicker setDate:[itemData valueForKey:kDateKey] animated:NO];
        }
    }
}

/*! Determines if the UITableViewController has a UIDatePicker in any of its cells.
 */
- (BOOL)hasInlineDatePicker
{
    return (self.datePickerIndexPath != nil);
}



/*! Determines if the given indexPath points to a cell that contains the UIDatePicker.
 
 @param indexPath The indexPath to check if it represents a cell with the UIDatePicker.
 */
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
    return ([self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row);
}


/*! Determines if the given indexPath points to a cell that contains the start/end dates.
 
 @param indexPath The indexPath to check if it represents start/end date cell.
 */
- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath
{
    BOOL hasDate = NO;
    
    if ((indexPath.row == kDateStartRow) ||
        (indexPath.row == kDateEndRow || ([self hasInlineDatePicker] && (indexPath.row == kDateEndRow + 1))))
    {
        hasDate = YES;
    }
    
    return hasDate;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self indexPathHasPicker:indexPath] ? self.pickerCellRowHeight : self.tableView.rowHeight);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    if (section == 0) {
        return 2;
    } else if (section == 1) {
    if ([self hasInlineDatePicker])
    {
        // we have a date picker, so allow for it in the number of rows in this section
        NSInteger numRows = self.dataArray.count;
        return ++numRows;
    }
    
    return self.dataArray.count;
    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    
 
   
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
        
        if (self.editingEvent) {
            
            UITextField *aTextField = (UITextField *)[cell viewWithTag:1001];
            aTextField.text = self.event.eventTitle;
        }
     
        
    
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
        
        if (self.editingEvent) {
            
            UITextField *bTextField = (UITextField *)[cell viewWithTag:1002];
            bTextField.text = self.event.eventLocation;
        }
    } else {
    
    
    
    
    
    NSString *cellID = kOtherCell;
 
    
    if ([self indexPathHasPicker:indexPath])
    {
        // the indexPath is the one containing the inline date picker
        cellID = kDatePickerID;     // the current/opened date picker cell
    }
    else if ([self indexPathHasDate:indexPath])
    {
        // the indexPath is one that contains the date information
        cellID = kDateCellID;       // the start/end date cells
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (indexPath.row == 0)
    {
        // we decide here that first cell in the table is not selectable (it's just an indicator)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // if we have a date picker open whose cell is above the cell we want to update,
    // then we have one more cell than the model allows
    //
    NSInteger modelRow = indexPath.row;
    if (self.datePickerIndexPath != nil && self.datePickerIndexPath.row < indexPath.row)
    {
        modelRow--;
    }
    
    NSDictionary *itemData = self.dataArray[modelRow];
    
    // proceed to configure our cell
    if ([cellID isEqualToString:kDateCellID])
    {
        // we have either start or end date cells, populate their date field
        //
        cell.textLabel.text = [itemData valueForKey:kTitleKey];
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[itemData valueForKey:kDateKey]];

    }
    else if ([cellID isEqualToString:kOtherCell])
    {
        // this cell is a non-date cell, just assign it's text label
        //
        cell.textLabel.text = [itemData valueForKey:kTitleKey];
        }   
    
    }
    return cell;
}


/*! Adds or removes a UIDatePicker cell below the given indexPath.
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:1]];
    
    // check if 'indexPath' has an attached date picker below it
    if ([self hasPickerForIndexPath:indexPath])
    {
        // found a picker below it, so remove it
        [self.tableView deleteRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        // didn't find a picker below it, so we should insert it
        [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
}


/*! Reveals the date picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // display the date picker inline with the table content
    [self.tableView beginUpdates];
    
    BOOL before = NO;   // indicates if the date picker is below "indexPath", help us determine which row to reveal
    if ([self hasInlineDatePicker])
    {
        before = self.datePickerIndexPath.row < indexPath.row;
    }
    
    BOOL sameCellClicked = (self.datePickerIndexPath.row - 1 == indexPath.row);
    
    // remove any date picker cell if it exists
    if ([self hasInlineDatePicker])
    {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:1]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
    }
    
    if (!sameCellClicked)
    {
        // hide the old date picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:1];
        
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:1];
    }
    
    // always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
    
    // inform our date picker of the current date to match the current cell
    [self updateDatePicker];
}


/*! Reveals the UIDatePicker as an external slide-in view, iOS 6.1.x and earlier, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath used to display the UIDatePicker.
 */
- (void)displayExternalDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // first update the date picker's date value according to our model
    NSDictionary *itemData = self.dataArray[indexPath.row];
    [self.pickerView setDate:[itemData valueForKey:kDateKey] animated:YES];
    
    // the date picker might already be showing, so don't add it to our view
    if (self.pickerView.superview == nil)
    {
        CGRect startFrame = self.pickerView.frame;
        CGRect endFrame = self.pickerView.frame;
        
        // the start position is below the bottom of the visible frame
        startFrame.origin.y = self.view.frame.size.height;
        
        // the end position is slid up by the height of the view
        endFrame.origin.y = startFrame.origin.y - endFrame.size.height;
        
        self.pickerView.frame = startFrame;
        
        [self.view addSubview:self.pickerView];
        
        // animate the date picker into view
        [UIView animateWithDuration:kPickerAnimationDuration animations: ^{ self.pickerView.frame = endFrame; }
                         completion:^(BOOL finished) {
                             // add the "Done" button to the nav bar
                             self.navigationItem.rightBarButtonItem = self.doneButton;
                         }];
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.reuseIdentifier == kDateCellID)
    {
        if (EMBEDDED_DATE_PICKER) {
            [self displayInlineDatePickerForRowAtIndexPath:indexPath];
            [self.view endEditing:YES];
        } else {
            [self displayExternalDatePickerForRowAtIndexPath:indexPath];
            
        }
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark - Actions

/*! User chose to change the date by changing the values inside the UIDatePicker.
 
 @param sender The sender for this action: UIDatePicker.
 */
- (IBAction)dateAction:(id)sender
{
    NSIndexPath *targetedCellIndexPath = nil;
    
    if ([self hasInlineDatePicker])
    {
        // inline date picker: update the cell's date "above" the date picker cell
        //
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:1];
    }
    else
    {
        // external date picker: update the current "selected" cell's date
        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    UIDatePicker *targetedDatePicker = sender;
    
    // update our data model
    NSMutableDictionary *itemData = self.dataArray[targetedCellIndexPath.row];
    [itemData setValue:targetedDatePicker.date forKey:kDateKey];
    
    // update the cell's date string
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
    self.startDate = targetedDatePicker.date;
}


/*! User chose to finish using the UIDatePicker by pressing the "Done" button, (used only for non-inline date picker), iOS 6.1.x or earlier
 
 @param sender The sender for this action: The "Done" UIBarButtonItem
 */

/*
- (IBAction)doneAction:(id)sender
{
    CGRect pickerFrame = self.pickerView.frame;
    pickerFrame.origin.y = self.view.frame.size.height;
    
    // animate the date picker out of view
    [UIView animateWithDuration:kPickerAnimationDuration animations: ^{ self.pickerView.frame = pickerFrame; }
                     completion:^(BOOL finished) {
                         [self.pickerView removeFromSuperview];
                     }];
    
    // remove the "Done" button in the navigation bar
    self.navigationItem.rightBarButtonItem = nil;
    
    // deselect the current table cell
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
*/

- (IBAction)closeScreen:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)finishedAdding:(id)sender {
    
    /*
    EKEvent *event;
    if (self.editingEvent) {
        event = self.event.thisEvent;
        NSLog(@"FINISHED EDITING EVENT");
    } else {
        event = [EKEvent eventWithEventStore:self.eventStore];
    }
    */
    
    EKEvent *event = self.event.thisEvent;
    
    
    event.title = self.titleText;
    event.location = self.locationText;
    event.startDate = self.startDate;
    event.endDate = [event.startDate dateByAddingTimeInterval:1];
    [event setCalendar:[self.eventStore defaultCalendarForNewEvents]];
    NSError *err;
    [self.eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];

    
    NSLog(@"FINISHED ADDING EVENT: %@ TITLE: %@", event, event.title);
    
    [self.delegate ECAddEventViewRefresh];
    [self dismissViewControllerAnimated:YES completion:nil];
}




-(void) textFieldDidEndEditing:(UITextField *)textField
{
    // assuming your text field is embedded directly into the table view
    // cell and not into any other subview of the table cell
    UITableViewCell * parentView = (UITableViewCell *)[textField superview];
    
    if(parentView)
    {
        
        NSArray * allSubviews = [parentView subviews];
        for(UIView * oneSubview in allSubviews)
        {
            // get only the text fields
            if([oneSubview isKindOfClass: [UITextField class]])
            {
                
                UITextField * oneTextField = (UITextField *) oneSubview;
                
                if (oneTextField.tag == 1001) {
                    self.titleText = oneTextField.text;
                    self.titleTextField = oneTextField;
                    
                } else if (oneTextField.tag == 1002) {
                    self.locationText = oneTextField.text;
                    self.locationTextField = oneTextField;
                }
                
            }
        }
    }
}



- (void)hideKeyboard

{
    [self.titleTextField resignFirstResponder];
    [self.locationTextField resignFirstResponder];

    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}


/*





// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */














@end
