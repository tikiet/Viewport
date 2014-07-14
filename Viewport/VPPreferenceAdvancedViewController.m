//
//  VPPreferenceAdvancedViewController.m
//  Viewport
//
//  Created by 吴旭东 on 14-7-14.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import "VPPreferenceAdvancedViewController.h"

@interface VPPreferenceAdvancedViewController ()

@end

@implementation VPPreferenceAdvancedViewController

- (id)init
{
    return [super initWithNibName:@"VPPreferenceAdvancedViewController" bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (NSString*)identifier
{
    return @"Advanced";
}

- (NSImage*)toolbarItemImage
{
    return [NSImage imageNamed: NSImageNameAdvanced];
}

- (NSString*)toolbarItemLabel
{
    return @"Advanced";
}
@end
