//
//  UIMedicosController.h
//  tmovil
//
//  Created by Christian Helmut on 11/5/13.
//  Copyright (c) 2013 TCORP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MedicosDataParser.h"
#import "ExpandableTableViewController.h"
#import "DetalleMedicosController.h"
#import "SystemConfiguration/SystemConfiguration.h"
#import "SVPullToRefresh.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "StarRatingControl.h"
#import "SBJson.h"

@interface UIMedicosController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, ExpandableTableViewDataSource, ExpandableTableViewDelegate>
{
    NSMutableArray *tablaData;
    NSMutableArray *ciudadesData;
    ASIFormDataRequest *request;
}

@property (strong) NSString *requestOption;
@property (strong) NSString *ciudadSelected;
@property (nonatomic, retain) ASIFormDataRequest *request;
@property (strong) NSMutableArray *tablaData;
@property (strong) NSMutableArray *ciudadesData;
@property (nonatomic, strong) IBOutlet ExpandableTableView *tableView;
@property (nonatomic, strong) IBOutlet UIPickerView *ciudades;

@end
