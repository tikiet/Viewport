//
//  VPUserDetailViewController.h
//  Viewport
//
//  Created by 吴旭东 on 7/25/14.
//  Copyright (c) 2014 xudongwu.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "VPUser.h"

@interface VPUserDetailViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (strong) VPUser *user;

@property (weak) IBOutlet NSTextField *posts;
@property (weak) IBOutlet NSTextField *followers;
@property (weak) IBOutlet NSTextField *following;

@property (weak) IBOutlet NSTextField *userName;
@property (weak) IBOutlet NSTextField *bio;
@property (weak) IBOutlet NSImageView *profile;

@property (weak) IBOutlet NSTableView *tableView;
-(void)prepare;
-(void)show;

@end
