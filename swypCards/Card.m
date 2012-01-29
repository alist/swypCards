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

@end
