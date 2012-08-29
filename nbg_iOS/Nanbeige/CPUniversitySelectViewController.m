//
//  CPChooseSchoolViewController.m
//  CP
//
//  Created by ZongZiWang on 12-8-1.
//  Copyright (c) 2012年 Peking University. All rights reserved.
//

#import "CPUniversitySelectViewController.h"
#import "Environment.h"
#import "Coffeepot.h"
#import "Models+addon.h"

@interface CPUniversitySelectViewController () {
	NSMutableArray *campuses;
	NSDictionary *campus_selected;
}

@end

@implementation CPUniversitySelectViewController

#pragma mark - Setter and Getter Methods

- (void)setQuickDialogTableView:(QuickDialogTableView *)aQuickDialogTableView {
    [super setQuickDialogTableView:aQuickDialogTableView];
    self.quickDialogTableView.backgroundView = nil;
    self.quickDialogTableView.backgroundColor = tableBgColorGrouped;
	self.quickDialogTableView.deselectRowWhenViewAppears = YES;
}

#pragma mark - View Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		self.root = [[QRootElement alloc] initWithJSONFile:@"universitySelect"];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"欢迎" style:UIBarButtonItemStyleBordered target:nil action:nil];
	if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"CPIsSignedIn"] boolValue]) {
		UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:sCANCEL style:UIBarButtonItemStyleBordered target:self action:@selector(close)];
		self.navigationItem.leftBarButtonItem = closeButton;
	}
	
	[[Coffeepot shared] requestWithMethodPath:@"university/" params:nil requestMethod:@"GET" success:^(CPRequest *_req, id collection) {
		
		campuses = [[NSMutableArray alloc] init];
		for (NSDictionary *universityDict in collection) {
			
			NSNumber *university_id = [universityDict objectForKey:@"id"];
			NSString *university_name = [universityDict objectForKey:@"name"];
			
			University *university = [University universityWithID:university_id];
			university.doc_type = @"university";
			university.id = university_id;
			university.name = university_name;
			university.campuses = [universityDict objectForKey:@"campuses"];
			RESTOperation *op = [university save];
			if (op && ![op wait]) [self showAlert:[op.error description]];
			
			for (NSDictionary *campusDict in [universityDict objectForKey:@"campuses"]) {
				NSDictionary *displayCampus = @{
				@"campus" : @{
					@"id" : [campusDict objectForKey:@"id"],
					@"name" : [campusDict objectForKey:@"name"]},
				@"university" : @{
					@"id" : university_id,
					@"name" : university_name},
				@"display_name" : [[universityDict objectForKey:@"name"] stringByAppendingFormat:@" %@", [campusDict objectForKey:@"name"]]};
				[campuses addObject:displayCampus];
			}
		}
		NSDictionary *dict = @{@"campuses":campuses};
		[self.root bindToObject:dict];
		
		[self.quickDialogTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
		
		[self loading:NO];
		
	} error:^(CPRequest *request, NSError *error) {
		[self loading:NO];
		[self showAlert:[error description]];//NSLog(@"%@", [error description]);
	}];
	
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self loading:YES];	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
	[[[UIAlertView alloc] initWithTitle:nil
								message:message
							   delegate:nil
					  cancelButtonTitle:sCONFIRM
					  otherButtonTitles:nil] show];
}

#pragma mark - Button controllerAction

- (void)close
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)onCampusSelect:(id)sender
{
	NSUInteger index = [[[sender parentSection] elements] indexOfObject:sender];
	campus_selected = [campuses objectAtIndex:index];
	
	if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"CPIsSignedIn"] boolValue]) {
		
		[[Coffeepot shared] requestWithMethodPath:@"user/edit/" params:@{ @"campus_id" : [[campus_selected objectForKey:@"campus"] objectForKey:@"id"] } requestMethod:@"POST" success:^(CPRequest *_req, id collection) {
			
			[self onFetchUniversity:[[campus_selected objectForKey:@"university"] objectForKey:@"id"]];
			
		} error:^(CPRequest *request, NSError *error) {
			[self loading:NO];
			[self showAlert:[error description]];//NSLog(@"%@", [error description]);
		}];
		
	} else {
		[self loading:NO];
		[self onComplete];
	}
	
	[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
	[self loading:YES];
}

