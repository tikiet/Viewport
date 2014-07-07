//
//  VPAppDelegate.m
//  Viewport
//
//  Created by 吴旭东 on 14-6-29.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import "VPAppDelegate.h"
#import "INAppStoreWindow.h"
#import "VPConnectionDataDepot.h"

@implementation VPAppDelegate
{
    VPLoginViewController *loginViewController;
    VPFeedsViewController *feedsViewController;
    VPFeedsViewController *popularViewController;
    VPFeedsViewController *favoritesViewController;
    
    INAppStoreWindow *iasWindow;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // configure title bar
    iasWindow = (INAppStoreWindow*) self.window;
    iasWindow.titleBarHeight = 35;
    iasWindow.showsTitle = YES;
    iasWindow.title = @"Viewport";
    iasWindow.verticallyCenterTitle = YES;
    
    if ([VPInfo accessToken]) {
        [self showFeedsView];
    } else {
        [self showLoginView];
    }
}

-(void)loginFaildWithError:(NSString *)error reason:(NSString *)reason description:(NSString *)description
{
    NSLog(@"login failed:%@", error);
    [loginViewController stop];
    [loginViewController.view removeFromSuperview];
    loginViewController = nil;
}

-(void)loginSucceededWithAccessToken:(NSString *)token
{
    [VPInfo setAccessToken:token];
    [loginViewController stop];
    [loginViewController.view removeFromSuperview];
    loginViewController = nil;
}

-(void) onSelfFeedsLoaded:(NSData *)jsonData
{
    [feedsViewController updateData:jsonData];
}

-(void) onPopularFeedsLoaded:(NSData *)jsonData
{
    [popularViewController updateData:jsonData];
}

-(void) onFavoriteFeedsLoaded:(NSData *)jsonData
{
    [favoritesViewController updateData:jsonData];
}

- (IBAction)showTimeline:(id)sender {
    [self showFeedsView];
}

- (IBAction)showPopular:(id)sender {
    [self showPopularView];
}

- (IBAction)showFavorites:(id)sender {
    [self showFavoritesView];
}

- (void) showPopularView
{
    popularViewController = [[VPFeedsViewController alloc] initWithNibName:@"VPFeedsViewController" bundle:nil];
    NSView *parent = self.contentArea;
    
    [parent addSubview:popularViewController.view];
    NSView *view = popularViewController.view;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[view]-(0)-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(view)];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[view]-(0)-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(view)];
    
    [parent addConstraints:constraint1];
    [parent addConstraints:constraint2];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[VPInfo retrievePopularUrl]];
    NSURLConnection *con =
    [[NSURLConnection alloc] initWithRequest:request
                                    delegate:[[VPConnectionDataDepot alloc]
                                              initWithSuccessBlock:^(NSData *data){
                                                  [self onPopularFeedsLoaded:data];
                                              } failBlock:^(NSError *error){
                                                  
                                              }]
                            startImmediately:NO];
    
    [con start];
}

- (void) showFeedsView
{
    feedsViewController = [[VPFeedsViewController alloc] initWithNibName:@"VPFeedsViewController" bundle:nil];
    NSView *parent = self.contentArea;
    
    [parent addSubview:feedsViewController.view];
    NSView *view = feedsViewController.view;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[view]-(0)-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(view)];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[view]-(0)-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(view)];
    
    [parent addConstraints:constraint1];
    [parent addConstraints:constraint2];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[VPInfo retrieveSelfTimelineUrl]];
    NSURLConnection *con =
    [[NSURLConnection alloc] initWithRequest:request
                                    delegate:[[VPConnectionDataDepot alloc]
                                              initWithSuccessBlock:^(NSData *data){
                                                  [self onSelfFeedsLoaded:data];
                                              } failBlock:^(NSError *error){
                                                  
                                              }]
                            startImmediately:NO];
    
    [con start];
}

- (void) showLoginView
{
    loginViewController = [[VPLoginViewController alloc] initWithNibName:@"VPLoginViewController" bundle:nil];
    loginViewController.delegate = self;
    
    NSView *parent = self.rootView;
    [parent addSubview: loginViewController.view];
    
    NSView *view = loginViewController.view;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[view]-(0)-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(view)];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[view]-(0)-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(view)];
    
    [parent addConstraints:constraint1];
    [parent addConstraints:constraint2];
    
    [loginViewController loadLoginPage];
}

-(void) showFavoritesView
{
    favoritesViewController = [[VPFeedsViewController alloc] initWithNibName:@"VPFeedsViewController" bundle:nil];
    NSView *parent = self.contentArea;
    
    [parent addSubview:favoritesViewController.view];
    NSView *view = favoritesViewController.view;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[view]-(0)-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(view)];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[view]-(0)-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(view)];
    
    [parent addConstraints:constraint1];
    [parent addConstraints:constraint2];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[VPInfo retrieveFavoritesUrl]];
    NSURLConnection *con =
    [[NSURLConnection alloc] initWithRequest:request
                                    delegate:[[VPConnectionDataDepot alloc]
                                              initWithSuccessBlock:^(NSData *data){
                                                  [self onFavoriteFeedsLoaded:data];
                                              } failBlock:^(NSError *error){
                                                  
                                              }]
                            startImmediately:NO];
    
    [con start];
}
@end
