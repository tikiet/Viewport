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
    MASPreferencesWindowController *preferencesWindowController;
    
    INAppStoreWindow *iasWindow;
}

- (IBAction)openPreference:(id)sender {
    if (!preferencesWindowController) {
        VPPreferenceAdvancedViewController *advanced = [[VPPreferenceAdvancedViewController alloc]init];
        NSArray *controllers = [NSArray arrayWithObjects:advanced, nil];
        NSString *title = @"Preferences";
        
        preferencesWindowController = [[MASPreferencesWindowController alloc]initWithViewControllers:controllers title:title];
    }
    [preferencesWindowController showWindow:nil];
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
    
    [self resetUrls];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CLEAR_CACHE object:self];
}

-(void)resetUrls
{
    popularViewController.requestUrl = [VPInfo retrievePopularUrl];
    feedsViewController.requestUrl = [VPInfo retrieveSelfTimelineUrl];
    favoritesViewController.requestUrl = [VPInfo retrieveFavoritesUrl];
}

-(void)hideAllViews
{
    [popularViewController.view setHidden:YES];
    [favoritesViewController.view setHidden:YES];
    [feedsViewController.view setHidden:YES];
}

- (IBAction)showTimeline:(id)sender {
    [self hideAllViews];
    [self showFeedsView];
}

- (IBAction)showPopular:(id)sender {
    [self hideAllViews];
    [self showPopularView];
}

- (IBAction)showFavorites:(id)sender {
    [self hideAllViews];
    [self showFavoritesView];
}

- (void) showPopularView
{
    if (popularViewController){
        [popularViewController.view setHidden:NO];
    } else {
        popularViewController = [[VPFeedsViewController alloc] initWithNibName:@"VPFeedsViewController" identifier:@"popular" bundle:nil];
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
        
        [popularViewController prepare];
        popularViewController.requestUrl = [VPInfo retrievePopularUrl];
        popularViewController.loginDelegate = self;
        [popularViewController startRequest];
    }
}

- (void) showFeedsView
{
    if (feedsViewController) {
        [feedsViewController.view  setHidden:NO];
    } else {
        feedsViewController = [[VPFeedsViewController alloc] initWithNibName:@"VPFeedsViewController"
                                                                  identifier:@"self"
                                                                      bundle:nil];
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
        
        [feedsViewController prepare];
        feedsViewController.requestUrl = [VPInfo retrieveSelfTimelineUrl];
        feedsViewController.loginDelegate = self;
        [feedsViewController startRequest];
    }
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
    if (favoritesViewController) {
        [favoritesViewController.view setHidden:NO];
    } else {
        favoritesViewController = [[VPFeedsViewController alloc] initWithNibName:@"VPFeedsViewController"
                                                                      identifier:@"favorites"
                                                                          bundle:nil];
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
        
        [favoritesViewController prepare];
        favoritesViewController.requestUrl = [VPInfo retrieveFavoritesUrl];
        favoritesViewController.loginDelegate = self;
        [favoritesViewController startRequest];
    }
}

-(void)loginDidFail
{
    NSAlert *alert = [[NSAlert alloc]init];
    NSButton *authorize = [alert addButtonWithTitle:@"Authorize"];
    authorize.tag = NSModalResponseOK;
    
    NSButton *cancel = [alert addButtonWithTitle:@"Cancel"];
    [alert setAlertStyle:NSWarningAlertStyle];
    cancel.tag = NSModalResponseCancel;
    
    [alert beginSheetModalForWindow:[self window] completionHandler:^(NSModalResponse res) {
        if (res == NSModalResponseOK) {
            [self hideAllViews];
            [self showLoginView];
        }
    }];
    
}
@end
