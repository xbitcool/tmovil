//
//  UIMedicosController.m
//  tmovil
//
//  Created by Christian Helmut on 11/5/13.
//  Copyright (c) 2013 TCORP. All rights reserved.
//

#import "UIMedicosController.h"

@interface UIMedicosController ()

@end

@implementation UIMedicosController
@synthesize request, tableView, tablaData, ciudadesData, ciudades, requestOption, ciudadSelected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ciudadesData = [[NSMutableArray alloc] init];
	// Primero limpiamos cache de API para obtener Imagenes Asincronas
    [self flushCache];
    // Establecemos los parametros de guardado de cache de Imagenes
    [SDWebImageManager.sharedManager.imageDownloader setValue:@"TMovil" forHTTPHeaderField:@"TMovilData"];
    // Mostramos al usuario el Icono de Actividad de Red que se está obteniendo Información
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // Obtenemos las ciudades para el PickerView
    requestOption = @"ciudades";
    [self ObtenerCiudades];
    requestOption = @"medicos";
    [self ObtenerMedicos:ciudadSelected];
    // Delegamos a un weak esta misma clase para poder manejar el PullToRefresh en modo asincrono-thread
    __weak UIMedicosController *weakSelf = self;
    // Agregamos el Handler del pullToRefresh de nuestra Tabla mostrando nuevamente el icono de actividad de Red
    // mientras se obtiene toda la información.
    // Se limpia el cache de imágenes para obtener nuevas imágenes
    [self.tableView addPullToRefreshWithActionHandler:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [weakSelf flushCache];
        [weakSelf ObtenerMedicos: weakSelf.ciudadSelected];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Delegación de PickerView --------------------------------------------------------------------------------------------------------------

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [ciudadesData count];
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [ciudadesData objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    __weak UIMedicosController *weakSelf = self;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    ciudadSelected = [ciudadesData objectAtIndex:row];
    [weakSelf ObtenerMedicos:ciudadSelected];
}

// Delegación de ExpandableTableView  --------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(ExpandableTableView *)tableView
{
    NSInteger cantidad = 0;
    if ([tablaData count] == 0) {
		cantidad = 0;
	}
    MedicosDataParser *DataContainer = [[MedicosDataParser alloc] init];
    cantidad = [DataContainer cantidadForGroup:tablaData];
    return cantidad;
}

- (NSInteger)tableView:(ExpandableTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MedicosDataParser *DataContainer = [[MedicosDataParser alloc] init];
    return [DataContainer cantidadFilasForGroup:tablaData :section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    MedicosDataParser *DataContainer = [[MedicosDataParser alloc] init];
    return [DataContainer GroupHeadsNombre:tablaData :section];
}

- (UITableViewCell *)tableView:(ExpandableTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak UIMedicosController *weakSelf = self;
    MedicosDataParser *DataContainer = [[MedicosDataParser alloc] init];
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell = [DataContainer dataForRow:weakSelf.tableView :tablaData :indexPath];
    return cell;
}

- (UITableViewCell *)tableView:(ExpandableTableView *)tableView cellForGroupInSection:(NSUInteger)section
{
    __weak UIMedicosController *weakSelf = self;
    MedicosDataParser *DataContainer = [[MedicosDataParser alloc] init];
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell = [DataContainer dataForGroup:weakSelf.tableView :tablaData :section];
    return cell;
}

- (void)tableView:(ExpandableTableView *)tableView willExpandSection:(NSUInteger)section {
    __weak UIMedicosController *weakSelf = self;
	UITableViewCell *headerCell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
	[UIView animateWithDuration:0.3f animations:^{
		headerCell.accessoryView.transform = CGAffineTransformMakeRotation(M_PI - 0.00001);
	}];
}

- (void)tableView:(ExpandableTableView *)tableView willContractSection:(NSUInteger)section {
    __weak UIMedicosController *weakSelf = self;
	UITableViewCell *headerCell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
	[UIView animateWithDuration:0.3f animations:^{
		headerCell.accessoryView.transform = CGAffineTransformMakeRotation(0);
	}];
}

- (UIView *)tableView:(ExpandableTableView *)tableView viewForFooterInSection:(NSInteger)section
{
    __weak UIMedicosController *weakSelf = self;
    if (section == ([weakSelf.tableView numberOfSections] - 1))
        [self tableViewWillFinishLoading:weakSelf.tableView];
    return nil;
}

- (void)tableViewWillFinishLoading:(ExpandableTableView *)tableView
{
    
}

- (void)tableView:(ExpandableTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if(![self isConnectionAvailable])
        [self alertStatus:@"Por favor verifica tu conexion a Internet." :@"Conectividad Nula!"];
        else
        [self performSegueWithIdentifier:@"SegueToDetalle" sender:indexPath];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

// Delegación de Sesgamiento entre Interfaces  -------------------------------------------------------------------------------------------
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MedicosDataParser *DataContainer = [[MedicosDataParser alloc] init];
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    NSMutableDictionary *item = [DataContainer dataModelForSegue:tablaData :indexPath];
    DetalleMedicosController *vc       = [segue destinationViewController];
    vc.DatosDoctor = item;
}
//----------------------------------------------------------------------------------------------------------------------------------------

- (void)flushCache
{
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    [SDWebImageManager.sharedManager.imageCache clearDisk];
}

- (BOOL) isConnectionAvailable
{
    SCNetworkReachabilityFlags flags;
    BOOL receivedFlags;
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [@"tcorp.com.bo" UTF8String]);
    receivedFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);
    if (!receivedFlags || (flags == 0)) {
        return FALSE;
    } else {
        return TRUE;
    }
}

- (void) ObtenerCiudades
{
    if(![self isConnectionAvailable]) {
        [self alertStatus:@"Por favor verifica tu conexion a Internet." :@"Conectividad Nula!"];
    } else {
        NSURL *url = [NSURL URLWithString:@"http://app.upsa.edu.bo"];
        request = [ASIFormDataRequest requestWithURL:url];
        [request setDelegate:self];
        [request startSynchronous];
    }
}

- (void) ObtenerMedicos:(NSString*) ciudad
{
    if(![self isConnectionAvailable]) {
        [self alertStatus:@"Por favor verifica tu conexion a Internet." :@"Conectividad Nula!"];
    } else {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://app.upsa.edu.bo/%@", ciudad]];
        request = [ASIFormDataRequest requestWithURL:url];
        [request setDelegate:self];
        [request startAsynchronous];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)requestL {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *responseString = [requestL responseString];
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSArray *jsonData   = (NSArray *)[jsonParser objectWithString:responseString error:nil];
    if ([requestOption rangeOfString:@"medicos"].location != NSNotFound){
        MedicosDataParser *EngMenu = [[MedicosDataParser alloc] init];
        tablaData = [EngMenu parseFetchedData:jsonData];
        [tableView reloadData];
        __weak UIMedicosController *weakSelf = self;
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    }else{
        [ciudadesData addObject:@"Santa Cruz"];
        [ciudadesData addObject:@"Cochabamba"];
        [ciudadesData addObject:@"La Paz"];
        [ciudades reloadAllComponents];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)requestL
{
    NSError *error = [requestL error];
    [self alertStatus:@"Oops no se pudo obtener información, Intentelo más tarde" :[error localizedDescription]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    __weak UIMedicosController *weakSelf = self;
    [weakSelf.tableView.pullToRefreshView stopAnimating];
}

- (void)dealloc
{
    [request clearDelegatesAndCancel];
}

- (void) alertStatus:(NSString *)msg :(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}

@end
