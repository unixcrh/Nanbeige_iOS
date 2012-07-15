//
//  NanbeigeAppDelegate.h
//  Nanbeige
//
//  Created by Wang Zhongyu on 12-7-9.
//  Copyright (c) 2012年 Peking University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PABezelHUDDelegate.h"
#import "AppUserDelegateProtocol.h"
#import "ReachabilityProtocol.h"
#import "Reachability.h"
#import "AppCoreDataProtocol.h"

@class SwitchViewController,NSPersistentStoreCoordinator,NSManagedObjectContext;
@class FirstViewController;
@class MainViewController;
@class WelcomeViewController;
@class AppUser;
@class Course;

@interface NanbeigeAppDelegate : UIResponder <ReachabilityProtocol,UIApplicationDelegate,UINavigationControllerDelegate,AppUserDelegateProtocol,AppUserDelegateProtocol,PABezelHUDDelegate> {
	
	NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSString *persistentStorePath;
    AppUser *appUser;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain, readonly) NSOperationQueue *operationQueue;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSString *persistentStorePath;

@property (nonatomic, retain)AppUser *appUser;
@property (atomic, retain) Reachability *wifiTester;
@property (atomic, retain) Reachability *internetTester;
@property (atomic, retain) Reachability *globalTester;
@property (atomic, retain) Reachability *freeTester;
@property (atomic, retain) Reachability *localTester;
@property (atomic) PKUNetStatus netStatus;
@property (nonatomic) BOOL hasWifi;
@property (nonatomic, retain)MBProgressHUD *progressHub;

@property (nonatomic, retain, readonly) NSDictionary *test_data;


- (void)logout;
- (BOOL)authUserForAppWithItsID:(NSString *)itsid itsPassword:(NSString *)itspassword sessionID:(NSString *)sid error:(NSString **)stringError;
- (BOOL)authUserForAppWithCoursesID:(NSString *)coursesid coursesPassword:(NSString *)coursespassword coursesCode:(NSString *)coursescode sessionID:(NSString *)sid error:(NSString **)stringError;
- (BOOL)authUserForAppWithRenrenID:(NSString *)renrenid renrenName:(NSString *)renrenname error:(NSString **)stringError;
- (BOOL)authUserForAppWithWeiboID:(NSString *)weiboid weiboName:(NSString *)weiboname error:(NSString **)stringError;
-(BOOL)updateDefaultMainFunctionOrder:(NSMutableArray *)newFunctionOrder error:(NSString **)stringError;
-(NSArray *)defaultMainFunctionOrder;

- (BOOL)refreshAppSession;
- (NSError *)updateAppUserProfile;
- (NSError *)updateServerCourses;
- (void)saveCourse:(Course *)_course withDict:(NSDictionary *)dict;
- (void)netStatusDidChanged:(Reachability *)notice;

@end
