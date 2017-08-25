//
//  AppDelegate.h
//  shuoyeahProject
//
//  Created by shuoyeah on 16/7/27.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
static NSString *appKey = @"d0646576514bc6270b5f80fa";
static NSString *channel = @"App Store";
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

