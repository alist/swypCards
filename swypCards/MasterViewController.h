//
//  MasterViewController.h
//  swypCards
//
//  Created by Alexander List on 1/28/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cardCreatorViewController.h"

@class DetailViewController;

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, cardCreatorViewControllerDelegate, swypWorkspaceDelegate>{
	swypWorkspaceViewController *	_swypWorkspace;
}
@property (nonatomic, readonly) swypWorkspaceViewController * swypWorkspace;

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
