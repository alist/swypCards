//
//  Card.m
//  swypCards
//
//  Created by Alexander List on 1/28/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "Card.h"

@implementation Card
@dynamic coverImage;
@dynamic insideImage;
@dynamic signature;
@dynamic thumbnailImage;
@dynamic timeStamp;
@dynamic wasReceived;

-(void) awakeFromInsert{
	[super awakeFromInsert];
	self.timeStamp	=	[NSDate date];
}


-(NSData*)serializedDataValue{
	NSDictionary *allCommittedValues = [self committedValuesForKeys:nil];
	NSData * archive	=	[NSKeyedArchiver archivedDataWithRootObject:allCommittedValues];
	return archive;
}

-(void) setValuesFromSerializedData:(NSData*)serializedData{
	NSDictionary * decodedValues	=	[NSKeyedUnarchiver unarchiveObjectWithData:serializedData];
	for (NSString * key in decodedValues.allKeys){
		if ([[decodedValues valueForKey:key] isKindOfClass:[NSNull class]] == NO){
			NSLog(@"Set key value: %@",key);
			[self setValue:[decodedValues valueForKey:key] forKey:key];
		}
	}
}

@end
