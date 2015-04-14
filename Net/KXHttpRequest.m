//
//  KXHttpRequest.m
//  HttpExample
//
//  Created by yang yue on 14-2-11.
//  Copyright (c) 2014年 zhangpeihao. All rights reserved.
//

#import "KXHttpRequest.h"
@interface KXHttpRequest()
@property (nonatomic, assign) SEL selector;
@end

@implementation KXHttpRequest
- (id)initWithURL:(NSString*)aurl
        andSender:(id)asender
           andSel:(SEL)aselector;
{
    self = [super initWithURL:[NSURL URLWithString:aurl]];
    if (self) {
        self.sender = asender;
        self.selector = aselector;
		self.responseEncoding = NSUTF8StringEncoding;
//        self.showAccurateProgress = TRUE;
    }
    return self;
}
- (void)processResponse:(KXHttpResponse*)response
{
    if (self.sender && [self.sender respondsToSelector:self.selector]) {
        [self.sender performSelectorOnMainThread:self.selector withObject:response waitUntilDone:TRUE];
    }
}
@end
