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
#import "TKImageLoader.h"
#import "BSRefreshableScrollView.h"

@protocol VPLoginDelegate <NSObject>

-(void)loginDidFail;

@end

@interface VPFeedsViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, BSRefreshableScrollViewDelegate>

@property (weak) IBOutlet NSTableView *tableview;
@property (weak) IBOutlet BSRefreshableScrollView *scrollView;
@property  NSObject<VPLoginDelegate> *loginDelegate;
@property BOOL accumulateData;

-(void)updateData:(NSData*)jsonData;
-(BOOL)startRequestWithNextMaxId:(BOOL)useNextMaxId;
-(void)prepare;
-(id)initWithNibName:(NSString *)nibNameOrNil identifier:(NSString*) identifier bundle:(NSBundle *)nibBundleOrNil;
@end
