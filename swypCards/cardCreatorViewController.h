//
//  cardCreatorViewController.h
//  swypCards
//
//  Created by Alexander List on 1/28/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@class cardCreatorViewController;

@protocol cardCreatorViewControllerDelegate <NSObject>

-(void)	cardCreator:(cardCreatorViewController*)creator didFinishWithCard:(Card*)card;

@end

typedef enum{
	cardCreatorCreationStepAddCover = 0,	
	cardCreatorCreationStepAddInside,
	cardCreatorCreationStepAddSignature,
	cardCreatorCreationStepFinished
}cardCreatorCreationStep;


@interface cardCreatorViewController : UIViewController <swypContentDataSourceProtocol, swypConnectionSessionDataDelegate, UITextFieldDelegate>{
	cardCreatorCreationStep			_currentStep;
	
	Card *							_cardInCreation;
	
	swypWorkspaceViewController*	_swypWorkspace;
	NSManagedObjectContext	*		_objectContext;
	
	__weak id<cardCreatorViewControllerDelegate>	_delegate;
	
	//view components
	IBOutlet UILabel *				_cardLabel;
	IBOutlet UIImageView *			_cardImageView;
	IBOutlet UITextField *			_signatureField;
	
	UIButton *						_activateSwypButton;
}

-(id) initWithSwypWorkspace:(swypWorkspaceViewController*)workspace objectContext:(NSManagedObjectContext*)context cardCreatorDelegate:(id<cardCreatorViewControllerDelegate>)delegate;

-(void)	transitionToStep:(cardCreatorCreationStep)step;
-(void) setupViewForStep:(cardCreatorCreationStep)step;

-(void)frameActivateButtonWithSize:(CGSize)theSize ;
-(void) setupCardImageViewForCurrentStateWithImage:(UIImage*)image;
-(UIImage*)	constrainImage:(UIImage*)image toSize:(CGSize)maxSize;
@end
