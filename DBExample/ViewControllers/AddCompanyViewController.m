//
//  AddCompanyTableViewController.m
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//

#import "AddCompanyViewController.h"
#import "AppAnalytics.h"
#import "AppManager.h"
#import "AppDebugLog.h"
#import "SettingsModel.h"

@interface AddCompanyViewController ()

@end

@implementation AddCompanyViewController

@synthesize delegate,nameTextField,addressTextField,phoneTextField,cityTextField,stateTextField,countryTextField,companyToEdit;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [nameTextField setDelegate:self];
    [addressTextField setDelegate:self];
    [phoneTextField setDelegate:self];
    [cityTextField setDelegate:self];
    [stateTextField setDelegate:self];
    [countryTextField setDelegate:self];

    if(companyToEdit != nil)
    {
        self.title = [NSString stringWithFormat:@"%@",companyToEdit.name];
        nameTextField.text = companyToEdit.name;
        addressTextField.text = companyToEdit.address;
        phoneTextField.text = companyToEdit.phoneMain;
        cityTextField.text = companyToEdit.city;
        stateTextField.text = companyToEdit.state;
        countryTextField.text = companyToEdit.country;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableDictionary *event =
    [[GAIDictionaryBuilder createEventWithCategory:@"AddCompanyVCtrl"
                                            action:@"WillAppear"
                                             label:[SettingsModel getUserName]
                                             value:nil] build];
    [[AppAnalytics sharedInstance].defaultTracker send:event];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

-(NSString*)getRandomCompanyLogo
{
    //These PNG's are in the Companies folder
    //There never displayed, but it shows how to store an image in the DB
    NSString *companyLogo = @"Apple.png";
    int logoInt = (int)arc4random() % 8;
    if(logoInt == 0)
        companyLogo = @"Apple.png";
    else if (logoInt == 1)
        companyLogo = @"AMD.png";
    else if (logoInt == 2)
        companyLogo = @"Intel.png";
    else if (logoInt == 3)
        companyLogo = @"Cisco.png";
    else if (logoInt == 4)
        companyLogo = @"ChaseBank.png";
    else if (logoInt == 5)
        companyLogo = @"Chevron.png";
    else if (logoInt == 6)
        companyLogo = @"BofA.png";
    else if (logoInt == 7)
        companyLogo = @"WellsFargo.png";
    else if (logoInt == 8)
        companyLogo = @"Zynga.png";
    else
        companyLogo = @"Apple.png";

    return companyLogo;
}

-(IBAction)done:(id)sender
{
    if(companyToEdit != nil)
    {
        companyToEdit.name = nameTextField.text;
        companyToEdit.address = addressTextField.text;
        companyToEdit.phoneMain = phoneTextField.text;
        companyToEdit.city = cityTextField.text;
        companyToEdit.state = stateTextField.text;
        companyToEdit.country = countryTextField.text;
        [companyToEdit setCompanyThumbnail:UIImagePNGRepresentation([UIImage imageNamed:[self getRandomCompanyLogo]])];

        NSMutableDictionary *event =
        [[GAIDictionaryBuilder createEventWithCategory:@"AddCompanyVCtrl"
                                                action:@"EditExistingCompany"
                                                 label:[SettingsModel getUserName]
                                                 value:nil] build];
        [[AppAnalytics sharedInstance].defaultTracker send:event];
        
        if(![self validate:companyToEdit])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid Company" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
            return;
        }
        [delegate addCompanyViewController:self didEditCompany:companyToEdit];
    }
    else
    {
        CompanyObject *company = [[CompanyObject alloc] init];
        company.name = nameTextField.text;
        company.address = addressTextField.text;
        company.phoneMain = phoneTextField.text;
        company.city = cityTextField.text;
        company.state = stateTextField.text;
        company.country = countryTextField.text;
        [companyToEdit setCompanyThumbnail:UIImagePNGRepresentation([UIImage imageNamed:[self getRandomCompanyLogo]])];

        NSMutableDictionary *event =
        [[GAIDictionaryBuilder createEventWithCategory:@"AddCompanyVCtrl"
                                                action:@"AddNewCompany"
                                                 label:[SettingsModel getUserName]
                                                 value:nil] build];
        [[AppAnalytics sharedInstance].defaultTracker send:event];
        
        if(![self validate:company])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid Company" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
            return;
        }
        [delegate addCompanyViewController:self didAddCompany:company];
    }
}

-(BOOL)validate:(CompanyObject*)company
{
    //Should really check all the fields, but hey it's a demo
    if(([company.name length] == 0) || ([company.address length] == 0))
    {
        return NO;
    }
    
    return YES;
}

-(IBAction)cancel:(id)sender
{
    NSMutableDictionary *event =
    [[GAIDictionaryBuilder createEventWithCategory:@"AddCompanyVCtrl"
                                            action:@"CancelCompany"
                                             label:[SettingsModel getUserName]
                                             value:nil] build];
    [[AppAnalytics sharedInstance].defaultTracker send:event];

    [delegate addCompanyViewControllerDidCancel:self];
}

//Keep this last in the file
- (void)didReceiveMemoryWarning
{
    [AppManager currentMemoryConsumption:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]];
    [AppDebugLog writeDebugData:[NSString stringWithFormat:@"AddCompanyVCtrl : didReceiveMemoryWarning"]];
    NSLog(@"AddCompanyVCtrl : didReceiveMemoryWarning : ERROR");
    [super didReceiveMemoryWarning];
}

@end
