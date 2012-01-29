//
//  DetailViewController.h
//  swypCards
//
//  Created by Alexander List on 1/28/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

typedef enum{
	cardViewStateCover,
	cardViewStateInside
}cardViewState;

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate,swypContentDataSourceProtocol, swypConnectionSessionDataDelegate>{
	
	__weak id<swypContentDataSourceDelegate>	_delegate;
	
	cardViewState				_currentCardState;
	
	IBOutlet UIImageView *		_cardImageView;
	IBOutlet UILabel *			_cardLabel;
	
	UIButton *						_activateSwypButton;
	
	swypWorkspaceViewController*	_swypWorkspace;
	NSManagedObjectContext *		_objectContext;
}

-(id) initWithSwypWorkspace:(swypWorkspaceViewController*)workspace managedObjectContext:(NSManagedObjectContext*)context;

@property (strong, nonatomic) swypWorkspaceViewController * swypWorkspace;
@property (strong, nonatomic) Card* cardDetailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;


-(void) setupViewForState:(cardViewState)cardState;
-(void)	transitionToState:(cardViewState)cardState;
-(void) setupCardImageViewForCurrentStateWithImage:(UIImage*)image;
-(UIImage*)	constrainImage:(UIImage*)image toSize:(CGSize)maxSize;
@end
