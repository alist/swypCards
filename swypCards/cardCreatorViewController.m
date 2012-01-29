//
//  cardCreatorViewController.m
//  swypCards
//
//  Created by Alexander List on 1/28/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "cardCreatorViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation cardCreatorViewController


#pragma mark view interaction
-(void) activateSwypButtonPressed:(id)sender{
	[self presentModalViewController:_swypWorkspace animated:TRUE];
}


#pragma mark - View Setup
-(void) setupViewForStep:(cardCreatorCreationStep)step{
	UIImage * cardImage	=	nil;
	switch (step) {
		case cardCreatorCreationStepAddCover:
			_cardLabel.text	=	NSLocalizedString(@"swyp to add a cover", @"on card creator");
			if (_cardInCreation.coverImage == nil){
				[_cardView setBackgroundColor:[UIColor grayColor]];
				[_cardView setImage:nil];
			}else{
				cardImage	=	[UIImage imageWithData:[_cardInCreation coverImage]];
			}
			break;
		case cardCreatorCreationStepAddInside:
			_cardLabel.text	=	NSLocalizedString(@"swyp to add inside image", @"on card creator step two");
			if (_cardInCreation.insideImage == nil){
				[_cardView setBackgroundColor:[UIColor grayColor]];
				[_cardView setImage:nil];
			}else{
				cardImage	=	[UIImage imageWithData:[_cardInCreation insideImage]];
			}
			break;
		case cardCreatorCreationStepFinished:
			break;
		case cardCreatorCreationStepAddSignature:
			_cardLabel.text	=	NSLocalizedString(@"let them know it was you!", @"sign card on step three");
			[UIView animateWithDuration:.75 animations:^{_signatureField.alpha = 1;} completion:^(BOOL completed){
				[_signatureField becomeFirstResponder];
			}];
			break;
	}
	if (cardImage){
		[self setupCardImageViewForCurrentStateWithImage:cardImage];
	}
}

-(void) setupCardImageViewForCurrentStateWithImage:(UIImage*)image{

	CGPoint cardCenter	=	[_cardView center];
	CGSize maxSize		=	[_cardView size];
	
	UIImage * properlySizedImage	=	[self constrainImage:image toSize:CGSizeMake(maxSize.width * _cardView.layer.contentsScale, maxSize.height * _cardView.layer.contentsScale)];
	
	[_cardView setSize:properlySizedImage.size];
	[_cardView setCenter:cardCenter];
	
	[_cardView setImage:properlySizedImage];
	
	CALayer	*layer	=	_cardView.layer;
	CGMutablePathRef shadowPath		=	CGPathCreateMutable();
	CGPathAddRect(shadowPath, NULL, CGRectMake(0, 0, _cardView.size.width, _cardView.size.height));
	[layer setShadowPath:shadowPath];
	CFRelease(shadowPath);

}

-(UIImage*)	constrainImage:(UIImage*)image toSize:(CGSize)maxSize{
	if (image == nil)
		return nil;
	
	CGSize oversize = CGSizeMake([image size].width - maxSize.width, [image size].height - maxSize.height);
	
	CGSize iconSize			=	CGSizeZero;
	
	if (oversize.width > 0 || oversize.height > 0){
		if (oversize.height > oversize.width){
			double scaleQuantity	=	maxSize.height/ image.size.height;
			iconSize		=	CGSizeMake(scaleQuantity * image.size.width, maxSize.height);
		}else{
			double scaleQuantity	=	maxSize.width/ image.size.width;	
			iconSize		=	CGSizeMake(maxSize.width, scaleQuantity * image.size.height);		
		}
	}else{
		return image;
	}
	
	UIGraphicsBeginImageContextWithOptions(iconSize, NO, 1);
	[image drawInRect:CGRectMake(0,0,iconSize.width,iconSize.height)];
	UIImage* constrainedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return constrainedImage;
}


-(void)	transitionToStep:(cardCreatorCreationStep)step{
	
	if (step <= cardCreatorCreationStepAddInside){
		[UIView transitionWithView:_cardView duration:1 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{[self setupViewForStep:step];} completion:^(BOOL finished) {
//			[self setupViewForStep:step];
		}];
	}
	[self setupViewForStep:step];
}

-(void)frameActivateButtonWithSize:(CGSize)theSize {
	CGSize thisViewSize	=	[[self view] size];
    [_activateSwypButton setFrame:CGRectMake(((thisViewSize.width)-theSize.width)/2, thisViewSize.height-theSize.height, theSize.width, theSize.height)];
}


