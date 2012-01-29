//
//  DetailViewController.h
//  swypCards
//
//  Created by Alexander List on 1/28/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>{
	
	IBOutlet UIImageView *		_cardImageView;
}

@property (strong, nonatomic) Card* cardDetailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
