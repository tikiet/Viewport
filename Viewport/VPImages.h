//
//  VPImages.h
//  Viewport
//
//  Created by 吴旭东 on 14-7-2.
//  Copyright (c) 2014年 xudongwu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPImage.h"

@interface VPImages : NSObject

@property VPImage *thumbnail;
@property VPImage *lowResolution;
@property VPImage *standardResolution;

-(id) initWithStandardResolution:(VPImage*)standard lowResolution:(VPImage*)low thumbnail:(VPImage*)thumbnail;
-(id) initWithDictionray:(NSDictionary*)dictionary;

@end