- (void)onFetchUniversity:(NSNumber *)university_id
{
	
	[[Coffeepot shared] requestWithMethodPath:[NSString stringWithFormat:@"university/%@/", university_id] params:nil requestMethod:@"GET" success:^(CPRequest *_req, id collection) {
		
		if ([collection isKindOfClass:[NSDictionary class]]) {
			NSDictionary *universityDict = collection;
			
			University *university = [University universityWithID:university_id];
			university.doc_type = @"university";
			university.id = university_id;
			university.name = [universityDict objectForKey:@"name"];
			university.support_import_course = [[universityDict objectForKey:@"support"] objectForKey:@"import_course"];
			university.support_list_course = [[universityDict objectForKey:@"support"] objectForKey:@"list_course"];
			university.lessons_count_afternoon = [[[universityDict objectForKey:@"lessons"] objectForKey:@"count"] objectForKey:@"afternoon"];
			university.lessons_count_evening = [[[universityDict objectForKey:@"lessons"] objectForKey:@"count"] objectForKey:@"evening"];
			university.lessons_count_morning = [[[universityDict objectForKey:@"lessons"] objectForKey:@"count"] objectForKey:@"morning"];
			university.lessons_count_total = [[[universityDict objectForKey:@"lessons"] objectForKey:@"count"] objectForKey:@"total"];
			university.lessons_detail = [[universityDict objectForKey:@"lessons"] objectForKey:@"detail"];
			university.lessons_separators = [[universityDict objectForKey:@"lessons"] objectForKey:@"separators"];
			
			RESTOperation *op = [university save];
			if (op && ![op wait]) [self showAlert:[op.error description]];
			else {
				[self onFetchSemester:university_id];
			}
			
		} else {
			[self loading:NO];
			[self showAlert:@"University返回结果不是NSDictionary"];
		}
		
	} error:^(CPRequest *request, NSError *error) {
		[self loading:NO];
		[self showAlert:[error description]];//NSLog(@"%@", [error description]);
	}];
}

- (void)onFetchSemester:(NSNumber *)university_id
{
	[[Coffeepot shared] requestWithMethodPath:[NSString stringWithFormat:@"university/%@/semester/", university_id] params:nil requestMethod:@"GET" success:^(CPRequest *_req, id collection) {
		
		if ([collection isKindOfClass:[NSArray class]]) {
			
			for (NSDictionary *semesterDict in collection) {
				
				Semester *semester = [Semester semesterWithID:[semesterDict objectForKey:@"id"]];
				
				semester.doc_type = @"semester";
				semester.id = [semesterDict objectForKey:@"id"];
				semester.name = [semesterDict objectForKey:@"name"];
				semester.year = [semesterDict objectForKey:@"year"];
				semester.week_start = [[semesterDict objectForKey:@"week"] objectForKey:@"start"];
				semester.week_end = [[semesterDict objectForKey:@"week"] objectForKey:@"end"];
				
				RESTOperation *op = [semester save];
				if (op && ![op wait])
					[self showAlert:[op.error description]];
				else {
					[self onFetchWeekset:[semesterDict objectForKey:@"id"]];
				}
			}
			
			[self loading:NO];
			
			[self onComplete];
			
		} else {
			[self loading:NO];
			[self showAlert:@"Semester返回结果不是NSArray"];
		}
		
	} error:^(CPRequest *request, NSError *error) {
		[self loading:NO];
		[self showAlert:[error description]];//NSLog(@"%@", [error description]);
	}];
}

- (void)onFetchWeekset:(NSNumber *)semester_id
{
	
	[[Coffeepot shared] requestWithMethodPath:[NSString stringWithFormat:@"university/semester/%@/weekset/", semester_id] params:nil requestMethod:@"GET" success:^(CPRequest *_req, id collection) {
		
		if ([collection isKindOfClass:[NSArray class]]) {
			
			for (NSDictionary *weeksetDict in collection) {
				
				Weekset *weekset = [Weekset weeksetWithID:[weeksetDict objectForKey:@"id"]];
				
				weekset.doc_type = @"weekset";
				weekset.id = [weeksetDict objectForKey:@"id"];
				weekset.name = [weeksetDict objectForKey:@"name"];
				weekset.weeks = [weeksetDict objectForKey:@"weeks"];
				
				RESTOperation *op = [weekset save];
				if (op && ![op wait])
					[self showAlert:[op.error description]];
				else {
					return ;
				}
			}
			
		} else {
			[self loading:NO];
			[self showAlert:@"Weekset返回结果不是NSArray"];
		}
		
	} error:^(CPRequest *request, NSError *error) {
		[self loading:NO];
		[self showAlert:[error description]];//NSLog(@"%@", [error description]);
	}];
}

- (void)onComplete
{
	[User updateSharedAppUserProfile:campus_selected];
	[User updateSharedAppUserProfile:@{ @"course_imported" : @[] }];
	if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"CPIsSignedIn"] boolValue])
		[self dismissModalViewControllerAnimated:YES];
	else
		[self performSegueWithIdentifier:@"SigninConfirmSegue" sender:self];
}

@end
