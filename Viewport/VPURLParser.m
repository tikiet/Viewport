//
//  VPURLParser.m
//  Viewport
//
//  Created by 吴旭东 on 14-7-6.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import "VPURLParser.h"

@implementation VPURLParser
{
    NSMutableDictionary *dictionary;
}

-(id)initWithString:(NSString *)string
{
    self = [super init];
    if (self) {
        dictionary = [[NSMutableDictionary alloc]init];
        NSArray *pairs = [string componentsSeparatedByString:@"&"];
        for (NSString *pair in pairs){
            NSArray *keyvalue = [pair componentsSeparatedByString:@"="];
            [dictionary setValue:keyvalue[1] forKey:keyvalue[0]];
        }
    }
    return self;
}

-(id)initWithURL:(NSURL *)url
{
    return [self initWithString:url.absoluteString];
}

-(NSString*) parameterForKey:(NSString *)key
{
    return [dictionary objectForKey:key];
}
@end
