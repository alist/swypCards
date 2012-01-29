//
//  exoNSDateAddtions.m
//  Bump2Pay
//
//  Created by Alexander List on 1/25/10.
//  Copyright 2010 List Consulting. All rights reserved.
//

#import "exoNSDateAddtions.h"

static double const kSecondsInDay = 86400.0;

@implementation NSDate (exoAddtions)
+(NSDate*)dateWithDaysFromToday:(double)days{
	return [[NSDate dateWithTimeIntervalSinceNow:kSecondsInDay * days] dateAtMidnight];
}


#pragma mark TODO: finnish this!
+(NSDate*)dateWithExoStandardTimestamp:(NSString *)exoTimeStamp{
	NSLog(@"Called non-completed 'dateWithExoStandardTimestamp' function!");
//	NSLog(@"%@", [[NSDate date] description]);
	return [NSDate date];	
}

#pragma mark TODO: finnish this!
-(NSString*)exoStandardTimestampValue{
	NSLog(@"Called non-completed 'exoStandardTimestampValue' function!");
	return @"fake fake fake";
}

-(NSString*)formatAsShortString{
	
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:[NSLocale currentLocale]];
	[formatter setDateFormat:@"eee, LLLL d, YYYY"];
	return [formatter stringFromDate:self];
}

-(NSString*)formatAsShortTime{
	NSTimeInterval diff = abs([self timeIntervalSinceNow]);
	if (diff < 1) {
		return @"Today";
	} else if (diff < 7) {
		static NSDateFormatter* formatter = nil;
		if (!formatter) {
			formatter = [[NSDateFormatter alloc] init];
			formatter.dateFormat = @"EEEE";
			formatter.locale = [NSLocale currentLocale] ;
		}
		return [formatter stringFromDate:self];
	} else {
		static NSDateFormatter* formatter = nil;
		if (!formatter) {
			formatter = [[NSDateFormatter alloc] init];
			formatter.dateFormat = @"M/d/yy";
			formatter.locale = [NSLocale currentLocale];
		}
		return [formatter stringFromDate:self];
	}

}

-(double)calendarDaysFromToday{
	NSTimeInterval interval =  [[self dateAtMidnight] timeIntervalSinceDate:[NSDate dateWithToday]];
	double daysFromToday = (double)interval/(60.0*60.0*24.0);
	
	return daysFromToday;
}

- (NSDate*)dateAtMidnight {
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"yyyy-d-M";
	
	NSString* time = [formatter stringFromDate:self];
	NSDate* date = [formatter dateFromString:time];
	return date;
}


+ (NSDate*)dateWithToday {
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
	formatter.dateFormat = @"yyyy-d-M";
	
	NSString* time = [formatter stringFromDate:[NSDate date]];
	NSDate* date = [formatter dateFromString:time];
	return date;
}
@end
