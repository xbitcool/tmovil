//
//  DetalleMedicosController.m
//  tmovil
//
//  Created by Christian Helmut on 11/5/13.
//  Copyright (c) 2013 TCORP. All rights reserved.
//

#import "DetalleMedicosController.h"

@interface DetalleMedicosController ()

@end

@implementation DetalleMedicosController
@synthesize ratingValue, starControls, starLabel, DatosDoctor, request;

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
	ratingValue = [NSArray arrayWithObjects:@"Sin Calificar",@"No me gusto", @"Malo", @"Regular", @"Es bueno", @"Muy Bueno", nil];
    starControls.delegate = self;
    [self.nombre setText:[NSString stringWithFormat:@"%@",       [DatosDoctor objectForKey:@"NOMBRE"]]];
    [self.especialidad setText:[NSString stringWithFormat:@"%@", [DatosDoctor objectForKey:@"ESPECIALIDAD"]]];
    [self.telefono setText:[NSString stringWithFormat:@"%@",     [DatosDoctor objectForKey:@"TELEFONO"]]];
    [self.correo setText:[NSString stringWithFormat:@"%@",       [DatosDoctor objectForKey:@"CORREO"]]];
    [self.horario setText:[NSString stringWithFormat:@"%@",      [DatosDoctor objectForKey:@"HORARIO"]]];
    [self.lugar setTitle:[NSString stringWithFormat:@"%@",       [DatosDoctor objectForKey:@"LUGAR"]] forState:UIControlStateNormal];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.ScrollContenido layoutIfNeeded];
    self.ScrollContenido.contentSize = self.ContenidoView.bounds.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)IrUbicacionMapa:(id)sender
{
    [self performSegueWithIdentifier:@"SegueToMap" sender:sender];
}

//StarRating Delegate------------------------------------------------------------------------------------------------------------------------
- (void)starRatingControl:(StarRatingControl *)control willUpdateRating:(NSUInteger)rating {
    //Empieza a hacer la actualizacion de cambio
	starLabel.text = [ratingValue objectAtIndex:rating];
}

- (void)starRatingControl:(StarRatingControl *)control didUpdateRating:(NSUInteger)rating {
    //Finalizó el cambio de Rating
	starLabel.text = [ratingValue objectAtIndex:rating];
    
    //Implementar Envio de la nueva calificación
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self UpdateCalificacion:rating];
}

// Delegación de Sesgamiento entre Interfaces  -------------------------------------------------------------------------------------------
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MapLocationController *vc       = [segue destinationViewController];
    vc.Location = [DatosDoctor objectForKey:@"MAPA"];
}
//-------------------------------------------------------------------------------------------------------------------------------------------

- (void) UpdateCalificacion:(NSInteger)newRating
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://200.119.214.00/Tmovil/%d", newRating]];
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}
                  
                  
- (void)requestFinished:(ASIHTTPRequest *)requestL {
    NSString *responseString = [requestL responseString];
    // Implementar algo si se tiene alguna respuesta del servidor
    // despues de haber calificado al doctor
    
    //-----------------------------------------------------------
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)requestFailed:(ASIHTTPRequest *)requestL
{
    NSError *error = [requestL error];
    [self alertStatus:@"Oops no se pudo obtener menú, Intentelo más tarde" :[error localizedDescription]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
