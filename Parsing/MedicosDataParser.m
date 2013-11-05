//
//  MedicosDataParser.m
//  tmovil
//
//  Created by Christian Helmut on 11/5/13.
//  Copyright (c) 2013 TCORP. All rights reserved.
//

#import "MedicosDataParser.h"

@implementation MedicosDataParser


//Este método define la información que se va a pasar a la interface Detalle
- (NSMutableDictionary *) dataModelForSegue:(NSMutableArray *) dataModel :(NSIndexPath *) indexPath
{
                                       //<-------     ESPECIALIDAD             -->  <----      MEDICO      --->
    NSMutableDictionary *DatosDoctor = [[dataModel objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return DatosDoctor;
}

//Este método construye el << Array de Diccionarios de Diccionarios >>
/*
 Desde JBOSS desplegar la información ordenada por Especialidades 
 y Dentro de cada especialidad el array de Doctores tambien Ordenado.
 
 Confirmar que la información llega de esta manera o
 reimplementar la forma de leer el dato JSON
 
              [Especialidad A]:{
                               Diccionario<Doctor>
                               ..
                               ..
                             }
              [Especialidad B]:{
                               Diccionario<Doctor>
                               ..
                               ..
                             }
*/
- (NSMutableArray *) parseFetchedData:(NSArray *) JSONdata
{
    NSMutableArray *parsingJSON = [[NSMutableArray alloc] init];
    //Implementar la información JSON que llega del Servidor y
    //cargarla en la variable parsingJSON que será un << Array de Diccionarios de Diccionarios >>
    for (NSDictionary *Especialidades in JSONdata) [parsingJSON addObject:Especialidades];
    return parsingJSON;
}

- (NSString *) GroupHeadsNombre:(NSMutableArray *)dataModel :(NSUInteger) section
{
   return [NSString stringWithFormat:@"%@", [dataModel objectAtIndex:section]];
}

- (NSInteger) cantidadForGroup:(NSMutableArray *)dataModel
{
    return [dataModel count]; //Se cuenta a nivel Especialidades
}

- (NSInteger) cantidadFilasForGroup:(NSMutableArray *)dataModel :(NSUInteger) section
{
    return [[dataModel objectAtIndex:section] count]; //Se cuenta segun la especialidad la cantidad de Medicos
}

- (UITableViewCell *) dataForGroup:(ExpandableTableView *)tableView :(NSMutableArray *)dataModel :(NSUInteger) section
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EspecialidadCellGroup"];
    UILabel *Especialidad = (UILabel *)[cell.contentView viewWithTag:100];
    Especialidad.text = [NSString stringWithFormat:@"%@", [dataModel objectAtIndex:section]];
    return cell;
}

- (UITableViewCell *) dataForRow:(UITableView *)tableView :(NSMutableArray *)dataModel :(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSString *nibCELL;
    if ([[UIDevice currentDevice].model hasPrefix:@"iPhone"]) nibCELL = @"MedicoCell_iphone";
                                                              else
                                                              nibCELL = @"MedicoCell_ipad"; //<--- Crear Celda
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibCELL owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    
    NSInteger Grupo = indexPath.section;
    NSInteger pos   = indexPath.row;
    
    NSDictionary *item = [dataModel objectAtIndex:Grupo];
    
    
    UILabel *Doctor = (UILabel *)[cell.contentView viewWithTag:100];
    StarRatingControl *Calificacion = (StarRatingControl *)[cell.contentView viewWithTag:101];
    
    /*
     Hacer el parsing para navegar a traves de los diccionarios
     
     
    Doctor.text = NombreDoctor;
    Calificacion.rating = Calificacion;
    */
    
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

@end
