//
//  NanbeigeMainViewController.m
//  Nanbeige
//
//  Created by Wang Zhongyu on 12-7-9.
//  Copyright (c) 2012年 Peking University. All rights reserved.
//

#import "NanbeigeMainViewController.h"
#import "Environment.h"
#import "NanbeigeLine1Button0Cell.h"
#import "NanbeigeLine2Button0Cell.h"
#import "NanbeigeLine2Button2Cell.h"
#import "NanbeigeLine3Button0Cell.h"
#import "NanbeigeLine3Button2Cell.h"

@interface NanbeigeMainViewController ()

@end

@implementation NanbeigeMainViewController
@synthesize editFunctionButton;
@synthesize delegate;
@synthesize functionOrder = _functionOrder;
@synthesize functionArray;
@synthesize nibsRegistered;
@synthesize nivc;
@synthesize connector;
@synthesize navc;

#pragma mark - getter and setter Override

- (NSObject<AppCoreDataProtocol,AppUserDelegateProtocol,ReachabilityProtocol,PABezelHUDDelegate> *)delegate {
    if (delegate == nil) {
        delegate = (NSObject<AppCoreDataProtocol,AppUserDelegateProtocol,ReachabilityProtocol,PABezelHUDDelegate> *)[UIApplication sharedApplication].delegate;
    }
    return delegate;
}
- (NSArray *)functionOrder
{
	if (_functionOrder == nil) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSMutableArray *newOrder = [[[defaults valueForKey:kMAINORDERKEY] componentsSeparatedByString:@","] mutableCopy];
		if (newOrder == nil || newOrder.count < 7) {
			newOrder = [[NSMutableArray alloc] init];
			int cnt = functionArray.count;
			for (int i = 0; i < cnt; i++) {
				[newOrder addObject:[NSString stringWithFormat:@"%d", i]];
			}
		};
		_functionOrder = [[NSArray alloc] initWithArray:newOrder];
	}
	return _functionOrder;
}

#pragma mark - View Lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.navigationController.navigationBar.backgroundColor = navBarBgColor;
	self.tableView.backgroundColor = tableBgColor;
	
	// TODO
	NSDictionary *itsDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
							 @"IP网关", @"name",
							 @"its", @"image", 
							 @"Line1Button0Identifier", @"identifier",
							 @"NanbeigeLine1Button0Cell", @"nibname",
							 nil];
	NSDictionary *coursesDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
								 @"课程", @"name", 
								 @"courses", @"image", 
								 @"Line3Button0Identifier", @"identifier", 
								 @"NanbeigeLine3Button0Cell", @"nibname",
								 nil];
	NSDictionary *roomsDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
							   @"自习室", @"name", 
							   @"rooms", @"image", 
							   @"Line1Button0Identifier", @"identifier", 
							   @"NanbeigeLine1Button0Cell", @"nibname",
							   nil];
	NSDictionary *calendarDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
								  @"校园黄页", @"name", 
								  @"calendar", @"image", 
								  @"Line1Button0Identifier", @"identifier", 
								  @"NanbeigeLine1Button0Cell", @"nibname",
								  nil];
	NSDictionary *feedbackDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
								  @"反馈", @"name", 
								  @"feedback", @"image", 
								  @"Line1Button0Identifier", @"identifier",
								  @"NanbeigeLine1Button0Cell", @"nibname",
								  nil];
	NSDictionary *activityDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
								  @"活动", @"name", 
								  @"Icon", @"image", 
								  @"Line2Button0Identifier", @"identifier", 
								  @"NanbeigeLine2Button0Cell", @"nibname",
								  nil];
	NSDictionary *homeworkDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
								  @"作业", @"name", 
								  @"180-stickynote", @"image", 
								  @"Line2Button2Identifier", @"identifier", 
								  @"NanbeigeLine2Button2Cell", @"nibname",
								  nil];
	
	functionArray =[[NSMutableArray alloc] initWithObjects:itsDict, coursesDict, roomsDict, calendarDict, feedbackDict, activityDict, homeworkDict, nil];
	
	nibsRegistered = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
					  @"NO", @"NanbeigeLine1Button0Cell",
					  @"NO", @"NanbeigeLine2Button0Cell",
					  @"NO", @"NanbeigeLine2Button2Cell", 
					  @"NO", @"NanbeigeLine3Button0Cell",
					  @"NO", @"NanbeigeLine3Button2Cell", 
					  nil];
	self.connector = [[NanbeigeIPGateHelper alloc] init];
}
- (void)viewDidUnload
{
	[self setFunctionOrder:nil];
	[self setFunctionArray:nil];
	[self setNibsRegistered:nil];
	[self setEditFunctionButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated
{
	if ([[[self.functionArray objectAtIndex:0] objectForKey:@"identifier"] isEqualToString:@"Line3Button2Identifier"] && [[NSUserDefaults standardUserDefaults] objectForKey:kITSIDKEY] == nil) {
		NSDictionary *itsDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
								 @"IP网关", @"name",
								 @"its", @"image", 
								 @"Line1Button0Identifier", @"identifier",
								 @"NanbeigeLine1Button0Cell", @"nibname",
								 nil];
		[self.functionArray removeObjectAtIndex:0];
		[self.functionArray insertObject:itsDict atIndex:0];
		[self.tableView reloadData];
	} else if ([[[self.functionArray objectAtIndex:0] objectForKey:@"identifier"] isEqualToString:@"Line1Button0Identifier"] && [[NSUserDefaults standardUserDefaults] objectForKey:kITSIDKEY] != nil) {
		NSDictionary *itsDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
								 @"IP网关", @"name",
								 @"its", @"image", 
								 @"Line3Button2Identifier", @"identifier",
								 @"NanbeigeLine3Button2Cell", @"nibname",
								 nil];
		[self.functionArray removeObjectAtIndex:0];
		[self.functionArray insertObject:itsDict atIndex:0];
		[self.tableView reloadData];
	}
}


