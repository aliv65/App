//
//  ProfileViewController.m
//  TweetSearch
//
//  Created by Alexandr on 13.11.15.
//  Copyright (c) 2015 Alexandr. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Tweet.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *uImageView;
@property (weak, nonatomic) IBOutlet UILabel *uNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *uFriendsCount;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.uNameLabel.text = self.tweet.userName;
    self.uFriendsCount.text = [NSString stringWithFormat:@"Friends numb: %@", self.tweet.countFriends];
    
    self.uImageView.image = nil;
    
    NSURL *url = [NSURL URLWithString:self.tweet.profileImageURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.uImageView setImageWithURLRequest:request placeholderImage:nil
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           self.uImageView.image = image;
                                           [self.view layoutSubviews];
                                       } failure:nil];
    
    [self.uImageView.layer setBorderColor: [[UIColor colorWithRed:130.0/255.0 green:185.0/255.0 blue:230.0/255.0 alpha:1.0] CGColor]];
    [self.uImageView.layer setBorderWidth:3.0f];
}

@end
