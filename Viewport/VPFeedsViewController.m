//
//  VPFeedsViewController.m
//  Viewport
//
//  Created by 吴旭东 on 14-7-6.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import "VPFeedsViewController.h"

@interface VPFeedsViewController ()
{
    NSArray *array;
    BOOL hasMore;
    BOOL triggeredBottom;
    NSString *identifier;
}
@end

@implementation VPFeedsViewController

@synthesize requestUrl;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithNibName:nibNameOrNil identifier:@"default" bundle:nibBundleOrNil];
}

-(id)initWithNibName:(NSString *)nibNameOrNil identifier:(NSString *)idt bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        identifier = idt;
    }
    return self;
}

-(void)archiveData
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:identifier];
}

-(void)prepare
{
    hasMore = YES;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.scrollView.refreshBlock = ^(EQSTRScrollView *scrollView){
        [self startRequest];
    };
    
    NSNib *nib = [[NSNib alloc] initWithNibNamed:@"VPFeedView" bundle:nil];
    [self.tableview registerNib:nib forIdentifier:@"CELL"];
    
    id clipView = [[self.tableview enclosingScrollView] contentView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myBoundsChangeNotificationHandler:)
                                                 name:NSViewBoundsDidChangeNotification
                                               object:clipView];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:identifier];
    if (data && ![data isEqualTo:[NSNull null]]) {
        NSArray *archivedArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        array = archivedArray;
        [self.tableview reloadData];
    }
}

- (void)myBoundsChangeNotificationHandler:(NSNotification *)aNotification
{
    if ([aNotification object] == [[self.tableview enclosingScrollView] contentView]){
        if ( NSMaxY([self.tableview enclosingScrollView].documentVisibleRect) >=
            NSHeight([[self.tableview enclosingScrollView].documentView bounds]) ){
            if (!triggeredBottom) {
                triggeredBottom = YES;
                [self startRequest];
            }
        }
    }
}

-(void)updateData:(NSData*) jsonData
{
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSArray *rawFeeds = [data objectForKey:@"data"];
    
    NSMutableSet *feeds = [[NSMutableSet alloc] init];
    for (NSDictionary *dic in rawFeeds){
        [feeds addObject: [[VPFeed alloc] initWithDictionray:dic]];
    }
    [feeds addObjectsFromArray:array];
    
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
    
    [self.tableview reloadData];
    
    NSDictionary *pagination = [data objectForKey:@"pagination"];
    
    if (pagination && !([pagination isEqual: [NSNull null]])){
        NSString *next_url = [pagination objectForKey:@"next_url"];
        if (next_url && !([next_url isEqual:[NSNull null]])) {
            requestUrl = [NSURL URLWithString:next_url];
            hasMore = YES;
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
    view.translatesAutoresizingMaskIntoConstraints = NO;
    VPFeed *feed = [array objectAtIndex:row];
    
    if (feed.caption.text) {
        [view.caption setStringValue:feed.caption.text];
    } else {
        [view.caption setStringValue:@""];
    }
    
    [view.pic setImage:nil];
    [[[TKImageLoader alloc] initWithURL:[NSURL URLWithString:feed.images.standardResolution.url] imageView:view.pic] start];
    
    CALayer *profileLayer = [CALayer layer];
    profileLayer.cornerRadius = 3;
    profileLayer.masksToBounds = YES;
    view.userProfile.wantsLayer = YES;
    view.userProfile.layer = profileLayer;
    
    [view.userProfile setImage:nil];
    [[[TKImageLoader alloc] initWithURL:[NSURL URLWithString:feed.user.profilePicture] imageView:view.userProfile] start];
    
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

    return view;
}

-(BOOL) tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    return NO;
}

-(void)startRequest
{
    if (hasMore) {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.requestUrl];
        NSURLConnection *con =
        [[NSURLConnection alloc] initWithRequest:request
                                        delegate:[[VPConnectionDataDepot alloc]
                                                  initWithSuccessBlock:^(NSData *data){
                                                      [self.scrollView stopLoading];
                                                      [self updateData:data];
                                                      triggeredBottom = NO;
                                                  } failBlock:^(NSError *error){
                                                      NSLog(@"error:%@", error);
                                                      [self.scrollView stopLoading];
                                                  }]
                                startImmediately:NO];
        
        [con start];
    }
}

@end
