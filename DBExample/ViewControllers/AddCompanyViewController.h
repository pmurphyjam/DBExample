//
//  AddCompanyTableViewController.h
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
//  Info : Just a demo view to add data for a company, and exercise the DB Companys table.
//  Uses a static TablevView for entering the company information, thus no cellForRowAtIndexPath.
//

#import <UIKit/UIKit.h>
#import "CompanyModel.h"
#import "CompanyObject.h"

@class AddCompanyViewController;

@protocol AddCompanyDelegate<NSObject>

-(void) addCompanyViewController:(AddCompanyViewController*)controller didAddCompany:(CompanyObject*)company;
-(void) addCompanyViewController:(AddCompanyViewController*)controller didEditCompany:(CompanyObject*)company;
-(void) addCompanyViewControllerDidCancel:(AddCompanyViewController*)controller;

@end

@interface AddCompanyViewController : UITableViewController<UITextFieldDelegate>

@property (nonatomic,strong) CompanyObject *companyToEdit;
@property (nonatomic,strong) IBOutlet UITextField *nameTextField;
@property (nonatomic,strong) IBOutlet UITextField *addressTextField;
@property (nonatomic,strong) IBOutlet UITextField *phoneTextField;
@property (nonatomic,strong) IBOutlet UITextField *cityTextField;
@property (nonatomic,strong) IBOutlet UITextField *stateTextField;
@property (nonatomic,strong) IBOutlet UITextField *countryTextField;
@property (nonatomic,weak) id<AddCompanyDelegate> delegate;

-(IBAction)done:(id) sender;
-(IBAction)cancel:(id) sender;
-(BOOL)validate:(CompanyObject*)company;

@end
