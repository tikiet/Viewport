//
//  TKNavigationController.h
//  Viewport
//
//  Created by 吴旭东 on 7/20/14.
//  Copyright (c) 2014 xudongwu.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface TKNavigationController : NSViewController

@property NSMutableArray *viewControllers;

-(void)addViewController:(NSViewController*) viewController;

@end
