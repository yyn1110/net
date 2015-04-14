//
//  KXHttpManager.m
//  HttpExample
//
//  Created by yang yue on 14-2-11.
//  Copyright (c) 2014年 zhangpeihao. All rights reserved.
//

#import "KXHttpManager.h"

#import "KXHttpRequest.h"
#import "KXHttpResponse.h"
#import "KXObject+Utils.h"

#define MaxRequestTime 10

#define FORMAT_ERROR_MESSAGE @"数据格式错误"
#define NETWORK_ERROR_MESSAGE @"网络错误"

@interface KXHttpManager ()
{
    KXHttpResponse *_formatErrorResponse;
    KXHttpResponse *_networkErrorResponse;
	int requestSuccessCount ;
	int requestErrorCount ;
	int requestTotalCount ;
	
	
}

@property (nonatomic, strong) LWPropressHUD *propressHUD;
@property (nonatomic, strong) ASINetworkQueue *networkQueue;
@end

@implementation KXHttpManager
- (NSString * )getHttpInfo
{
	NSMutableString *string = [NSMutableString string];
	
	int requestCount = self.networkQueue.requestsCount;
	[string appendFormat:@"HTTP当前请求数目 %d\n",requestCount];
	int requestMaxCount =  (int)self.networkQueue.maxConcurrentOperationCount;
	[string appendFormat:@"HTTP最大请求时间 %ds\n",MaxRequestTime];
	
	[string appendFormat:@"HTTP最大请求数目 %d\n",requestMaxCount];
	
	
	
	[string appendFormat:@"HTTP请求成功个数 %d\n",requestSuccessCount];
	[string appendFormat:@"HTTP请求失败个数 %d\n",requestErrorCount];
	
	[string appendFormat:@"HTTP请求总数目 %d\n",requestTotalCount];
	
	[string appendFormat:@"HTTP本次上传流量 %0.4fk\n",self.networkQueue.totalBytesToDownload/1024.0];
	
	[string appendFormat:@"HTTP本次下载流量 %0.4fk\n",self.networkQueue.totalBytesToUpload/1024.0];
	return string;
}
+ (KXHttpManager *)sharedKXHttpManager
{
	static KXHttpManager *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KXHttpManager alloc] init];
    });
    return sharedInstance;
}
- (void)cancelRequest:(Class)cla
{
	
	NSArray *array = self.networkQueue.operations;
	for (KXHttpRequest *req in array) {
		if ([req.sender isKindOfClass:cla]) {
			[req cancel];
			req.sender = nil;
		}
		
	}
	
}

- (id)init
{
    if (self = [super init]) {
		self.propressHUD = [[LWPropressHUD alloc] initWithTargetView:[UIApplication sharedApplication].keyWindow];
		self.httpDebugArray = [NSMutableArray array];
        self.networkQueue = [[ASINetworkQueue alloc] init] ;
        self.networkQueue.shouldCancelAllRequestsOnFailure = NO;
		
        [self.networkQueue setMaxConcurrentOperationCount:8];
        self.networkQueue.delegate = self;
        self.networkQueue.requestDidFinishSelector = @selector(requestDidFinish:);
        self.networkQueue.requestDidFailSelector = @selector(requestDidFailed:);
        self.networkQueue.queueDidFinishSelector = @selector(queueDidFinished:);
        self.networkQueue.showAccurateProgress = TRUE;
        [self.networkQueue go];
        
        _formatErrorResponse = [KXHttpResponse new];
        _formatErrorResponse.ret = -1;
        _formatErrorResponse.msg = FORMAT_ERROR_MESSAGE;
        _formatErrorResponse.data = nil;
        _networkErrorResponse = [KXHttpResponse new];
        _networkErrorResponse.ret = -2;
		
        _networkErrorResponse.data = nil;
    }
    return self;
}
#pragma mark - uploadProgressDelegate

