//
//  MasterViewController.m
//  swypCards
//
//  Created by Alexander List on 1/28/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Card.h"
#import "exoNSDateAddtions.h"
#import "swypPhotoPlayground.h"

@interface MasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

#pragma mark - swyp
-(void) activateSwypButtonPressed:(id)sender{
	[[self swypWorkspace] presentContentWorkspaceAtopViewController:self];
}

-(void)frameActivateButtonWithSize:(CGSize)theSize {
	CGSize thisViewSize	=	[[self view] size];
    [_iPhoneModeSwypPromptButton setFrame:CGRectMake(((thisViewSize.width)-theSize.width)/2, thisViewSize.height-theSize.height, theSize.width, theSize.height)];
}



#pragma mark - 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"Cards", @"Cards");
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		    self.clearsSelectionOnViewWillAppear = NO;
		    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
		}
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	// Set up the edit and add buttons.
	self.navigationItem.leftBarButtonItem = self.editButtonItem;

	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newCardButtonPressed)];
	self.navigationItem.rightBarButtonItem = addButton;
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		_iPhoneModeSwypPromptButton	=	[UIButton buttonWithType:UIButtonTypeCustom];
		UIImage *	swypActivateImage	=	[UIImage imageNamed:@"swypPhotosHud"];
		[_iPhoneModeSwypPromptButton setBackgroundImage:swypActivateImage forState:UIControlStateNormal];
		_iPhoneModeSwypPromptButton.alpha = 0;
		[self frameActivateButtonWithSize:swypActivateImage.size];
		[_iPhoneModeSwypPromptButton addTarget:self action:@selector(activateSwypButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		UISwipeGestureRecognizer *swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(activateSwypButtonPressed:)];
		swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
		[_iPhoneModeSwypPromptButton addGestureRecognizer:swipeUpRecognizer];
		
		[self.view addSubview:_iPhoneModeSwypPromptButton];
//		[self.tableView setTableFooterView:_iPhoneModeSwypPromptButton];
	}
	
}

