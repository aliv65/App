//
//  AppDelegate.h
//  TweetSearch
//
//  Created by Alexandr on 13.11.15.
//  Copyright (c) 2015 Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *mObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *mObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *pCoordinator;

- (void)saveContext;
- (NSURL *)appDocumentsDirectory;


@end