-(void)showAlert:(NSString*)message{
	UIAlertView* alertView =[[UIAlertView alloc] initWithTitle:nil 
													   message:message
													  delegate:nil
											 cancelButtonTitle:@"确定"
											 otherButtonTitles:nil];
	[alertView show];
}
- (IBAction)calendarButtonPressed:(id)sender {
	[self showAlert:@"日历功能正在制作中，敬请期待！"];
}

-(IBAction)editFunctionOrder:(id)sender{
	[self.tableView setEditing:!self.tableView.editing animated:YES];
	if (self.tableView.editing)
		[editFunctionButton setTitle:@"完成"];
	else
		[editFunctionButton setTitle:@"编辑"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
	    return (interfaceOrientation == UIInterfaceOrientationPortrait);
		//return YES;
	} else {
	    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	}
}

#pragma mark -
#pragma mark Table View Attributes Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	NSUInteger functionIndex = [(NSString *)([self.functionOrder objectAtIndex:row]) integerValue];
	NSString *identifier = [[functionArray objectAtIndex:functionIndex] objectForKey:@"identifier"];
	NSString *nibName = [[functionArray objectAtIndex:functionIndex] objectForKey:@"nibname"];
	
	if ([[nibsRegistered objectForKey:nibName] isEqualToString:@"NO"]) {
		UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
		[tableView registerNib:nib forCellReuseIdentifier:identifier];
		[nibsRegistered setValue:@"YES" forKey:nibName];
	}
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	return cell.frame.size.height;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [functionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	NSUInteger row = [indexPath row];
	NSUInteger functionIndex = [(NSString *)([self.functionOrder objectAtIndex:row]) integerValue];
	NSString *identifier = [[functionArray objectAtIndex:functionIndex] objectForKey:@"identifier"];
	NSString *nibName = [[functionArray objectAtIndex:functionIndex] objectForKey:@"nibname"];
	NSString *name = [[functionArray objectAtIndex:functionIndex] objectForKey:@"name"];
	NSString *image = [[functionArray objectAtIndex:functionIndex] objectForKey:@"image"];
	
	if ([[nibsRegistered objectForKey:nibName] isEqualToString:@"NO"]) {
		UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
		[tableView registerNib:nib forCellReuseIdentifier:identifier];
		[nibsRegistered setValue:@"YES" forKey:nibName];
	}
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (nil == cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}
	
	if ([nibName isEqualToString:@"NanbeigeLine1Button0Cell"]) {
		((NanbeigeLine1Button0Cell*) cell).name = name;
		((NanbeigeLine1Button0Cell*) cell).image = image;
	} else if ([nibName isEqualToString:@"NanbeigeLine2Button0Cell"]) {
		((NanbeigeLine2Button0Cell*) cell).name = name;
		((NanbeigeLine2Button0Cell*) cell).image = image;
	} else if ([nibName isEqualToString:@"NanbeigeLine2Button2Cell"]) {
		((NanbeigeLine2Button2Cell*) cell).name = name;
		((NanbeigeLine2Button2Cell*) cell).image = image;
	} else if ([nibName isEqualToString:@"NanbeigeLine3Button0Cell"]) {
		((NanbeigeLine3Button0Cell*) cell).name = name;
		((NanbeigeLine3Button0Cell*) cell).image = image;
	} else if ([nibName isEqualToString:@"NanbeigeLine3Button2Cell"]) {
		((NanbeigeLine3Button2Cell*) cell).name = name;
		((NanbeigeLine3Button2Cell*) cell).image = image;
	}
	
    return cell;
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
	NSMutableArray *newOrder = [self.functionOrder mutableCopy];
	NSUInteger fromRow = [fromIndexPath row];
	NSUInteger toRow = [toIndexPath row];
	id object = [newOrder objectAtIndex:fromRow];
	[newOrder removeObjectAtIndex:fromRow];
	[newOrder insertObject:object atIndex:toRow];
	
	NSString * neworderStr = [newOrder componentsJoinedByString:@","];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setValue:neworderStr forKey:kMAINORDERKEY];
	
	self.functionOrder = [[NSArray alloc] initWithArray:newOrder];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
	NSUInteger row = [indexPath row];
	NSUInteger functionIndex = [(NSString *)([self.functionOrder objectAtIndex:row]) integerValue];
	if (functionIndex == 0) {
		if (self.nivc == nil) [self performSegueWithIdentifier:@"ItsEnterSegue" sender:self];
		else [self.navigationController pushViewController:self.nivc animated:YES];
	} else if (functionIndex == 6) {
		if (self.navc == nil) [self performSegueWithIdentifier:@"AssignmentEnterSegue" sender:self];
		else [self.navigationController pushViewController:self.navc animated:YES];
	} else {
		[self showAlert:@"功能正在制作中，敬请期待！"];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ItsEnterSegue"]) {
		NanbeigeItsViewController *destinationViewController = (NanbeigeItsViewController *)[segue destinationViewController];
		destinationViewController.connector = self.connector;
		self.connector.delegate = destinationViewController;
		self.nivc = destinationViewController;
	} else if ([segue.identifier isEqualToString:@"AssignmentEnterSegue"]) {
		NanbeigeAssignmentViewController *destinationViewController = (NanbeigeAssignmentViewController *)[segue destinationViewController];
		self.navc = destinationViewController;
	}
}

@end