- (void)viewDidUnload
{
	_iPhoneModeSwypPromptButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	[[_swypWorkspace contentManager] setContentDataSource:self];
	[self frameActivateButtonWithSize:_iPhoneModeSwypPromptButton.size];
	[UIView animateWithDuration:.5 animations:^{
		_iPhoneModeSwypPromptButton.alpha = 1;
	}];

}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    _iPhoneModeSwypPromptButton.alpha = 0;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self frameActivateButtonWithSize:_iPhoneModeSwypPromptButton.size];
	[UIView animateWithDuration:.5 animations:^{
		_iPhoneModeSwypPromptButton.alpha = 1;
	}];
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

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }

	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if ([context hasChanges] && ![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    if (!self.detailViewController) {
			DetailViewController *detailViewController = [[DetailViewController alloc] initWithSwypWorkspace:[self swypWorkspace] managedObjectContext:[self managedObjectContext]];
			self.detailViewController = detailViewController;
	    }
        Card *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        self.detailViewController.cardDetailItem = selectedObject;    
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    } else {
        Card *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        self.detailViewController.cardDetailItem = selectedObject;    
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    // Set up the fetched results controller.
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    /*
	     Replace this implementation with code to handle the error appropriately.

	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Card *managedCard = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text			= [managedCard signature];
	cell.textLabel.font			= [UIFont fontWithName:@"BradleyHandITCTT-Bold" size:20];
	cell.detailTextLabel.text	= [[managedCard timeStamp] formatAsShortString];
}

#pragma mark - cardCreator

-(void)newCardButtonPressed{
		
	cardCreatorViewController * creatorController	=	[[cardCreatorViewController alloc] initWithSwypWorkspace:[self swypWorkspace] objectContext:self.managedObjectContext cardCreatorDelegate:self];
	
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		[[self navigationController] pushViewController:creatorController animated:TRUE];	
	}else{
		[[[self detailViewController] navigationController] pushViewController:creatorController animated:TRUE];
	}
}
#pragma mark cardCreatorViewControllerDelegate

-(void)	cardCreator:(cardCreatorViewController*)creator didFinishWithCard:(Card*)card{
	if (card){
		

		NSManagedObjectContext *context = [self managedObjectContext];
		NSError *error = nil;
		if ([context hasChanges] && ![context save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		[[self navigationController] popToRootViewControllerAnimated:TRUE];
	}else{
		[[[self detailViewController] navigationController]  popToRootViewControllerAnimated:TRUE];
	}
}

#pragma mark - swypWorkspaceViewController
-(swypWorkspaceViewController*)swypWorkspace{
	if (_swypWorkspace == nil){
		_swypWorkspace	=	[[swypWorkspaceViewController alloc] init];
		[_swypWorkspace.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
		[_swypWorkspace.view setFrame:self.view.bounds];
		
		
		swypPhotoPlayground *	contentDisplayController	=	[[swypPhotoPlayground alloc] initWithPhotoSize:CGSizeMake(250, 200)];
		
		[[[self swypWorkspace] contentManager] setContentDisplayController:contentDisplayController];

	}
	return _swypWorkspace;
}

-(void)	delegateShouldDismissSwypWorkspace: (swypWorkspaceViewController*)workspace{
	[workspace dismissModalViewControllerAnimated:TRUE];
}

#pragma mark swypConnectionSessionDataDelegate
-(NSArray*)	supportedFileTypesForReceipt{
	
	return [NSArray arrayWithObjects:cardFileFormat, nil];
}

-(BOOL) delegateWillHandleDiscernedStream:(swypDiscernedInputStream*)discernedStream wantsAsData:(BOOL *)wantsProvidedAsNSData inConnectionSession:(swypConnectionSession*)session{
	if ([[self supportedFileTypesForReceipt] containsObject:[discernedStream streamType]]){
		*wantsProvidedAsNSData = TRUE;
		return TRUE;
	}
	return FALSE;
}

-(void)	yieldedData:(NSData*)streamData discernedStream:(swypDiscernedInputStream*)discernedStream inConnectionSession:(swypConnectionSession*)session{
	NSLog(@"GOT DATR %@!", [discernedStream streamType]);
	
	if ([[discernedStream streamType] isFileType:cardFileFormat]){
		Card * newCard	=	[NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:[self managedObjectContext]];
		[newCard setValuesFromSerializedData:streamData];

		NSError * error = nil;
        if ([[self managedObjectContext] hasChanges] && ![[self managedObjectContext] save:&error]){
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 	
		
		[self dismissModalViewControllerAnimated:TRUE];
	}
}

#pragma mark swypContentDataSourceProtocol
- (NSArray*)		idsForAllContent{
//	if (_cardDetailItem == nil)
		return nil;
//	return [NSArray arrayWithObject:@"MODEL_CURRENT_DETAILED_CARD"];
}
- (UIImage *)		iconImageForContentWithID: (NSString*)contentID ofMaxSize:(CGSize)maxIconSize{
	
	return nil;
	/*
	if (_cardDetailItem == nil){
		return nil;
	}
	UIImage * thumbnail = nil;
	if (_cardDetailItem.thumbnailImage == nil){
		thumbnail = [self constrainImage:[UIImage imageWithData:[_cardDetailItem coverImage]] toSize:maxIconSize];
		[_cardDetailItem setThumbnailImage:UIImageJPEGRepresentation(thumbnail, .8)];
	}else{
		thumbnail	=	[UIImage imageWithData:[_cardDetailItem thumbnailImage]];
	}
	return thumbnail; */
}
- (NSArray*)		supportedFileTypesForContentWithID: (NSString*)contentID{
	return [NSArray arrayWithObjects:cardFileFormat,[NSString imageJPEGFileType],[NSString imagePNGFileType], nil];
	;
}
- (NSInputStream*)	inputStreamForContentWithID: (NSString*)contentID fileType:	(swypFileTypeString*)type	length: (NSUInteger*)contentLengthDestOrNULL;{
	
	/*
	NSData * streamData = nil;
	if ([type isFileType:[NSString imageJPEGFileType]]){
		streamData = [_cardDetailItem coverImage];
	}else if ([type isFileType:[NSString imagePNGFileType]]){
		streamData = UIImagePNGRepresentation([UIImage imageWithData:[_cardDetailItem coverImage]]);
	}else if ([type isFileType:cardFileFormat]){
		streamData = [_cardDetailItem serializedDataValue];
	}
	
	*contentLengthDestOrNULL	=	[streamData length];
	return [NSInputStream inputStreamWithData:streamData]; */
	return nil;
}
-(void)	setDatasourceDelegate:			(id<swypContentDataSourceDelegate>)delegate{
//	_delegate	=	delegate;
}
-(id<swypContentDataSourceDelegate>)	datasourceDelegate{
	return nil;
}


@end
