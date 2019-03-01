//
//  NSString+Tool.m
//  guanjia
//
//  Created by hdkj005 on 16/7/12.
//  Copyright © 2016年 handong001. All rights reserved.
//

#import "NSString+Tool.h"
#import <netdb.h>
#import <arpa/inet.h>
#import <CommonCrypto/CommonDigest.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation NSString (Tool)

-(NSString *)RwnTimeExchangeWithDateFormat:(NSString *)dateFormat{
    
    ///yyyy-MM-dd HH:mm:ss
    NSDate *sendDate = [NSDate dateWithTimeIntervalSince1970:[self longLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormat;
    NSString *sendStr = [formatter stringFromDate:sendDate];
    return sendStr;
    
}

+(NSString *)RwnTimeNowWithDateFormat:(NSString *)dateFormat{

    NSDate *data=[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //@"yyyy-MM-dd HH:mm:ss"
    formatter.dateFormat = dateFormat;
    NSString *sendStr = [formatter stringFromDate:data];
    return sendStr;
}

+(long long)RWNGetNowTimeInterval{

    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * timeStr=[formatter stringFromDate:currentDate];
    NSDate* date = [formatter dateFromString:timeStr];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    long long TimeChuo =  (long long)timeInterval * 1000;
    
    return TimeChuo;
}


+ (BOOL)checkForNull:(NSString *)checkString {
    
    if (checkString == NULL||[checkString isKindOfClass:[NSNull class]]||[checkString isEqualToString:@"null"]||[checkString isEqualToString:@"(null)"]||checkString == nil||[checkString isEqualToString:@"<null>"]||[checkString isEqualToString:@""]||([checkString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)) {
        return YES;
    }else {
        return NO;
    }
    
}


/**
 *  计算时间间隔
 *
 *  @param dateStr 时间
 *
 *  @return 时间间隔
 */
+(NSString *)timeIntervalToNow:(NSString* )dateStr
{
    NSDate *now=[NSDate date];
    NSNumber *time=[NSNumber numberWithLongLong:[now timeIntervalSince1970]*1000];
    long long nowTime=[time longLongValue]/1000;
    //1482904860 19542
    
    // 日期格式化类
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    // 设置日期格式 为了转换成功
    format.dateFormat = @"yyyy-MM-dd";// NSString * -> NSDate *
    NSDate *date = [format dateFromString:dateStr];
    NSNumber *dateT=[NSNumber numberWithLongLong:[date timeIntervalSince1970]*1000];
    long long dateTime=[dateT longLongValue]/1000;
    
    // 时间差
    long long   myTime=nowTime-dateTime;
//    //秒
//    if (myTime<60) {
//
//        return [NSString stringWithFormat:@"刚刚发表"];
//    }
//    //分钟
//    long long mint=myTime/60;
//    if (mint<60) {
//
//        return [NSString stringWithFormat:@"%ld分钟前",mint];
//    }
//    //小时
//    long long hour=myTime/(60*60);
//    if (hour<24) {
//        return [NSString stringWithFormat:@"%ld小时前",hour];
//    }
    
    //天数
    long day=myTime/(24*60*60);
    if (day<=0) {
        return @"当天";
    }else if (day<30){
        return [NSString stringWithFormat:@"%ld天前",day];
    }
    
    
    //月
    long month=myTime/(24*60*60*30);
    if (month<12) {
        return [NSString stringWithFormat:@"%ld月前",day];
    }
    
    return  nil;
}


/**
 倒计时功能

 @param date 开始的时间
 @param allTime 总时间
 @return return value description
 */
+(NSString *)DaoJiShi:(long long)date  andJiShiTime:(long long)allTime
{
    ///1523933304310
    ///1523931129000
    NSDate *now=[NSDate date];
    NSNumber *time=[NSNumber numberWithLongLong:[now timeIntervalSince1970]*1000];
    long long nowTime=[time longLongValue];
    // 时间差
    long long   myTime= allTime  - (nowTime-date)/1000;
    NSString *returnTime = @"";
    if (myTime>=0) {
        returnTime = [NSString changeToTimeWithCount:myTime];
    }else{
        returnTime = @"00:00";
    }
    return returnTime;
    
}



//emoji去除
- (NSString *)disable_emoji:(NSString *)text
{
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
    
}




+(NSString*)changeToTimeWithCount:(NSInteger)count{
    
    NSString *currentTime=@"00:00";
    
    if (count<10) {
        
        currentTime =[NSString stringWithFormat:@"00:0%zd",count];
        
    }else if (count<60){
        
        currentTime =[NSString stringWithFormat:@"00:%zd",count];
        
    }else{
        
//        NSInteger  hour = count/60/60;
        NSInteger  minute = count/60;
        NSInteger  second =count  -minute*60;
//        if (hour>0) {
//
//            currentTime =[NSString stringWithFormat:@"%zd:%zd:%zd",hour,minute,second];
//
//        }else{
        
            if (minute<10) {
                if (second<10) {
                    currentTime =[NSString stringWithFormat:@"0%zd:0%zd",minute,second];
                }else{
                    currentTime =[NSString stringWithFormat:@"0%zd:%zd",minute,second];
                }
            }else{
                if (second<10) {
                    currentTime =[NSString stringWithFormat:@"%zd:0%zd",minute, second];
                }else{
                    currentTime =[NSString stringWithFormat:@"%zd:%zd",minute, second];
                }
            }
            
//        }
        
        
        
        
    }
    
    return currentTime;
}



#pragma mark ======================= 判断密码的强度 =======================================

/*
 声明：包含大写/小写/数字/特殊字符
 两种以下密码强度低
 两种密码强度中
 大于两种密码强度高
 密码强度标准根据需要随时调整
 */
//判断是否包含
+ (BOOL) judgeRange:(NSArray*) _termArray Password:(NSString*) _password
{
    NSRange range;
    BOOL result =NO;
    for(int i=0; i<[_termArray count]; i++)
    {
        range = [_password rangeOfString:[_termArray objectAtIndex:i]];
        if(range.location != NSNotFound)
        {
            result =YES;
        }
    }
    return result;
}

+ (NSString*) judgePasswordStrength:(NSString*) _password
{
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    
    NSArray* termArray1 = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z",@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    NSArray* termArray2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
//    NSArray* termArray3 = [[NSArray alloc] initWithObjects: nil];
    NSArray* termArray4 = [[NSArray alloc] initWithObjects:@"~",@"`",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"-",@"_",@"+",@"=",@"{",@"}",@"[",@"]",@"|",@":",@";",@"“",@"'",@"‘",@"<",@",",@".",@">",@"?",@"/",@"、", nil];
    NSString* result1 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray1 Password:_password]];
    NSString* result2 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray2 Password:_password]];
//    NSString* result3 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray3 Password:_password]];
    NSString* result4 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray4 Password:_password]];
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result1]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result2]];
//    [resultArray addObject:[NSString stringWithFormat:@"%@",result3]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result4]];
    int intResult=0;
    for (int j=0; j<[resultArray count]; j++)
    {
        if ([[resultArray objectAtIndex:j] isEqualToString:@"1"])
        {
            intResult++;
        }
    }
    NSString* resultString = [[NSString alloc] init];
    if (intResult < 2)
    {
        resultString = @"0";
    }
    else if (intResult == 2&&[_password length]>=6)
    {
        resultString = @"1";
    }
    if (intResult > 2&&[_password length]>=6)
    {
        resultString = @"2";
    }
    return resultString;
}








- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+(NSString *)getRandomStr
{
    char data[32];
    for (int x=0;x < 32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    NSString *randomStr = [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
    NSString *string = [NSString stringWithFormat:@"%@",randomStr];
    
    return string;
    
}

///是否包含中文
+ (BOOL)hasChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark ---- 身份证校验----
+ (BOOL)validateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            //            [regularExpression release];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[1-2][0-9]][0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[1-2][0-9][0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            //            [regularExpressionrelease];
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return false;
    }
}


// Get IP Address
+(NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
    
}


///获取老师级别
-(NSString *)getTeacherType{
    
    NSString *teacherLeveName = @"";
    //1 普通 2 优选 3 超级
    if ([self isEqualToString:@"1"]) {
        teacherLeveName = @"家教老师" ;
    }else if ([self isEqualToString:@"2"]){
        teacherLeveName = @"优选老师" ;
    }else{
        teacherLeveName = @"超级老师" ;
    }
    return teacherLeveName;
    
}

///获取老师级别
-(NSString *)getTeacherLeve{
    
    NSString *teacherLeveName = @"";
    //1 普通 2 优选 3 超级
    if ([self isEqualToString:@"1"]) {
        teacherLeveName = @"家教" ;
    }else if ([self isEqualToString:@"2"]){
        teacherLeveName = @"优选" ;
    }else{
        teacherLeveName = @"超级" ;
    }
    return teacherLeveName;
    
}

+ (NSString *)dateWeekWithDateString:(NSString *)dateString
{
    NSTimeInterval time=[dateString doubleValue];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSCalendarUnitWeekday fromDate:date];
    NSInteger _weekday = [weekdayComponents weekday];
    NSString *weekStr;
    if (_weekday == 1) {
        weekStr = @"星期日";
    }else if (_weekday == 2){
        weekStr = @"星期一";
    }else if (_weekday == 3){
        weekStr = @"星期二";
    }else if (_weekday == 4){
        weekStr = @"星期三";
    }else if (_weekday == 5){
        weekStr = @"星期四";
    }else if (_weekday == 6){
        weekStr = @"星期五";
    }else if (_weekday == 7){
        weekStr = @"星期六";
    }
    return weekStr;
    
}



@end