#pragma mark - progress delegate
- (void)setProgress:(float)newProgress
{
    DLogDebug(@"setProgress: %f", newProgress);
}

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    DLogDebug(@"didReceiveBytes: %lld", bytes);
}

- (void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes
{
    DLogDebug(@"didSendBytes: %lld", bytes);
}


- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength
{
    DLogDebug(@"incrementDownloadSizeBy: %lld", newLength);
}


- (void)request:(ASIHTTPRequest *)request incrementUploadSizeBy:(long long)newLength
{
    DLogDebug(@"incrementUploadSizeBy: %lld", newLength);
}

#pragma mark ASINetwork selectors
- (void)requestDidFinish:(KXHttpRequest *)request
{
	requestSuccessCount++;
	requestTotalCount++;
    NSString *responseStr = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
	
	if (self.openHttpDebug) {
		NSString *text = [NSString stringWithFormat:@"httpCode:%d responseStr: %@",request.responseStatusCode,responseStr];
		[[KXLogManager shareLogManager] writeHttpLog:text];
	}
	
	DLogDebug(@"httpCode:  %d  responseStr :%@",request.responseStatusCode,responseStr);
   if (!responseStr) {
        DLogWarn(@"KXHttpManager::requestDidFinish() response string is nil");
		_formatErrorResponse.userInfo = request.userInfo;
        [request processResponse:_formatErrorResponse];
		return;
    }
    NSError *error;
    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        DLogWarn(@"KXHttpManager::requestDidFinish() parse response string error: %@", error);
        DLogWarn(@"responseStr: %@", responseStr);
		_formatErrorResponse.userInfo = request.userInfo;
        [request processResponse:_formatErrorResponse];
		return;
    }
	
	
	
	
	
	
	NSData *data=	[NSJSONSerialization dataWithJSONObject:responseDic options:NSJSONWritingPrettyPrinted error:nil];
	DLogInfo(@" request data url %@ %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],request.url);
    KXHttpResponse *response = [KXHttpResponse new];
	response.fieldsDic = request.fieldsDic;
	response.filesDic = request.fileDic;
	response.userInfo = request.userInfo;
    if (responseDic[@"ret"]) {
        response.ret = [NumberValue(responseDic[@"ret"]) integerValue];
        response.msg = StringValue(responseDic[@"msg"]);
		if (response.ret == RetTypeTokenInvlide) {
			[[NSNotificationCenter defaultCenter] postNotificationName:HTTPTokenInvalidNotification object:response.msg];
		}
		else if (response.ret == RetTypeTipUser){
			[self.propressHUD showWithType:LWPropressHUDOnlyText andTextString:response.msg hiddenAfterDelay:1];
		}
		else{
			response.data = responseDic[@"data"];
			[request processResponse:response];
		}
    } else {
        DLogWarn(@"KXHttpManager::requestDidFinish() response ret is nil");
        DLogWarn(@"responseStr: %@", responseStr);
		_formatErrorResponse.userInfo = request.userInfo;
        [request processResponse:_formatErrorResponse];
    }
}
- (void)requestDidFailed:(KXHttpRequest *)request
{
	
	_networkErrorResponse.fieldsDic = request.fieldsDic;
	_networkErrorResponse.filesDic = request.fileDic;
	_networkErrorResponse.userInfo = request.userInfo;
	_networkErrorResponse.msg = [NSString stringWithFormat:@"%@[%d]",NETWORK_ERROR_MESSAGE,request.responseStatusCode];
	DLogError(@"KXHttpManager::requestDifFailed() request failed! %@ code :%d request.url %@",request.responseString,request.responseStatusCode,request.url);
	[request processResponse:_networkErrorResponse];
	requestErrorCount++;
	requestTotalCount++;
}
- (void)queueDidFinished:(KXHttpRequest *)request
{
	
}

- (void)requestHTTP:(NSString*)url
         withSender:(id)sender
            withSel:(SEL)aSelect
          andFields:(NSDictionary*)fields
           andFiles:(NSDictionary*)files
	   withUserInfo:(NSDictionary *)userInfo
{
    [self requestHTTP:url withSender:sender withSel:aSelect withTimeOut:MaxRequestTime andFields:fields andFiles:files withUserInfo:userInfo];
}
- (void)requestHTTP:(NSString*)url
         withSender:(id)sender
            withSel:(SEL)aSelect
		withTimeOut:(int)timeOut
          andFields:(NSDictionary*)fields
           andFiles:(NSDictionary*)files
	   withUserInfo:(NSDictionary *)userInfo
{
    [self requestHTTP:url withSender:sender withSel:aSelect andFields:fields andFiles:files withTimeOut:timeOut andBytesReceivedBlock:nil andBytesSentBlock:nil andCompletionBlock:nil andStartBlock:nil withUserInfo:userInfo];
}
- (void)requestHTTP:(NSString*)url
         withSender:(id)sender
            withSel:(SEL)aSelect
          andFields:(NSDictionary*)fields
           andFiles:(NSDictionary*)files
andBytesReceivedBlock:(ASIProgressBlock)aBytesReceivedBlock
  andBytesSentBlock:(ASIProgressBlock)aBytesSentBlock
 andCompletionBlock:(ASIBasicBlock)aCompletionBlock
      andStartBlock:(ASIBasicBlock)aStartedBlock
	   withUserInfo:(NSDictionary *)userInfo
{
	[self requestHTTP:url withSender:sender withSel:aSelect andFields:fields andFiles:files withTimeOut:MaxRequestTime andBytesReceivedBlock:aBytesReceivedBlock andBytesSentBlock:aBytesSentBlock andCompletionBlock:aCompletionBlock andStartBlock:aStartedBlock withUserInfo:userInfo] ;
}
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
	   withUserInfo:(NSDictionary *)userInfo
{
    DLogInfo(@"requestHTTP(%@)\r\nFields:%@\r\nFiles:%@", url, fields, files);
	
	if (self.openHttpDebug) {
		NSString *text = [NSString stringWithFormat:@"requestHTTP(%@)\r\nFields:%@\r\nFiles:%@", url, fields, files];
		[[KXLogManager shareLogManager] writeHttpLog:text];
	}
	
	
	
    KXHttpRequest *request = [[KXHttpRequest alloc] initWithURL:url andSender:sender andSel:aSelect];
	request.userInfo = userInfo;
	request.timeOutSeconds = timeout;
    if (aStartedBlock) {
        [request setStartedBlock:aStartedBlock];
    }
    if (aBytesReceivedBlock) {
        [request setBytesReceivedBlock:aBytesReceivedBlock];
    }
    if (aBytesSentBlock) {
        [request setBytesSentBlock:aBytesSentBlock];
    }
    if (aCompletionBlock) {
        [request setCompletionBlock:aCompletionBlock];
    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:YES];
#endif
    if (fields) {
		request.fieldsDic = fields;
        [fields enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [request setPostValue:obj forKey:key];
        }];
    }
    if (files) {
		request.fileDic = files;
		for (NSString *key in files.allKeys) {
			NSLog(@"up file key %@ value %@",key ,files[key]);
			[request addFile:files[key] forKey:key];
		}
//        [files enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//            [request setFile:obj forKey:key];
//        }];
		if (aStartedBlock) {
			[request setStartedBlock:aStartedBlock];
		}
		if (aBytesReceivedBlock) {
			[request setBytesReceivedBlock:aBytesReceivedBlock];
		}
		if (aBytesSentBlock) {
			[request setBytesSentBlock:aBytesSentBlock];
			
		}
		if (aCompletionBlock) {
			[request setCompletionBlock:aCompletionBlock];
		}
		
    }
	//    [request startAsynchronous];
    [self.networkQueue addOperation:request];
    DLogDebug(@"requestHTTP end");
}

@end

