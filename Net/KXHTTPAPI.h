//
//  KXHTTPAPI.h
//  Goddess
//
//  Created by kuxing on 14-2-12.
//  Copyright (c) 2014年 yangyanan. All rights reserved.
//

#import <Foundation/Foundation.h>
//上传图片
extern NSString * const KXHTTPAPI_UpFile;
// 检查更新
extern NSString * const KXHTTPAPI_Check_Update;
// 上传地址信息
extern NSString * const KXHTTPAPI_Location;
//登录接口
extern NSString * const KXHTTPAPI_LOGIN;
//获得用户信息
extern NSString * const KXHTTPAPI_UserInfo;
//获得自己用户信息
extern NSString * const KXHTTPAPI_My_UserInfo;
// 获得关注列表
extern NSString * const KXHTTPAPI_MyCareList;
//jubao
extern NSString * const KXHTTPAPI_JuBao;
//注册时获取手机验证码接口
extern NSString * const KXHTTPAPI_GetCode ;
//注册
extern NSString * const KXHTTPAPI_Reg;
//找回密码时获取手机验证码接口
extern NSString * const KXHTTPAPI_FindCode;
//找回密码接口
extern NSString * const KXHTTPAPI_FindPWD;
//完善用户的基本信息
extern NSString * const KXHTTPAPI_Set_User_Info;
//附近的人
extern NSString * const KXHTTPAPI_Near_Friend;
//设置用户个人信息
extern NSString * const KXHTTPAPI_set_info;
//设置用户备注名
extern NSString * const KXHTTPAPI_set_alias;
//查找用户接口（此接口必须由用户手动触发，禁止擅自调用）
extern NSString * const KXHTTPAPI_Find_users;
//发起关注
extern NSString * const KXHTTPAPI_Focus_users;
//取消关注
extern NSString * const KXHTTPAPI_UNFocus_users;
//加入黑名单
extern NSString * const KXHTTPAPI_AddBlackList;
//黑名单列表
extern NSString * const KXHTTPAPI_BlackList;
//删除黑名单中的一个用户
extern NSString * const KXHTTPAPI_DelBlackList;
//开关设置
extern NSString * const KXHTTPAPI_Notify;
///-------
extern NSString *const KXHTTPAPI_Match_List;
//修改密码
extern NSString * const KXHTTPAPI_Change_pwd;
//修改用户资料
extern NSString * const KXHTTPAPI_Modify_user_info;
#pragma markk - 附近的人打分
extern NSString * const KXHTTPAPI_Match_Showed;
extern NSString * const KXHTTPAPI_Match_Cancel;