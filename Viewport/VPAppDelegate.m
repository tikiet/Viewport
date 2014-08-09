#import "VPAppDelegate.h"
#import "VPConnectionDataDepot.h"
#import "VPFeedDetailViewController.h"
#import "VPUserDetailViewController.h"
#import "VPSearchViewController.h"

@implementation VPAppDelegate
{
    VPLoginViewController *loginViewController;
    VPFeedsViewController *feedsViewController;
    VPFeedsViewController *popularViewController;
    VPFeedsViewController *favoritesViewController;
    MASPreferencesWindowController *preferencesWindowController;
    TKNavigationController *navController;
    VPSearchViewController *searchController;
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
    navController = [[TKNavigationController alloc] initWithNibName:@"TKNavigationController" bundle:nil];
    [self.contentArea addSubview:navController.view];
    
    NSView *parent = self.contentArea;
    [parent addSubview: loginViewController.view];
    
    NSView *view = navController.view;
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
    
    if ([VPInfo accessToken]) {
        [self showFeedsView];
    } else {
        [self showLoginView];
    }
}

-(void)loginFailedWithError:(NSString *)error reason:(NSString *)reason description:(NSString *)description
{
    [self.navigationArea setHidden:NO];
    [self.contentArea setHidden:NO];
    
    NSLog(@"login failed:%@", error);
    [loginViewController stop];
    [loginViewController.view removeFromSuperview];
    loginViewController = nil;
}

-(void)loginSucceededWithAccessToken:(NSString *)token
{
    [self.navigationArea setHidden:NO];
    [self.contentArea setHidden:NO];
    
    [VPInfo setAccessToken:token];
    [loginViewController stop];
    [loginViewController.view removeFromSuperview];
    loginViewController = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CLEAR_CACHE object:self];
    [self showFeedsView];
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

- (IBAction)showSearch:(id)sender {
    [self showSearch];
}

- (void) showSearch
{
    if (searchController) {
        [navController moveToTop:searchController];
    } else {
        searchController = [[VPSearchViewController alloc] initWithNibName:@"VPSearchViewController"
                                                                    bundle:nil];
        searchController.view.wantsLayer = YES;
        searchController.view.layer.backgroundColor = CGColorCreateGenericRGB(0.84, 0.84, 0.84, 1);
        searchController.delegate = self;
        [navController addViewController:searchController retain:YES];
    }
}

- (void) showPopularView
{
    if (popularViewController){
        [navController moveToTop:popularViewController];
    } else {
        popularViewController = [[VPFeedsViewController alloc] initWithNibName:@"VPFeedsViewController"
                                                                    identifier:ID_POPULAR
                                                                        bundle:nil];
        [navController addViewController:popularViewController retain:YES];
        
        [popularViewController prepare];
        popularViewController.loginDelegate = self;
        popularViewController.accumulateData = NO;
        popularViewController.modelDelegate = self;
        [popularViewController startRequestWithNextMaxId:NO];
    }
}

- (void) showFeedsView
{
    
    if (feedsViewController) {
        [navController moveToTop:feedsViewController];
    } else {
        feedsViewController = [[VPFeedsViewController alloc] initWithNibName:@"VPFeedsViewController"
                                                                  identifier:ID_SELF
                                                                      bundle:nil];
        [navController addViewController:feedsViewController retain:YES];
        [feedsViewController prepare];
        feedsViewController.loginDelegate = self;
        feedsViewController.accumulateData = YES;
        feedsViewController.modelDelegate = self;
        [feedsViewController startRequestWithNextMaxId:NO];
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
    
    [self.navigationArea setHidden:YES];
    [self.contentArea setHidden:YES];
}

-(void) showFavoritesView
{
    
    if (favoritesViewController) {
        [navController moveToTop:favoritesViewController];
    } else {
        favoritesViewController = [[VPFeedsViewController alloc] initWithNibName:@"VPFeedsViewController"
                                                                      identifier:ID_FAVORITES
                                                                          bundle:nil];
        [navController addViewController:favoritesViewController retain:YES];
        [favoritesViewController prepare];
        favoritesViewController.loginDelegate = self;
        favoritesViewController.accumulateData = YES;
        favoritesViewController.modelDelegate = self;
        [favoritesViewController startRequestWithNextMaxId:NO];
    }
}

-(void)loginDidFail
{
    NSAlert *alert = [[NSAlert alloc]init];
    [alert setMessageText:@"Your authorization is expired. Need to authorize again."];
    NSButton *authorize = [alert addButtonWithTitle:@"Authorize"];
    authorize.tag = NSModalResponseOK;
    
    NSButton *cancel = [alert addButtonWithTitle:@"Cancel"];
    [alert setAlertStyle:NSWarningAlertStyle];
    cancel.tag = NSModalResponseCancel;
    
    [alert beginSheetModalForWindow:[self window] completionHandler:^(NSModalResponse res) {
        if (res == NSModalResponseOK) {
            //TODO: [self hideAllViews];
            [self showLoginView];
        }
    }];
    
}

-(void)modelDidSelect:(id)model
{
    if ([model isKindOfClass:[VPFeed class]]) {
        VPFeedDetailViewController *controller = [[VPFeedDetailViewController alloc]
                                                  initWithNibName:@"VPFeedDetailViewController"
                                                  bundle:nil];
        controller.feed = (VPFeed*)model;
        controller.modelDelegate = self;
        [navController addViewController:controller retain:NO];
        [controller prepare];
    } else if ([model isKindOfClass:[VPUser class]]) {
        VPUserDetailViewController *controller = [[VPUserDetailViewController alloc]
                                                  initWithNibName:@"VPUserDetailViewController"
                                                  bundle:nil];
        controller.user = (VPUser*)model;
        controller.modelDelegate = self;
        [navController addViewController:controller retain:NO];
        [controller prepare];
    }
}

- (IBAction)back:(id)sender {
    [navController pop];
}

- (IBAction)debug:(id)sender {
    NSLog(@"view controllers:%@", navController.viewControllers);
    NSLog(@"subviews:%@", navController.view.subviews);
}

@end
