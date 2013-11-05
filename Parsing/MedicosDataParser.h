//
//  MedicosDataParser.h
//  tmovil
//
//  Created by Christian Helmut on 11/5/13.
//  Copyright (c) 2013 TCORP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpandableTableViewController.h"
#import "StarRatingControl.h"

@interface MedicosDataParser : NSObject

- (NSMutableDictionary *) dataModelForSegue:(NSMutableArray *) dataModel :(NSIndexPath *) indexPath;
- (NSMutableArray *) parseFetchedData:(NSArray *) JSONdata;
- (NSString *) GroupHeadsNombre:(NSMutableArray *)dataModel :(NSUInteger) section;
- (UITableViewCell *) dataForGroup:(ExpandableTableView *)tableView :(NSMutableArray *)dataModel :(NSUInteger) section;
- (UITableViewCell *) dataForRow:(UITableView *)tableView :(NSMutableArray *)dataModel :(NSIndexPath *) indexPath;
- (NSInteger) cantidadForGroup:(NSMutableArray *)dataModel;
- (NSInteger) cantidadFilasForGroup:(NSMutableArray *)dataModel :(NSUInteger) section;

@end
