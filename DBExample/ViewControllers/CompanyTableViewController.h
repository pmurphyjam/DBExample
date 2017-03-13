//
//  CompanyTableViewController.h
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
//  Info : Just a simple demo view to display company's.
//
#import <UIKit/UIKit.h>
#import "AddCompanyViewController.h"

@interface CompanyTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,AddCompanyDelegate>

-(void)populateCompanies:(BOOL)reload;

@end