#pragma mark - UIViewController
-(void) viewDidLoad{
	[super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"fake_luxury.png"]]];
	
	[_cardView setBackgroundColor:[UIColor grayColor]];
	
	CALayer	*layer	=	_cardView.layer;
	[layer setBorderColor: [[UIColor whiteColor] CGColor]];
	[layer setBorderWidth:8.0f];
	[layer setShadowColor: [[UIColor blackColor] CGColor]];
	[layer setShadowOpacity:0.9f];
	[layer setShadowOffset: CGSizeMake(1, 3)];
	[layer setShadowRadius:4.0];
	[_cardView setClipsToBounds:NO];
	
	_cardInCreation	=	[[Card alloc] initWithEntity:[NSEntityDescription entityForName:@"Card" inManagedObjectContext:_objectContext] insertIntoManagedObjectContext:_objectContext];
	
	NSLog(@"Inserted: %@",[[_objectContext insertedObjects] description]);

	
	[[_swypWorkspace contentManager] setContentDataSource:self];
	
	
	//prompt button
	_activateSwypButton	=	[UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *	swypActivateImage	=	[UIImage imageNamed:@"swypPhotosHud"];
	[_activateSwypButton setBackgroundImage:swypActivateImage forState:UIControlStateNormal];
	_activateSwypButton.alpha = 0;
	[self frameActivateButtonWithSize:swypActivateImage.size];
	[_activateSwypButton addTarget:self action:@selector(activateSwypButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UISwipeGestureRecognizer *swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(activateSwypButtonPressed:)];
    swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [_activateSwypButton addGestureRecognizer:swipeUpRecognizer];
    
	[self.view addSubview:_activateSwypButton];

	[_signatureField setAlpha:0];
	[_signatureField setHidden:FALSE];
	[_signatureField setDelegate:self];
	
	[self setupViewForStep:_currentStep];
}


-(void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self frameActivateButtonWithSize:_activateSwypButton.size];
	[UIView animateWithDuration:.5 animations:^{
		_activateSwypButton.alpha = 1;
	}];
	
	if (_currentStep == cardCreatorCreationStepAddCover){
		if (_cardInCreation.coverImage != nil){
			_currentStep = cardCreatorCreationStepAddInside;
			[self transitionToStep:_currentStep];
		}
	}else if (_currentStep == cardCreatorCreationStepAddInside){
		if (_cardInCreation.coverImage != nil){
			_currentStep = cardCreatorCreationStepAddSignature;
			[self transitionToStep:_currentStep];
		}
	}
}

-(void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    _activateSwypButton.alpha = 0;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self frameActivateButtonWithSize:_activateSwypButton.size];
	[UIView animateWithDuration:.5 animations:^{
		_activateSwypButton.alpha = 1;
		[self setupViewForStep:_currentStep];
	}];
}


#pragma mark - NSObject
-(id) initWithSwypWorkspace:(swypWorkspaceViewController*)workspace objectContext:(NSManagedObjectContext*)context cardCreatorDelegate:(id<cardCreatorViewControllerDelegate>)delegate{
	if (self = [super initWithNibName:nil bundle:nil]){
		_objectContext	=	context;
		_delegate		=	delegate;
		_swypWorkspace	=	workspace;
	}
	return self;
}

-(void)dealloc{
	[[_swypWorkspace contentManager] setContentDataSource:nil];
	
	if (_currentStep < cardCreatorCreationStepAddSignature){
		[_objectContext deleteObject:_cardInCreation];
		[_delegate cardCreator:self didFinishWithCard:nil];
	}
	
	_delegate		=	nil;
	_objectContext	=	nil;
	_swypWorkspace	=	nil;
	
	_cardInCreation	=	nil;
	
	_cardLabel					= nil;
	_cardView					= nil;
	[_signatureField setDelegate:nil];
	_signatureField				= nil;
	
	[_activateSwypButton removeFromSuperview];
	_activateSwypButton			= nil;
}

#pragma mark - delegation
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
	if (textField != _signatureField)
		return TRUE;
		
	if (StringHasText([textField text])){
		return TRUE;
	}
	
	return FALSE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	if (textField != _signatureField)
		return TRUE;
	
	if (StringHasText([textField text])){
		[textField resignFirstResponder];
	}
	return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
	if (textField != _signatureField)
		return;
	if(_currentStep == cardCreatorCreationStepAddSignature){
		_currentStep = cardCreatorCreationStepFinished;
		[_cardInCreation setSignature:[textField text]];
		[_delegate cardCreator:self didFinishWithCard:_cardInCreation];
	}

}

#pragma mark UITextFieldDelegate

#pragma mark swypConnectionSessionDataDelegate
-(NSArray*)	supportedFileTypesForReceipt{
	
	return [NSArray arrayWithObjects:[NSString imageJPEGFileType],[NSString imagePNGFileType], nil];
}

-(BOOL) delegateWillHandleDiscernedStream:(swypDiscernedInputStream*)discernedStream wantsAsData:(BOOL *)wantsProvidedAsNSData inConnectionSession:(swypConnectionSession*)session{
	if ([[self supportedFileTypesForReceipt] containsObject:[discernedStream streamType]]){
		*wantsProvidedAsNSData = TRUE;
		return TRUE;
	}
	return FALSE;
}

-(void)	yieldedData:(NSData*)streamData discernedStream:(swypDiscernedInputStream*)discernedStream inConnectionSession:(swypConnectionSession*)session{
	UIImage * imageReceived = [UIImage imageWithData:streamData];
	if (imageReceived == nil)
		return;
	switch (_currentStep) {
		case cardCreatorCreationStepAddCover:
			[_cardInCreation setCoverImage:streamData];
			break;
		case cardCreatorCreationStepAddInside:
			[_cardInCreation setInsideImage:streamData];
			break;
			
		default:
			break;
	}
	[self setupViewForStep:_currentStep];
}

#pragma mark swypContentDataSourceProtocol
- (NSArray*)		idsForAllContent{
	return nil;
}
- (UIImage *)		iconImageForContentWithID: (NSString*)contentID ofMaxSize:(CGSize)maxIconSize{
	return nil;
}
- (NSArray*)		supportedFileTypesForContentWithID: (NSString*)contentID{
	return nil;
}
- (NSInputStream*)	inputStreamForContentWithID: (NSString*)contentID fileType:	(swypFileTypeString*)type	length: (NSUInteger*)contentLengthDestOrNULL;{
	return nil;
}
-(void)	setDatasourceDelegate:			(id<swypContentDataSourceDelegate>)delegate{
}
-(id<swypContentDataSourceDelegate>)	datasourceDelegate{
	return nil;
}

@end
