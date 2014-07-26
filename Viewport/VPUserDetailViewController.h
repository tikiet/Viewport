//
//  VPUserDetailViewController.h
//  Viewport
//
//  Created by 吴旭东 on 7/25/14.
//  Copyright (c) 2014 xudongwu.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "VPUser.h"

@interface VPUserDetailViewController : NSViewController

@property (strong) VPUser *user;

@property (weak) IBOutlet NSTextField *posts;
@property (weak) IBOutlet NSTextField *followers;
@property (weak) IBOutlet NSTextField *following;

-(void)prepare;
-(void)show;

@end
