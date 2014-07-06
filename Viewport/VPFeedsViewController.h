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
#import <AsyncImageDownloader.h>

@interface VPFeedsViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *tableview;

-(void)updateData:(NSData*)jsonData;

@end
