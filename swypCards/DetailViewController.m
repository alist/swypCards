//
//  DetailViewController.m
//  swypCards
//
//  Created by Alexander List on 1/28/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize cardDetailItem = _cardDetailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;


#pragma mark - User Interface Cruft

#pragma mark - Managing the detail item

- (void)setDetailItem:(Card*)newDetailItem
{
    if (_cardDetailItem != newDetailItem) {
        _cardDetailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}


#pragma mark view configuration
- (void)configureView
{
    // Update the user interface for the detail item.

	if (self.cardDetailItem) {
	    self.detailDescriptionLabel.text	=	[self.cardDetailItem description];
		self.title							=	[_cardDetailItem signature];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"fake_luxury.png"]]];
	
	[_cardImageView setBackgroundColor:[UIColor grayColor]];
	
	CALayer	*layer	=	_cardImageView.layer;
	[layer setBorderColor: [[UIColor whiteColor] CGColor]];
	[layer setBorderWidth:8.0f];
	[layer setShadowColor: [[UIColor blackColor] CGColor]];
	[layer setShadowOpacity:0.9f];
	[layer setShadowOffset: CGSizeMake(1, 3)];
	[layer setShadowRadius:4.0];
	[_cardImageView setClipsToBounds:NO];
	
	
	[self configureView];
}


#pragma mark - View lifecycle
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}



- (void)viewDidUnload
{
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
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
		self.title = NSLocalizedString(@"Your Card", @"Your Card");
    }
    return self;
}
							
#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Cards", @"Cards");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
