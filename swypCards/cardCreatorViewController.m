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

#pragma mark - View Setup
-(void) setupViewForStep:(cardCreatorCreationStep)step{

	switch (step) {
		case cardCreatorCreationStepAddCover:
			_cardLabel.text	=	NSLocalizedString(@"swyp to add a cover", @"on card creator");
			if (_cardInCreation.coverImage == nil){
				[_cardView setBackgroundColor:[UIColor grayColor]];
			}else{
				UIImage * cardImage	=	[UIImage imageWithData:[_cardInCreation coverImage]];
				[_cardView setImage:cardImage];
			}
			break;
		case cardCreatorCreationStepAddInside:
			_cardLabel.text	=	NSLocalizedString(@"swyp to add inside image", @"on card creator step two");
			if (_cardInCreation.insideImage == nil){
				[_cardView setBackgroundColor:[UIColor grayColor]];
			}else{
				UIImage * cardImage	=	[UIImage imageWithData:[_cardInCreation insideImage]];
				[_cardView setImage:cardImage];
			}
			break;
			
		default:
			break;
	}
}

-(void)	transitionToStep:(cardCreatorCreationStep)step{
	
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
//	CGMutablePathRef shadowPath		=	CGPathCreateMutable();
//	CGPathAddRect(shadowPath, NULL, CGRectMake(0, 0, _cardView.size.width, _cardView.size.height));
//	[layer setShadowPath:shadowPath];
//	CFRelease(shadowPath);
	[_cardView setClipsToBounds:NO];
	
	_cardInCreation	=	[NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:_objectContext];
	
	[[_swypWorkspace contentManager] setContentDataSource:self];
	
}


-(void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	if (_currentStep == cardCreatorCreationStepAddCover){
		if (_cardInCreation.coverImage == nil){
			_currentStep = cardCreatorCreationStepAddInside;
			[UIView animateWithDuration:2 delay:.75 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
				[self setupViewForStep:_currentStep];
			}completion:nil];
		}
	}
}

-(void) viewWillDisappear:(BOOL)animated{
	if (_currentStep < cardCreatorCreationStepAddSignature){
		[_objectContext deleteObject:_cardInCreation];
		[_delegate cardCreator:self didFinishWithCard:nil];
	}
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

#pragma mark - NSObject
-(id) initWithSwypWorkspace:(swypWorkspaceViewController*)workspace objectContext:(NSManagedObjectContext*)context cardCreatorDelegate:(id<cardCreatorViewControllerDelegate>)delegate{
	if (self = [super initWithNibName:nil bundle:nil]){
		
	}
	return self;
}

-(void)dealloc{
	[[_swypWorkspace contentManager] setContentDataSource:nil];
	
	_delegate		=	nil;
	_objectContext	=	nil;
	_swypWorkspace	=	nil;
	
	_cardInCreation	=	nil;
	
	_cardLabel					= nil;
	_cardView					= nil;
	_swypWorkspacePromptButton	= nil;
}

#pragma mark - delegation
#pragma mark swypConnectionSessionDataDelegate
-(NSArray*)	supportedFileTypesForReceipt{
	
	return [NSArray arrayWithObjects:[NSString imageJPEGFileType],[NSString imagePNGFileType], nil];
}

-(BOOL) delegateWillHandleDiscernedStream:(swypDiscernedInputStream*)discernedStream wantsAsData:(BOOL *)wantsProvidedAsNSData inConnectionSession:(swypConnectionSession*)session{
	if ([[self supportedFileTypesForReceipt] containsObject:[discernedStream streamType]]){
		wantsProvidedAsNSData = (BOOL *)TRUE;
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
