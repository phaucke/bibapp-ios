//
//  BALocationTableViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 07.02.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BALocationTableViewController.h"
#import "BAConnector.h"
#import "BALocationViewControllerIPhone.h"

@interface BALocationTableViewController ()

@end

@implementation BALocationTableViewController

@synthesize appDelegate;
@synthesize locationList;
@synthesize currentLocation;
@synthesize didReturnFromSegue;
@synthesize foundLocations;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.locationList = [[NSMutableArray alloc] init];
    self.didReturnFromSegue = NO;
    self.foundLocations = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!self.didReturnFromSegue) {
        [self.locationList removeAllObjects];
        [self.tableView reloadData];
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        spinner.frame = CGRectMake(0, 0, 320, 44);
        self.tableView.tableFooterView = spinner;
        
        BAConnector *locationConnector = [BAConnector generateConnector];
        [locationConnector getLocationsForLibraryByUri:[self.appDelegate.configuration getLocationURIForCatalog:self.appDelegate.options.selectedCatalogue] WithDelegate:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)command:(NSString *)command didFinishLoadingWithResult:(NSObject *)result
{
    if ([command isEqualToString:@"getLocationsForLibraryByUri"]) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:(NSData *)result options:kNilOptions error:nil];
        BAConnector *locationConnector = [BAConnector generateConnector];
        BALocation *tempLocationMain = [locationConnector loadLocationForUri:[self.appDelegate.configuration getLocationURIForCatalog:self.appDelegate.options.selectedCatalogue]];
        if (tempLocationMain != nil) {
            [self.locationList addObject:tempLocationMain];
            for (NSString *key in [json objectForKey:[self.appDelegate.configuration getLocationURIForCatalog:self.appDelegate.options.selectedCatalogue]]) {
                if ([key isEqualToString:@"http://www.w3.org/ns/org#hasSite"]) {
                    for (NSDictionary *tempUri in [[json objectForKey:[self.appDelegate.configuration getLocationURIForCatalog:self.appDelegate.options.selectedCatalogue]] objectForKey:key]) {
                        BALocation *tempLocation = [locationConnector loadLocationForUri:[tempUri objectForKey:@"value"]];
                        [self.locationList addObject:tempLocation];
                        self.foundLocations = YES;
                    }
                }
            }
        }
        [self.tableView reloadData];
        self.tableView.tableFooterView = nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.foundLocations) {
        return [self.locationList count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LocationListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    if (self.foundLocations) {
        [cell.textLabel setText:[(BALocation *)[self.locationList objectAtIndex:indexPath.row] name]];
    } else {
        [cell.textLabel setText:@"Keine Standortinformationen vorhanden"];
    }
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.foundLocations) {
        self.currentLocation = [self.locationList objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"ItemDetailLocationSegue" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.didReturnFromSegue = YES;
    if ([[segue identifier] isEqualToString:@"ItemDetailLocationSegue"]) {
        BALocationViewControllerIPhone *locationViewController = (BALocationViewControllerIPhone *)[segue destinationViewController];
        [locationViewController setCurrentLocation:self.currentLocation];
    }
}

@end
