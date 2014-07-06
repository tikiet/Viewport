//
//  VPConnectionDataDepot.m
//  Viewport
//
//  Created by 吴旭东 on 14-7-6.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import "VPConnectionDataDepot.h"

@implementation VPConnectionDataDepot
{
    void (^successBlock)(NSData *);
    void (^failBlock)(NSError *);
    NSMutableData *jsonData;
}

-(id)initWithSuccessBlock:(void (^)(NSData *))sb failBlock:(void (^)(NSError *))fb
{
    self= [super init];
    if (self) {
        jsonData = [[NSMutableData alloc] init];
        successBlock = sb;
        failBlock = fb;
    }
    return self;
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [jsonData appendData: data];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    successBlock(jsonData);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    failBlock(error);
}
@end
