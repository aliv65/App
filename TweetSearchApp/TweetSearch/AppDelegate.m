//
//  AppDelegate.m
//  TweetSearch
//
//  Created by Alexandr on 13.11.15.
//  Copyright (c) 2015 Alexandr. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize mObjectContext = _mObjectContext;
@synthesize mObjectModel = _mObjectModel;
@synthesize pStoreCoordinator = _pStoreCoordinator;

- (NSURL *)appDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)mObjectModel {
    if (_mObjectModel != nil) {
        return _mObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TweetSearch" withExtension:@"momd"];
    _mObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _mObjectModel;
}

- (NSPersistentStoreCoordinator *)pStoreCoordinator {
    if (_pStoreCoordinator != nil) {
        return _pStoreCoordinator;
    }
    
    _pStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self mObjectModel]];
    NSURL *storeURL = [[self appDocumentsDirectory] URLByAppendingPathComponent:@"TweetSearch.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"Error loading the application's saved data.";
    if (![_pCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _pStoreCoordinator;
}


- (NSManagedObjectContext *)mObjectContext {
    if (_mObjectContext != nil) {
        return _mObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self pStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _mObjectContext = [[NSManagedObjectContext alloc] init];
    [_mObjectContext setPersistentStoreCoordinator:coordinator];
    return _mObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *mObjectContext = self.mObjectContext;
    if (mObjectContext != nil) {
        NSError *error = nil;
        if ([mObjectContext hasChanges] && ![mObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
