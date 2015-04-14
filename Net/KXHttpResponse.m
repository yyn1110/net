//
//  KXHttpResponse.m
//  HttpExample
//
//  Created by yang yue on 14-2-11.
//  Copyright (c) 2014年 zhangpeihao. All rights reserved.
//

#import "KXHttpResponse.h"
NSString * const HTTPTokenInvalidNotification= @"HTTPTokenInvalid";
@implementation KXHttpResponse
- (id)init
{
    self = [super init];
    if (self) {
	self.msg = @"";
    }
    return self;
}
@end
