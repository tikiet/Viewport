//
//  VPLoginViewController.m
//  Viewport
//
//  Created by 吴旭东 on 14-7-6.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import "VPLoginViewController.h"

@interface VPLoginViewController ()

@end

NSString* kAccessToken = @"access_token=";

@implementation VPLoginViewController

@synthesize delegate;

-(void)awakeFromNib
{
    self.webview.frameLoadDelegate = self;
}

-(void)webView:(WebView *)sender didReceiveServerRedirectForProvisionalLoadForFrame:(WebFrame *)frame
{
    NSString *redirect_uri = @"https://wuxudong.wordpress.com/viewport";
    NSURL *url = frame.provisionalDataSource.request.URL;
    if ([url.absoluteString hasPrefix:redirect_uri]) {
        NSString *fragment = url.fragment;
        if (fragment && [fragment hasPrefix:kAccessToken]){
            NSString *token = [fragment substringFromIndex:[kAccessToken length]];
            if (delegate) {
                [self.delegate loginSucceededWithAccessToken:token];
            }
        } else {
            VPURLParser *parser = [[VPURLParser alloc] initWithString:fragment];
            if (delegate){
                [self.delegate loginFailedWithError:[parser parameterForKey:@"error"]
                                            reason:[parser parameterForKey:@"error_reason"]
                                       description:[parser parameterForKey:@"error_description"]];
            }
        }
    }
}

-(void)loadLoginPage
{
    NSString *redirect_uri = @"https://wuxudong.wordpress.com/viewport";
    NSString *clientId = @"cef2651b8eb54e1b8b4c16dbe9ec0317";
    NSString *url = @"https://instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token";
    NSString *loginUrl = [NSString stringWithFormat:url, clientId, redirect_uri];
    [[self.webview mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loginUrl]]];
}

-(void)stop
{
    [[self.webview mainFrame]stopLoading];
}
@end
