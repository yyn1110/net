//
//  KXHttpManager.h
//  HttpExample
//
//  Created by yang yue on 14-2-11.
//  Copyright (c) 2014年 zhangpeihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KXHttpRequest.h"
#import "KXHTTPAPI.h"

#import "LWPropressHUD.h"
#import "KXLogManager.h"
#import "ASINetworkQueue.h"
@interface KXHttpManager : NSObject<ASIProgressDelegate>

@property (nonatomic,assign) BOOL openHttpDebug;
@property (nonatomic,strong) NSMutableArray *httpDebugArray;


- (NSString * )getHttpInfo;



+ (KXHttpManager*)sharedKXHttpManager;
- (void)cancelRequest:(Class)cla;

- (void)requestHTTP:(NSString*)url
         withSender:(id)sender
            withSel:(SEL)aSelect
          andFields:(NSDictionary*)fields
           andFiles:(NSDictionary*)files
	 withUserInfo:(NSDictionary *)userInfo;

- (void)requestHTTP:(NSString*)url
         withSender:(id)sender
            withSel:(SEL)aSelect
		withTimeOut:(int)timeOut
          andFields:(NSDictionary*)fields
           andFiles:(NSDictionary*)files
	 withUserInfo:(NSDictionary *)userInfo;

#if NS_BLOCKS_AVAILABLE
- (void)requestHTTP:(NSString*)url
         withSender:(id)sender
            withSel:(SEL)aSelect
          andFields:(NSDictionary*)fields
           andFiles:(NSDictionary*)files
andBytesReceivedBlock:(ASIProgressBlock)aBytesReceivedBlock
  andBytesSentBlock:(ASIProgressBlock)aBytesSentBlock
 andCompletionBlock:(ASIBasicBlock)aCompletionBlock
      andStartBlock:(ASIBasicBlock)aStartedBlock
	 withUserInfo:(NSDictionary *)userInfo;

- (void)requestHTTP:(NSString*)url
         withSender:(id)sender
            withSel:(SEL)aSelect
          andFields:(NSDictionary*)fields
           andFiles:(NSDictionary*)files
		withTimeOut:(int)timeout
andBytesReceivedBlock:(ASIProgressBlock)aBytesReceivedBlock
  andBytesSentBlock:(ASIProgressBlock)aBytesSentBlock
 andCompletionBlock:(ASIBasicBlock)aCompletionBlock
      andStartBlock:(ASIBasicBlock)aStartedBlock
	 withUserInfo:(NSDictionary *)userInfo;
#endif

@end
