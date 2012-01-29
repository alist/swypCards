//
//  exoNSDateAddtions.h
//  Bump2Pay
//
//  Created by Alexander List on 1/25/10.
//  Copyright 2010 List Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (exoAddtions)
+(NSDate*)dateWithDaysFromToday:(double)days;
+(NSDate*)dateWithExoStandardTimestamp:(NSString *)exoTimeStamp;
-(NSString*)exoStandardTimestampValue;
-(double)calendarDaysFromToday; //negative in past, positive in future
-(NSString*)formatAsShortString;
-(NSString*)formatAsShortTime;
- (NSDate*)dateAtMidnight ;
+ (NSDate*)dateWithToday;
@end
