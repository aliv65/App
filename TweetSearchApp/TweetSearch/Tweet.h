//
//  Tweet.h
//  TweetSearch
//
//  Created by Alexandr on 13.11.15.
//  Copyright (c) 2015 Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tweet : NSManagedObject

@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * profileImageURL;
@property (nonatomic, retain) NSString * countFriends;
@property (nonatomic, retain) NSString * createdDate;
@property (nonatomic, retain) NSString * text;

@end
