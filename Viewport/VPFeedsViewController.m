//
//  VPFeedsViewController.m
//  Viewport
//
//  Created by 吴旭东 on 14-7-6.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import "VPFeedsViewController.h"

#define DEBUG_MODE NO

@interface VPFeedsViewController ()
{
    NSArray *array;
    BOOL hasMore;
    BOOL triggeredBottom;
    NSString *identifier;
    NSString *nextMaxId;
}
@end

@implementation VPFeedsViewController

@synthesize loginDelegate, accumulateData;

-(void)awakeFromNib
{
    self.scrollView.refreshableSides = BSRefreshableScrollViewSideTop;
    self.scrollView.refreshableDelegate = self;
}

-(BOOL)scrollView:(BSRefreshableScrollView *)aScrollView startRefreshSide:(BSRefreshableScrollViewSide)refreshableSide
{
    return [self startRequestWithNextMaxId:NO];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithNibName:nibNameOrNil identifier:@"default" bundle:nibBundleOrNil];
}

-(id)initWithNibName:(NSString *)nibNameOrNil identifier:(NSString *)idt bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        identifier = idt;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearCache)
                                                     name:NOTIFICATION_CLEAR_CACHE
                                                   object:nil];
    }
    return self;
}

-(void)clearCache
{
    NSLog(@"received notification for view controller with identifier %@", identifier);
    hasMore = YES;
    array = nil;
    triggeredBottom = NO;
    
    [self.tableview reloadData];
    [self startRequestWithNextMaxId:NO];
}

-(void)prepare
{
    hasMore = YES;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    
    NSNib *nib = [[NSNib alloc] initWithNibNamed:@"VPFeedView" bundle:nil];
    [self.tableview registerNib:nib forIdentifier:@"CELL"];
    
    id clipView = [[self.tableview enclosingScrollView] contentView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myBoundsChangeNotificationHandler:)
                                                 name:NSViewBoundsDidChangeNotification
                                               object:clipView];
}

- (void)myBoundsChangeNotificationHandler:(NSNotification *)aNotification
{
    if ([aNotification object] == [[self.tableview enclosingScrollView] contentView]){
        if ( NSMaxY([self.tableview enclosingScrollView].documentVisibleRect) >=
            NSHeight([[self.tableview enclosingScrollView].documentView bounds]) ){
            if (!triggeredBottom && accumulateData) {
                triggeredBottom = YES;
                [self startRequestWithNextMaxId:YES];
            }
        }
    }
}

-(void)updateData:(NSData*) jsonData
{
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSDictionary *meta = [data objectForKey:@"meta"];
    NSLog(@"meta:%@", meta);
    int code =  [[meta objectForKey:@"code"]intValue];
    if (code == 400) {
        [self reportLoginError];
        return;
    }
    
    NSArray *rawFeeds = [data objectForKey:@"data"];
    if (DEBUG_MODE) {
        NSLog(@"raw: %@", rawFeeds);
    }
    
    NSMutableSet *feeds = [[NSMutableSet alloc] init];
    for (NSDictionary *dic in rawFeeds){
        [feeds addObject: [[VPFeed alloc] initWithDictionray:dic]];
    }
    
    if (accumulateData) {
        [feeds addObjectsFromArray:array];
    }
    
    array = [[feeds allObjects] sortedArrayUsingComparator:^NSComparisonResult(id a, id b){
        VPFeed *fa = (VPFeed*)a;
        VPFeed *fb = (VPFeed*)b;
        int r = fa.createdTime - fb.createdTime;
        if (r > 0){
            return NSOrderedAscending;
        } else if (r == 0){
            return NSOrderedSame;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    triggeredBottom = NO;
    [self.tableview reloadData];
    
    NSDictionary *pagination = [data objectForKey:@"pagination"];
    if (hasMore) {
        if (pagination && !([pagination isEqual: [NSNull null]])){
            NSString *maxId = [pagination objectForKey:@"next_max_id"];
            if (maxId && !([maxId isEqual:[NSNull null]])) {
                hasMore = YES;
                if (!nextMaxId || [maxId longLongValue] < [nextMaxId longLongValue]) {
                    nextMaxId = maxId;
                }
            } else {
                hasMore = NO;
            }
        } else {
            hasMore = NO;
        }
    }
}

-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    return array.count;
}

-(NSView *) tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    VPFeedView *view = [tableView makeViewWithIdentifier:@"CELL" owner:self];
    VPFeed *feed = [array objectAtIndex:row];
    
    if (feed.caption.text) {
        [view.caption setStringValue:feed.caption.text];
    } else {
        [view.caption setStringValue:@""];
    }
    
    [[[TKImageLoader alloc] initWithURL:[NSURL URLWithString:feed.images.standardResolution.url]
                              imageView:view.pic] start];
    
    CALayer *profileLayer = [CALayer layer];
    profileLayer.cornerRadius = 3;
    profileLayer.masksToBounds = YES;
    view.userProfile.wantsLayer = YES;
    view.userProfile.layer = profileLayer;
    
    [[[TKImageLoader alloc] initWithURL:[NSURL URLWithString:feed.user.profilePicture]
                              imageView:view.userProfile] start];
    
    CALayer *viewLayer = [CALayer layer];
    [viewLayer setBackgroundColor:CGColorCreateGenericRGB(0.835, 0.835, 0.835, 1)];
    [view setWantsLayer:YES];
    [view setLayer:viewLayer];
    
    CALayer *containerLayer = [CALayer layer];
    containerLayer.backgroundColor = CGColorCreateGenericRGB(1, 1, 1, 1);
    containerLayer.masksToBounds = YES;
    containerLayer.cornerRadius = 3;
    containerLayer.borderColor = CGColorCreateGenericRGB(0.75, 0.75, 0.75, 1);
    containerLayer.borderWidth = 1;
    
    [view.container setWantsLayer:YES];
    [view.container setLayer:containerLayer];
    
    
    view.pic.target = self;
    view.pic.action = @selector(viewPicDidSelect:);
    
    view.userProfile.target = self;
    view.userProfile.action = @selector(userProfileDidSelect:);
    return view;
}

-(IBAction)userProfileDidSelect:(id)sender
{
    if (self.modelDelegate){
        VPFeed *comment = array[[self.tableview rowForView:sender]];
        [self.modelDelegate modelDidSelect:comment.user];
    }
}

-(IBAction) viewPicDidSelect:(id)sender
{
    if (self.modelDelegate){
        VPFeed *comment = array[[self.tableview rowForView:sender]];
        [self.modelDelegate modelDidSelect:comment];
    }
}

-(BOOL) tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    return NO;
}

-(BOOL)startRequestWithNextMaxId:(BOOL) useNextId
{
    if (hasMore || !accumulateData) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[VPInfo retrieveUrlWithIdentifier:identifier
                                                                                     nextMaxId:useNextId ? nextMaxId : nil]];
        NSURLConnection *con =
        [[NSURLConnection alloc] initWithRequest:request
                                        delegate:[[VPConnectionDataDepot alloc]
                                                  initWithSuccessBlock:^(NSData *data){
                                                      [self updateData:data];
                                                      [self.scrollView stopRefreshingSide:BSRefreshableScrollViewSideTop];
                                                  } failBlock:^(NSError *error){
                                                      NSLog(@"error:%@", error);
                                                      [self.scrollView stopRefreshingSide:BSRefreshableScrollViewSideTop];
                                                  }]];
        [con start];
        return true;
    }
    return false;
}

-(void)reportLoginError
{
    if(self.loginDelegate){
        [self.loginDelegate loginDidFail];
    }
}
@end
