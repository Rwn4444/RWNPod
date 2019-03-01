//
//  NSString+Tool.h
//  guanjia
//
//  Created by hdkj005 on 16/7/12.
//  Copyright © 2016年 handong001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tool)

//时间转换
-(NSString *)RwnTimeExchangeWithDateFormat:(NSString *)dateFormat;
//获取当前时间
+(NSString *)RwnTimeNowWithDateFormat:(NSString *)dateFormat;
//获取当前时间戳
+(long long)RWNGetNowTimeInterval;
//计算时间间隔
+(NSString *)timeIntervalToNow:(NSString *)date;
/**
 倒计时功能
 
 @param date 开始的时间 单位毫秒
 @param allTime 总时间 单位秒
 @return return value description
 */
+(NSString *)DaoJiShi:(long long)date  andJiShiTime:(long long)allTime;
///检查字符串是否为空
+ (BOOL)checkForNull:(NSString *)checkString;
//emoji去除
- (NSString *)disable_emoji:(NSString *)text;
//转换时间
+(NSString*)changeToTimeWithCount:(NSInteger)count;
///md5加密
- (NSString *)md5;
///获取随机字符串
+(NSString *)getRandomStr;
/*
 声明：包含大写/小写/数字/特殊字符
 两种以下密码强度低
 两种密码强度中
 大于两种密码强度高
 密码强度标准根据需要随时调整
 */
//判断是否包含
+ (NSString*) judgePasswordStrength:(NSString*) _password;
///是否包含中文
+ (BOOL)hasChinese:(NSString *)str;
#pragma mark ---- 身份证校验----
+ (BOOL)validateIDCardNumber:(NSString *)value;
///获取ip
+(NSString *)getIPAddress;

///获取老师级别
-(NSString *)getTeacherType;
///获取老师级别
-(NSString *)getTeacherLeve;

///根据时间戳显示星期
+ (NSString *)dateWeekWithDateString:(NSString *)dateString;

@end
