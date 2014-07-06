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
    
    INAppStoreWindow *iasWindow;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    iasWindow = (INAppStoreWindow*) self.window;
    iasWindow.titleBarHeight = 35;
    iasWindow.showsTitle = YES;
    iasWindow.title = @"Viewport";
    iasWindow.verticallyCenterTitle = YES;
    
    [self showLoginView];
}

-(void)loginFaildWithError:(NSString *)error reason:(NSString *)reason description:(NSString *)description
{
    NSLog(@"login failed:%@", error);
    [loginViewController stop];
}

-(void)loginSucceededWithAccessToken:(NSString *)token
{
    [VPInfo setAccessToken:token];
    [loginViewController stop];
}

-(void) onSelfFeedsLoaded:(NSData *)jsonData
{
    [feedsViewController updateData:jsonData];
}

-(void) onPopularFeedsLoaded:(NSData *)jsonData
{
    [popularViewController updateData:jsonData];
}

- (IBAction)showTimeline:(id)sender {
    [self showFeedsView];
}

- (IBAction)showPopular:(id)sender {
    [self showPopularView];
}

- (void) showPopularView
{
    popularViewController = [[VPFeedsViewController alloc] initWithNibName:@"VPFeedsViewController" bundle:nil];
    [self.contentArea addSubview:popularViewController.view];
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
    
    [self.contentArea addConstraints:constraint1];
    [self.contentArea addConstraints:constraint2];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[VPInfo retrieveSelfTimelineUrl]];
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
    [self.contentArea addSubview:feedsViewController.view];
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
    
    [self.contentArea addConstraints:constraint1];
    [self.contentArea addConstraints:constraint2];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[VPInfo retrievePopularUrl]];
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
    [self.contentArea addSubview: loginViewController.view];
    
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
    
    [self.contentArea addConstraints:constraint1];
    [self.contentArea addConstraints:constraint2];
    [self.contentArea setWantsLayer:YES];
    [self.contentArea layer].backgroundColor = CGColorCreateGenericRGB(1, 0, 0, 1);
    
    
    [loginViewController loadLoginPage];
}
@end
