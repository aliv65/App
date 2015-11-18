//
//  TweetsViewController.m
//  TweetSearch
//
//  Created by Alexandr on 13.11.15.
//  Copyright (c) 2015 Alexandr. All rights reserved.
//

#import "TweetsViewController.h"
#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ServerManager.h"
#import "AppDelegate.h"
#import "TweetCell.h"
#import "Tweet.h"

@interface TweetsViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSArray *tweets;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) NSManagedObjectContext *context;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.context = delegate.mObjectContext;
    
    self.tweets = [self requestTweets];
    [self.tableView reloadData];
}

- (NSArray *)requestTweets {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Tweet"
                                                   inManagedObjectContext:self.context];
    [request setEntity:description];
    
    NSError *requestError = nil;
    NSArray *resultArray = [self.context executeFetchRequest:request error:&requestError];
    
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    return resultArray;
}

#pragma mark - Actions

- (IBAction)searchAction:(id)sender {
    
    [[ServerManager shManager] getTweetsOfHashtag:self.searchField.text count:10 onSuccess:^(NSArray *tweets) {
        self.tweets = [NSMutableArray arrayWithArray:tweets];
            
        NSArray *paths = [NSArray array];
        for (int i = 0; i < [self.tweets count]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            paths = [paths arrayByAddingObject:indexPath];
        }
        
        if ([self.tableView numberOfRowsInSection:0] == 0) {
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];
        } else {
            [self.tableView reloadData];
        }
        
        [self.searchField resignFirstResponder];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Tweet *tweet = self.tweets[indexPath.row];
    cell.dateLabel.text = tweet.createdDate;
    cell.nameLabel.text = tweet.userName;
    cell.textTweet.text = tweet.text;
    
    cell.profileImageView.image = nil;
    
    NSURL *url = [NSURL URLWithString:tweet.profileImageURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [cell.profileImageView setImageWithURLRequest:request placeholderImage:nil
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           cell.profileImageView.image = image;
                                           [self.view layoutSubviews];
                                       } 
    failure:nil];
    
    [cell.profileImageView.layer setBorderColor: [[UIColor colorWithRed:197.0/255.0 green:188.0/255.0 blue:195.0/255.0 alpha:1.0] CGColor]];
    [cell.profileImageView.layer setBorderWidth:2.5f];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Tweet *tweet = self.tweets[indexPath.row];
    return [self heightCellForText:tweet.text];
}

- (CGFloat)heightCellForText:(NSString *)text {
    
    CGFloat offset = 7.0;
    UIFont *font = [UIFont systemFontOfSize:12.f];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attributes = @{NSFontAttributeName :font, NSParagraphStyleAttributeName: paragraph};
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(320 - 2 * offset, CGFLOAT_MAX)
                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                   attributes:attributes
                  context:nil];
    
    return CGRectGetHeight(rect) + 2 * offset + 60;
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Tweet *tweet = self.tweets[indexPath.row];
    
    ProfileViewController *profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    
    profileViewController.tweet = tweet;
    
    [self.navigationController pushViewController:profileViewController animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.searchField]) {
        [self searchAction:textField];
    }
    return YES;
}

@end
