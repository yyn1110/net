//
//  KXHttpResponse.h
//  HttpExample
//
//  Created by yang yue on 14-2-11.
//  Copyright (c) 2014年 zhangpeihao. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString * const HTTPTokenInvalidNotification;

@interface KXHttpResponse : NSObject
@property (nonatomic,assign) NSInteger           ret;
@property (nonatomic, copy) NSString      *msg;
@property (nonatomic, strong) NSObject  *data;
@property (nonatomic, strong) NSObject  *get;
@property (nonatomic,strong) NSDictionary *filesDic;
@property (nonatomic,strong) NSDictionary *fieldsDic;
@property (nonatomic,strong) NSDictionary *userInfo;
@property (nonatomic,strong) NSDictionary *requestInfo;
@end
