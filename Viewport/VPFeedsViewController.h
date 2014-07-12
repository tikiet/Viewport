//
//  VPFeedsViewController.h
//  Viewport
//
//  Created by 吴旭东 on 14-7-6.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "VPFeedView.h"
#import "VPFeed.h"
#import "VPInfo.h"
#import "VPConnectionDataDepot.h"
#import "EQSTRScrollView.h"
#import <AsyncImageDownloader.h>

@interface VPFeedsViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *tableview;
@property (weak) IBOutlet EQSTRScrollView *scrollView;
@property NSURL *requestUrl;

-(void)updateData:(NSData*)jsonData;
-(void)startRequest;
-(void)archiveData;
-(id)initWithNibName:(NSString *)nibNameOrNil identifier:(NSString*) identifier bundle:(NSBundle *)nibBundleOrNil;
@end
