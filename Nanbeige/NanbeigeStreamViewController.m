//
//  NanbeigeStreamViewController.m
//  Nanbeige
//
//  Created by Wang Zhongyu on 12-7-9.
//  Copyright (c) 2012年 Peking University. All rights reserved.
//

#import "NanbeigeStreamViewController.h"
#import "Environment.h"
#import "NanbeigeAccountManager.h"

@interface NanbeigeStreamViewController () <AccountManagerDelegate> {
	NanbeigeAccountManager *accountManager;
}


@end

@implementation NanbeigeStreamViewController
@synthesize tableView = _tableView;
@synthesize streams = _streams;

#pragma mark - Setter and Getter methods

- (NSMutableArray *)streams
{
	if (_streams == nil) {
		_streams = [[NSMutableArray alloc] init];
	}
	return _streams;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.navigationController.navigationBar.tintColor = navBarBgColor1;
	self.tableView.backgroundColor = tableBgColor3;

	if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[view setBackgroundColor:tableBgColor1];
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
	
	self.title = TITLE_STREAM;
	self.streams = [[NSUserDefaults standardUserDefaults] valueForKey:kTEMPSTREAMS];
	
	accountManager = [[NanbeigeAccountManager alloc] initWithViewController:self];
	accountManager.delegate = self;
}

- (void)viewDidUnload
{
	[self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Display

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
	    return YES;
	} else {
	    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.streams.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (nil == cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
	}
	cell.textLabel.text = [[self.streams objectAtIndex:indexPath.row] objectForKey:kSTREAMTITLE];
    cell.detailTextLabel.text = [[[self.streams objectAtIndex:indexPath.row] objectForKey:kSTREAMDETAIL] stringValue];
	
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

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
	[accountManager requestBuildingsWithCampusID:[NSNumber numberWithInt:8]];
}

- (void)doneLoadingTableViewData{
	
	[self.tableView reloadData];
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[accountManager requestRoomsWithBuildingID:[[self.streams objectAtIndex:indexPath.row] objectForKey:kAPIID] Date:nil];
}

#pragma mark - Button controllerAction

- (IBAction)renrenPost:(id)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults valueForKey:kRENRENIDKEY] == nil) {
		[self showAlert:@"人人未授权！请到设置中授权"];
		self.tabBarController.selectedIndex = 2;
	} else {
		[self performSegueWithIdentifier:@"RenrenPostSegue" sender:self];
	}
}

- (IBAction)weiboPost:(id)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults valueForKey:kWEIBOIDKEY] == nil) {
		[self showAlert:@"微博未授权！请到设置中授权"];
		self.tabBarController.selectedIndex = 2;
	} else {
		[self performSegueWithIdentifier:@"WeiboPostSegue" sender:self];
	}
}

#pragma mark - AccountManagerDelegate Others

- (void)didBuildingsReceived:(NSArray *)buildings
{
	self.streams = [buildings mutableCopy];
	[[NSUserDefaults standardUserDefaults] setValue:buildings forKey:kTEMPSTREAMS];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];
}

- (void)didRoomsReceived:(NSArray *)rooms
{
	[[NSUserDefaults standardUserDefaults] setValue:rooms forKey:kTEMPROOMS];
	[self showAlert:[rooms description]];
}

- (void)didRequest:(ASIHTTPRequest *)request FailWithError:(NSString *)errorString
{
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];
	[self showAlert:errorString];
}

@end
