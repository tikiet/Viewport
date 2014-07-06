//
//  VPLoginViewController.h
//  Viewport
//
//  Created by 吴旭东 on 14-7-6.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "VPURLParser.h"

@protocol VPLoginViewDelegate

-(void) loginSucceededWithAccessToken:(NSString*)token;
-(void) loginFaildWithError:(NSString *)error reason:(NSString*)reason description:(NSString*)description;

@end

@interface VPLoginViewController : NSViewController

@property (retain) id <VPLoginViewDelegate> delegate;
@property (strong) IBOutlet WebView *webview;

-(void)loadLoginPage;
-(void)stop;

@end
