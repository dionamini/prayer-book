//
//  BookmarksViewController.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/27/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "BookmarksViewController.h"
#import "PrayerViewController.h"

@implementation BookmarksViewController


- (id)init {
	if (self = [super initWithStyle:UITableViewStylePlain]) {
		prayerDatabase = [PrayerDatabase sharedInstance];
		bookmarks = nil;
		self.title = NSLocalizedString(@"BOOKMARKS", nil);
		[self setTabBarItem:[[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:1] autorelease]];
		self.navigationItem.rightBarButtonItem = [self editButtonItem];
	}
	
	return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [bookmarks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"MyIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[PrayerTableCell alloc] initWithFrame:CGRectMake(0,0,0,0) reuseIdentifier:MyIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	// Configure the cell
	NSNumber *bookmark = [bookmarks objectAtIndex:indexPath.row];
	Prayer *prayer = [prayerDatabase prayerWithId:[bookmark longValue]];
	[(PrayerTableCell*)cell titleLabel].text  = prayer.title;
	[(PrayerTableCell*)cell categoryLabel].text = prayer.category;
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSNumber *bookmark = [bookmarks objectAtIndex:indexPath.row];
	Prayer *prayer = [prayerDatabase prayerWithId:[bookmark longValue]];
	
	PrayerViewController *prayerViewController = [[PrayerViewController alloc] initWithPrayer:prayer];
	[[self navigationController] pushViewController:prayerViewController animated:YES];
	
}

/*
	Handles deleting bookmarks
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[prayerDatabase removeBookmark:[[bookmarks objectAtIndex:indexPath.row] longValue]];
		[bookmarks release];
		bookmarks = [prayerDatabase getBookmarks];
		[bookmarks retain];
		
		[tableView reloadData];
		
		// if there are no more bookmarks, we should end editing
		if ([bookmarks count] == 0)
		{
			[self setEditing:NO animated:YES];
			[self.navigationItem.rightBarButtonItem setEnabled:NO];
		}
	}
}

- (void)loadSavedState:(NSMutableArray*)savedState {
	NSNumber *prayerId = [savedState objectAtIndex:0];
	Prayer *prayer = [prayerDatabase prayerWithId:[prayerId longValue]];
	
	PrayerViewController *pvc = [[PrayerViewController alloc] initWithPrayer:prayer];
	[[self navigationController] pushViewController:pvc animated:NO];
}

/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/
/*
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/
/*
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


- (void)dealloc {
	[super dealloc];
}


- (void)viewDidLoad {
	[super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// in case we already have a list of bookmarks
	[bookmarks release];
	
	bookmarks = [prayerDatabase getBookmarks];
	[bookmarks retain];
	
	if ([bookmarks count] > 0)
		[self.navigationItem.rightBarButtonItem setEnabled:YES];
	else
		[self.navigationItem.rightBarButtonItem setEnabled:NO];
	
	[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end

