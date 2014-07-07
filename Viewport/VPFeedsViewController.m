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
}
@end

@implementation VPFeedsViewController

@synthesize requestUrl;

-(void)awakeFromNib
{
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.scrollView.refreshBlock = ^(EQSTRScrollView *scrollView){
        [self startRequest];
    };
}

-(void)updateData:(NSData*) jsonData
{
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSArray *rawFeeds = [data objectForKey:@"data"];
    
    NSMutableArray *feeds = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in rawFeeds){
        [feeds addObject: [[VPFeed alloc] initWithDictionray:dic]];
    }
    
    array = feeds;
    
    NSNib *nib = [[NSNib alloc] initWithNibNamed:@"VPFeedView" bundle:nil];
    [self.tableview registerNib:nib forIdentifier:@"CELL"];
    [self.tableview reloadData];
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
    }
    
    [[[AsyncImageDownloader alloc] initWithMediaURL:feed.images.standardResolution.url successBlock:^(NSImage *image) {
        [view.pic setImage:image];
    } failBlock:^(NSError *error) {
        [view.pic setImage:nil];
        NSLog(@"error: %@", error);
    }] startDownload];
    
    CALayer *profileLayer = [CALayer layer];
    profileLayer.cornerRadius = 3;
    profileLayer.masksToBounds = YES;
    view.userProfile.wantsLayer = YES;
    view.userProfile.layer = profileLayer;
    
    [[[AsyncImageDownloader alloc] initWithMediaURL:feed.user.profilePicture successBlock:^(NSImage *profile) {
        [view.userProfile setImage:profile];
    } failBlock:^(NSError *error) {
        [view.pic setImage:nil];
        NSLog(@"error: %@", error);
    }] startDownload];
    
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

-(CGFloat) tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 373;
}

-(BOOL) tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    return NO;
}

-(void)startRequest
{
    NSURLRequest *request = [NSURLRequest requestWithURL:self.requestUrl];
    NSURLConnection *con =
    [[NSURLConnection alloc] initWithRequest:request
                                    delegate:[[VPConnectionDataDepot alloc]
                                              initWithSuccessBlock:^(NSData *data){
                                                  [self.scrollView stopLoading];
                                                  [self updateData:data];
                                              } failBlock:^(NSError *error){
                                                  [self.scrollView stopLoading];
                                              }]
                            startImmediately:NO];
    
    [con start];

}

@end
