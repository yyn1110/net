//
//  KXHttpRequest.h
//  HttpExample
//
//  Created by yang yue on 14-2-11.
//  Copyright (c) 2014年 zhangpeihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "KXHttpResponse.h"

typedef enum {
	RetTypeSystemError = 0,
	RetTypeOK = 1,
	RetTypeTipUser = -1,
	RetTypeTokenInvlide = -2,
	RetTypeInterFaceError = -3,
}RetType;
@interface KXHttpRequest : ASIFormDataRequest
@property (nonatomic, weak) id sender;
@property (nonatomic, strong) NSDictionary *fieldsDic;
@property (nonatomic, strong) NSDictionary *fileDic;

- (id)initWithURL:(NSString*)aurl
           andSender:(id)asender
              andSel:(SEL)aselector;
- (void)processResponse:(KXHttpResponse*)response;
@end
