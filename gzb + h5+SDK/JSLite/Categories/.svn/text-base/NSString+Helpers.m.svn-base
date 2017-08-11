//
//  NSString+Helpers.m
//  WordPress
//
//  Created by John Bickerstaff on 9/9/09.
//  
//

#import "NSString+Helpers.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Helpers)

#pragma mark Helpers
- (NSString *) stringByUrlEncoding
{
	return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,  (CFStringRef)self,  NULL,  (CFStringRef)@"!*'();:@&=+$,/?%#[]",  kCFStringEncodingUTF8));
}

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *) sha256{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

- (NSMutableDictionary *)dictionaryFromQueryString {
    if (!self)
        return nil;

    NSMutableDictionary *result = [NSMutableDictionary dictionary];

    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs) {
        NSRange separator = [pair rangeOfString:@"="];
        NSString *key, *value;
        if (separator.location != NSNotFound) {
            key = [pair substringToIndex:separator.location];
            value = [[pair substringFromIndex:separator.location + 1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        } else {
            key = pair;
            value = @"";
        }

        key = [key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [result setObject:value forKey:key];
    }

    return result;
}

- (NSString *)stringByReplacingHTMLEmoticonsWithEmoji {
    NSMutableString *result = [NSMutableString stringWithString:self];

    NSDictionary *replacements = @{
                                   @"arrow": @"➡",
                                   @"biggrin": @"😃",
                                   @"confused": @"😕",
                                   @"cool": @"😎",
                                   @"cry": @"😭",
                                   @"eek": @"😮",
                                   @"evil": @"😈",
                                   @"exclaim": @"❗",
                                   @"idea": @"💡",
                                   @"lol": @"😄",
                                   @"mad": @"😠",
                                   @"mrgreen": @"🐸",
                                   @"neutral": @"😐",
                                   @"question": @"❓",
                                   @"razz": @"😛",
                                   @"redface": @"😊",
                                   @"rolleyes": @"😒",
                                   @"sad": @"😞",
                                   @"smile": @"😊",
                                   @"surprised": @"😮",
                                   @"twisted": @"👿",
                                   @"wink": @"😉"
                                   };

    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<img src='.*?wp-includes/images/smilies/icon_(.+?).gif'.*?class='wp-smiley' ?/?>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:result options:0 range:NSMakeRange(0, [result length])];
    for (NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
        NSRange range = [match rangeAtIndex:1];
        NSString *icon = [result substringWithRange:range];
        NSString *replacement = [replacements objectForKey:icon];
        if (replacement) {
            [result replaceCharactersInRange:[match range] withString:replacement];
        }
    }
    return [NSString stringWithString:result];
}

/*
 * Uses a RegEx to strip all HTML tags from a string and unencode entites
 */
- (NSString *)stringByStrippingHTML {
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
        
    return s;
}

- (NSString *)stringByRemovingHTMLTags {
    NSString *html = self;
    NSScanner *scanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while ([scanner isAtEnd] == NO) {
        [scanner scanUpToString:@"<" intoString:NULL];
        [scanner scanUpToString:@">" intoString:&text];
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@" "];
    }
    
    return html;
}

+ (NSString *) UUID {
    CFUUIDRef puuid = CFUUIDCreate( kCFAllocatorSystemDefault );
    
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    
    NSString * result = (NSString *)CFStringCreateCopy( NULL, uuidString);
    
    CFRelease(puuid);
    
    CFRelease(uuidString);
    
    return [result autorelease];
}

/*
 * Validator
 */
int getIndex (char ch);
BOOL isNumber (char ch);

int getIndex (char ch) {
    if ((ch >= '0'&& ch <= '9')||(ch >= 'a'&& ch <= 'z')||
        (ch >= 'A' && ch <= 'Z')|| ch == '_') {
        return 0;
    }
    if (ch == '@') {
        return 1;
    }
    if (ch == '.') {
        return 2;
    }
    return -1;
}

BOOL isNumber (char ch)
{
    if (!(ch >= '0' && ch <= '9')) {
        return FALSE;
    }
    return TRUE;
}

- (BOOL) isValidZipcode
{
    const char *cvalue = [self UTF8String];
    int len = strlen(cvalue);
    if (len != 6) {
        return FALSE;
    }
    for (int i = 0; i < len; i++)
    {
        if (!(cvalue[i] >= '0' && cvalue[i] <= '9'))
        {
            return FALSE;
        }
    }
    return TRUE;
}

- (BOOL) validateEmail
{
    NSArray *array = [self componentsSeparatedByString:@"."];
    if ([array count] >= 4) {
        return FALSE;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL) isValidEmail {
    static int state[5][3] = {
        {1, -1, -1},
        {1,  2, -1},
        {3, -1, -1},
        {3, -1, 4},
        {4, -1, -1}
    };
    BOOL valid = TRUE;
    const char *cvalue = [self UTF8String];
    int currentState = 0;
    int len = strlen(cvalue);
    int index;
    for (int i = 0; i < len && valid; i++) {
        index = getIndex(cvalue[i]);
        if (index < 0) {
            valid = FALSE;
        }
        else {
            currentState = state[currentState][index];
            if (currentState < 0) {
                valid = FALSE;
            }
        }
    }
    //end state is invalid
    if (currentState != 4) {
        valid = FALSE;
    }
    return valid;
}

- (BOOL) isValidNumber{
    const char *cvalue = [self UTF8String];
    int len = strlen(cvalue);
    for (int i = 0; i < len; i++) {
        if(!isNumber(cvalue[i])){
            return FALSE;
        }
    }
    return TRUE;
}

- (BOOL) isValidPhone {
//    const char *cvalue = [self UTF8String];
//    int len = strlen(cvalue);
//    if (len != 11) {
//        return FALSE;
//    }
//    if (![self isValidNumber])
//    {
//        return FALSE;
//    }
//    NSString *preString = [[NSString stringWithFormat:@"%@",self] substringToIndex:2];
//    if ([preString isEqualToString:@"13"] ||
//        [preString isEqualToString: @"15"] ||
//        [preString isEqualToString: @"18"])
//    {
//        return TRUE;
//    }
//    else
//    {
//        return FALSE;
//    }
//    return TRUE;
    NSString *reg = @"^((\\d{4}|\\d{3})(\\d{7,8})|(\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)";
    NSPredicate *regx = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    return [regx evaluateWithObject:self];
}

- (BOOL) isValidString
{
    return self && [self length];
}

const int factor[] = { 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };//加权因子
const int checktable[] = { 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2 };//校验值对应表
- (BOOL) isValidIdentifier
{
    const int LENGTH = 18;
    const char *str = [[self lowercaseString] UTF8String];
    NSInteger i;
    NSInteger length = strlen(str);
    BOOL result = TRUE;
    /*
     * identifier length is invalid
     */
    if (15 != length && LENGTH != length)
    {
        result = FALSE;
    }
    else
    {
        for (i = 1; i < length - 1; i++)
        {
            if(!(str[i] >= '0' && str[i] <= '9'))
            {
                result = FALSE;
                break;
            }
        }
        if (result)
        {
            if(LENGTH == length)
            {
                if (!((str[i] >= '0' && str[i] <= '9')||str[i] == 'X'||str[i] == 'x'))
                {
                    result = FALSE;
                }
            }
        }
        /*
         * check sum for second generation identifier
         */
        if (result && length == LENGTH)
        {
            int i;
            int *ids = malloc(sizeof(int)*LENGTH);
            for (i = 0; i < LENGTH; i++)
            {
                ids[i] = str[i] - 48;
            }
            int checksum = 0;
            for (i = 0; i < LENGTH - 1; i ++ )
            {
                checksum += ids[i] * factor[i];
            }
            if (ids[17] == checktable[checksum%11]||
                (str[17] == 'x' && checktable[checksum % 11] == 10))
            {
                result  = TRUE;
            }
            else
            {
                result  = FALSE;
            }
            free(ids);
            ids = NULL;
        }
    }
    return result;
}

- (BOOL) isValidPassport
{
    const char *str = [self UTF8String];
    char first = str[0];
    NSInteger length = strlen(str);
    if (!(first == 'P' || first == 'G'))
    {
        return FALSE;
    }
    if (first == 'P')
    {
        if (length != 8)
        {
            return FALSE;
        }
    }
    if (first == 'G')
    {
        if (length != 9)
        {
            return FALSE;
        }
    }
    BOOL result = TRUE;
    for (NSInteger i = 1; i < length; i++)
    {
        if (!(str[i] >= '0' && str[i] <= '9'))
        {
            result = FALSE;
            break;
        }
    }
    return result;
}
/*
 * 常用信用卡卡号规则
 * Issuer Identifier  Card Number                            Length
 * Diner's Club       300xxx-305xxx, 3095xx, 36xxxx, 38xxxx  14
 * American Express   34xxxx, 37xxxx                         15
 * VISA               4xxxxx                                 13, 16
 * MasterCard         51xxxx-55xxxx                          16
 * JCB                3528xx-358xxx                          16
 * Discover           6011xx                                 16
 * 银联                622126-622925                          16
 *
 * 信用卡号验证基本算法：
 * 偶数位卡号奇数位上数字*2，奇数位卡号偶数位上数字*2。
 * 大于10的位数减9。
 * 全部数字加起来。
 * 结果不是10的倍数的卡号非法。
 * prefrences link:http://www.truevue.org/licai/credit-card-no
 *
 */
- (BOOL) isValidCreditNumber
{
    BOOL result = TRUE;
    NSInteger length = [self length];
    if (length >= 13)
    {
        result = [self isValidNumber];
        if (result)
        {
            NSInteger twoDigitBeginValue = [[self substringWithRange:NSMakeRange(0, 2)] integerValue];
            NSInteger threeDigitBeginValue = [[self substringWithRange:NSMakeRange(0, 3)] integerValue];
            NSInteger fourDigitBeginValue = [[self substringWithRange:NSMakeRange(0, 4)] integerValue];
            //Diner's Club
            if (((threeDigitBeginValue >= 300 && threeDigitBeginValue <= 305)||
                 fourDigitBeginValue == 3095||twoDigitBeginValue==36||twoDigitBeginValue==38) && (14 != length))
            {
                result = FALSE;
            }
            /*
            //VISA
            else if([self isStartWithString:@"4"] && !(13 == length||16 == length))
            {
                result = FALSE;
            }
            //MasterCard
            else if((twoDigitBeginValue >= 51||twoDigitBeginValue <= 55) && (16 != length))
            {
                result = FALSE;
            }
            //American Express
            else if(([self isStartWithString:@"34"]||[self isStartWithString:@"37"]) && (15 != length))
            {
                result = FALSE;
            }
            //Discover
            else if([self isStartWithString:@"6011"] && (16 != length))
            {
                result = FALSE;
            }*/
            else
            {
                NSInteger begin = [[self substringWithRange:NSMakeRange(0, 6)] integerValue];
                //CUP
                if ((begin >= 622126 && begin <= 622925) && (16 != length))
                {
                    result = FALSE;
                }
                //other
                else
                {
                    result = TRUE;
                }
            }
        }
        if (result)
        {
            NSInteger digitValue;
            NSInteger checkSum = 0;
            NSInteger index = 0;
            NSInteger leftIndex;
            //even length, odd index
            if (0 == length%2)
            {
                index = 0;
                leftIndex = 1;
            }
            //odd length, even index
            else
            {
                index = 1;
                leftIndex = 0;
            }
            while (index < length)
            {
                digitValue = [[self substringWithRange:NSMakeRange(index, 1)] integerValue];
                digitValue = digitValue*2;
                if (digitValue >= 10)
                {
                    checkSum += digitValue/10 + digitValue%10;
                }
                else
                {
                    checkSum += digitValue;
                }
                digitValue = [[self substringWithRange:NSMakeRange(leftIndex, 1)] integerValue];
                checkSum += digitValue;
                index += 2;
                leftIndex += 2;
            }
            result = (0 == checkSum%10) ? TRUE:FALSE;
        }
    }
    else
    {
        result = FALSE;
    }
    return result;
}

- (BOOL) isValidBirthday
{
    BOOL result = FALSE;
    if (self && 8 == [self length])
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd"];
        NSDate *date = [formatter dateFromString:self];
        [formatter release];
        if (date)
        {
            result = TRUE;
        }
    }
    return result;
}

-(BOOL) isValidName{

    BOOL result = FALSE;
    NSString * regex = @"^(?!_)(?!.*?_$)[*\\（(\\)）a-zA-Z0-9_\u4e00-\u9fa5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (self) {
        result = [pred evaluateWithObject:self];
    }
    
    return result;
}

