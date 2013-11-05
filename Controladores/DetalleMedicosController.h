//
//  DetalleMedicosController.h
//  tmovil
//
//  Created by Christian Helmut on 11/5/13.
//  Copyright (c) 2013 TCORP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapLocationController.h"
#import "StarRatingControl.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface DetalleMedicosController : UIViewController <StarRatingDelegate>{
    ASIFormDataRequest *request;
}

@property (nonatomic, retain) ASIFormDataRequest *request;

//Datos del Medico pasador por Segue
@property (strong) NSMutableDictionary *DatosDoctor;

//Propiedades
@property (strong) NSArray *ratingValue;
@property (strong, nonatomic) IBOutlet UIView *ContenidoView;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollContenido;
@property (strong, nonatomic) IBOutlet UILabel *starLabel;
@property (weak) IBOutlet StarRatingControl *starControls;

@property (strong, nonatomic) IBOutlet UILabel *nombre;
@property (strong, nonatomic) IBOutlet UILabel *especialidad;
@property (strong, nonatomic) IBOutlet UILabel *telefono;
@property (strong, nonatomic) IBOutlet UILabel *correo;
@property (strong, nonatomic) IBOutlet UILabel *horario;
@property (strong, nonatomic) IBOutlet UIButton *lugar;

//Acciones
- (IBAction)IrUbicacionMapa:(id)sender;

@end
