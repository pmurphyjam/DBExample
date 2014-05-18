//
//  CompanyTableViewController.m
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//

#import "CompanyTableViewController.h"
#import "AppAnalytics.h"
#import "AppManager.h"
#import "CompanyModel.h"
#import "CompanyObject.h"
#import "AppDebugLog.h"
#import "SettingsModel.h"

@interface CompanyTableViewController ()

@property (nonatomic,strong) NSMutableArray *companyArray;
@property (nonatomic, strong) IBOutlet UITableView *companyTableView;

@end

@implementation CompanyTableViewController

@synthesize companyArray;
@synthesize companyTableView;

//#define DEBUG
#import "AppConstants.h"

- (void)viewDidLoad
{
    [super viewDidLoad];
    NDLog(@"CompanyVCtrl : viewDidLoad ");
    companyArray = [[NSMutableArray alloc] init];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableDictionary *event =
    [[GAIDictionaryBuilder createEventWithCategory:@"CompanyVCtrl"
                                            action:@"WillAppear"
                                             label:[SettingsModel getUserName]
                                             value:nil] build];
    [[AppAnalytics sharedInstance].defaultTracker send:event];

    [self populateCompanies];
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

-(void) populateCompanies
{
    companyArray = [CompanyModel getCompanysForView];
    [companyTableView reloadData];
    NDLog(@"CompanyVCtrl : companyArray[%d] = %@",[companyArray count],companyArray);
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"AddCustomer"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        AddCompanyViewController *addCompanyViewController = [[navigationController viewControllers] objectAtIndex:0];
        addCompanyViewController.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"EditCustomer"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        AddCompanyViewController *addCompanyViewController = [[navigationController viewControllers] objectAtIndex:0];
        addCompanyViewController.delegate = self;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        CompanyObject *company = [companyArray objectAtIndex:[indexPath row]];
        addCompanyViewController.companyToEdit = company;
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [companyArray count];
}

-(void) addCompanyViewControllerDidCancel:(AddCompanyViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [companyTableView reloadData];
}

-(void) addCompanyViewController:(AddCompanyViewController *)controller didEditCompany:(CompanyObject*)company
{
    [CompanyModel updateCompany:company];
    [self populateCompanies];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) addCompanyViewController:(AddCompanyViewController *)controller didAddCompany:(CompanyObject*)company
{
    [CompanyModel insertCompany:company];
    [self populateCompanies];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CompanyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CompanyObject *company = [companyArray objectAtIndex:[indexPath row]];
    NDLog(@"CompanyVCtrl : company[%ld] = %@",(long)[indexPath row],company);
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@ %@",company.name,company.address]];
    return cell;
}

//Keep this last in the file
- (void)didReceiveMemoryWarning
{
    [AppManager currentMemoryConsumption:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]];
    [AppDebugLog writeDebugData:[NSString stringWithFormat:@"CompanyVCtrl : didReceiveMemoryWarning"]];
    NSLog(@"CompanyVCtrl : didReceiveMemoryWarning : ERROR");
    [super didReceiveMemoryWarning];
}

@end