- (BOOL) isChinaUnicomPhoneNumber
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    //    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    //    /**
    //     15         * 中国联通：China Unicom
    //     16         * 130,131,132,152,155,156,185,186
    //     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    //    /**
    //     20         * 中国电信：China Telecom
    //     21         * 133,1349,153,180,189
    //     22         */
    //    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    //    /**
    //     25         * 大陆地区固话及小灵通
    //     26         * 区号：010,020,021,022,023,024,025,027,028,029
    //     27         * 号码：七位或八位
    //     28         */
    //    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    //    NSString * PHS1 = @"^0(10|2[0-5789]|\\d{3}-)\\d{7,8}$";
    
    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    //    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    //    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    //    NSPredicate *regextestphs1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS1];
    
    if (//([regextestmobile evaluateWithObject:phonenumber] == YES)||
        //        ([regextestcm evaluateWithObject:phonenumber] == YES)||
        //        ([regextestct evaluateWithObject:phonenumber] == YES)||
        ([regextestcu evaluateWithObject:self] == YES)
        //        || ([regextestphs evaluateWithObject:phonenumber] == YES)
        //        || ([regextestphs1 evaluateWithObject:phonenumber] == YES)
        )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL) isValid:(IdentifierType) type
{
    if (!self ||[[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        return FALSE;
    }
    BOOL result = TRUE;
    switch (type)
    {
        case IdentifierTypeZipCode:
            result = [self isValidZipcode];
            break;
        case IdentifierTypeEmail:
            //            result = [self isValidEmail:value];
            result = [self validateEmail];
            break;
        case IdentifierTypePhone:
            result = [self isValidPhone];
            break;
        case IdentifierTypeUnicomPhone:
            result = [self isChinaUnicomPhoneNumber];
            break;
        case IdentifierTypeQQ:
            result = [self isValidNumber];
            break;
        case IdentifierTypeNumber:
            result = [self isValidNumber];
            break;
        case IdentifierTypeString:
            result = [self isValidString];
            break;
        case IdentifierTypeIdentifier:
            result = [self isValidIdentifier];
            break;
        case IdentifierTypePassort:
            result = [self isValidPassport];
            break;
        case IdentifierTypeCreditNumber:
            result = [self isValidCreditNumber];
            break;
        case IdentifierTypeBirthday:
            result = [self isValidBirthday];
            break;
        case IdentifierTypeName:
            result = [self isValidName];
            break;
        default:
            break;
    }
    return result;
}

@end

