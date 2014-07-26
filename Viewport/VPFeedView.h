//
//  VPFeedView.h
//  Viewport
//
//  Created by 吴旭东 on 14-7-5.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPFeedView : NSTableCellView

@property (retain, nonatomic) IBOutlet NSButton *pic;
@property (retain, nonatomic) IBOutlet NSButton *userProfile;
@property (retain, nonatomic) IBOutlet NSTextField *caption;
@property (retain, nonatomic) IBOutlet NSView *container;

@end
