//
//  Card.h
//  swypCards
//
//  Created by Alexander List on 1/28/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Card : NSManagedObject
@property (nonatomic, retain) NSData * coverImage;
@property (nonatomic, retain) NSData * insideImage;
@property (nonatomic, retain) NSString * signature;
@property (nonatomic, retain) NSData * thumbnailImage;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSNumber * wasReceived;

-(NSData*)serializedDataValue;
-(void) setValuesFromSerializedData:(NSData*)serializedData;
@end
