//
//  BluetoothController.m
//  bletest
//
//  Created by Amelia Murphy on 2/14/22.
//

#import <Foundation/Foundation.h>
#import "BluetoothController.h"
#import "ParameterEncoder.h"

@interface BluetoothController ()

@property NSArray* characteristicUUIDs;
@property ParameterEncoder* paramEncoder;
@property CBService* myService;

@end

@implementation BluetoothController

@synthesize myManager;
@synthesize myDevice;
@synthesize data;

- (void)initBLE {
    myManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    self.paramEncoder = [[ParameterEncoder alloc] init];
    self.data = [[NSData alloc] init];
    self.characteristicUUIDs = [[NSArray alloc] initWithObjects:
                                @"FFE1",
                                @"FFE1",
                                @"FFE1",
                                @"FFE1",
                                @"FFE1",
                                @"FFE1",
                                @"FFE1",
                                nil];
}

//- (void)setData:(NSData*)dataIn {
//    self.data = dataIn;
//}

- (void)centralManagerDidUpdateState:(CBCentralManager*)central {
    [self beginSearching];
}

- (void)beginSearching {
    switch ([myManager state]) {
        case CBManagerStateUnknown:
            NSLog(@"State Unknown");
            break;
        case CBManagerStateResetting:
            NSLog(@"State Resetting");
            break;
        case CBManagerStateUnsupported:
            NSLog(@"State Unsupported");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"State Unauthorized");
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"State Powered Off");
            break;
        case CBManagerStatePoweredOn:
            NSLog(@"State Powered On");
            [myManager scanForPeripheralsWithServices:nil options:nil];
            break;
        default:
            NSLog(@"Everything is sadly broken sad rip BOI");
    }
}

- (void)centralManager:(CBCentralManager*)central
didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary*)advertisementData
                  RSSI:(NSNumber*)RSSI {
    NSLog(@"%@", peripheral.name);
    
    if ([peripheral.name isEqualToString:@"hello"]){
        self.myDevice = peripheral;
        [myManager connectPeripheral:peripheral options:nil];
    }
}

- (void)centralManager:(CBCentralManager*)central
didConnectPeripheral:(CBPeripheral*)peripheral {
    NSLog(@"periph name: %@", peripheral.name);
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}



-(void)peripheral:(CBPeripheral*)peripheral
didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
        if ([service.UUID.UUIDString isEqualToString:@"FFE0"]) {
            [peripheral discoverCharacteristics:nil forService:service];
            NSLog(@"connected to service");
            self.myService = service;
        }
    }
}

-(void)writeDataOverBLE:(NSData*)data {
    //CBPeripheral* peripheral = self.myDevice;
    
    //CBCharacteristic* characteristic = [CBCharacteristic alloc];
    for (CBCharacteristic *characteristic in self.myService.characteristics) {
        if ([characteristic.UUID.UUIDString containsString:@"FFE1"]) {
            [self.myDevice setNotifyValue:YES forCharacteristic:characteristic];
            NSLog(@"%@", data);
            [self.myDevice writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
        }
    }
    
}

-(void)peripheral:(CBPeripheral*)peripheral
didDiscoverCharacteristicsForService:(CBService*) service
            error:(NSError *)error {

    //NSString* str = [[NSString alloc] init];
    //NSData* dat = [[NSData alloc] init];
    
    for (CBCharacteristic *characteristic in service.characteristics) {
//        NSData* dat = [[NSData alloc] init];
//        NSString* str = [[NSString alloc] init];
        
        //NSMutableDictionary* paramTree = [paramEncoder getParamTreeAsDictionary];
        
        // characteristic 1
        if ([characteristic.UUID.UUIDString containsString:@"FFE1"]) {
                //NSLog(@"OIHOIH");
            
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                NSData* data = [@"|| Device Connected || " dataUsingEncoding:NSUTF8StringEncoding];
                //NSData* data = [self.paramEncoder getParameterTreeAsJSON];

                //NSData* j = [[NSData alloc] initWithData:[self.paramEncoder getParameterTreeAsJSON]];
                //NSData* dat = [self.paramEncoder getParameterTreeAsJSON];
                //str = [NSJSONSerialization JSONObjectWithData:j options:NSJSONWritingWithoutEscapingSlashes error:nil];
                //dat = [str dataUsingEncoding:NSUTF8StringEncoding];
                //NSLog(@"%s", str);
                [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
        }
        break;
        
            //dat = [self.paramEncoder getParameterAsJSON:0];
 
           // dat = [@"hello0" dataUsingEncoding:NSUTF8StringEncoding];
        
        
//        else if ([characteristic.UUID.UUIDString containsString:self.characteristicUUIDs[1]]) {
//            //dat = [self.paramEncoder getParameterAsJSON:1];
//            dat = [@"hello1" dataUsingEncoding:NSUTF8StringEncoding]; // 1st parameter
//        }
//
//        else if ([characteristic.UUID.UUIDString containsString:self.characteristicUUIDs[2]]) {
//            dat = [self.paramEncoder getParameterAsJSON:2];
//            //dat = [@"hello2" dataUsingEncoding:NSUTF8StringEncoding]; // 2nd parameter
//        }
//
//        else if ([characteristic.UUID.UUIDString containsString:self.characteristicUUIDs[3]]) {
//            dat = [self.paramEncoder getParameterAsJSON:3];
//           // dat = [@"hello3" dataUsingEncoding:NSUTF8StringEncoding]; // 3rd parameter
//        }
//
//        else if ([characteristic.UUID.UUIDString containsString:self.characteristicUUIDs[4]]) {
//            dat = [self.paramEncoder getParameterAsJSON:4];
//            //dat = [@"hello4" dataUsingEncoding:NSUTF8StringEncoding]; // 4th parameter
//        }
//
//        else if ([characteristic.UUID.UUIDString containsString:self.characteristicUUIDs[5]]) {
//            dat = [self.paramEncoder getParameterAsJSON:5];
//            //dat = [@"hello5" dataUsingEncoding:NSUTF8StringEncoding]; // 5th parameter
//        }
        
        //dat = [self.paramEncoder getParameterTreeAsJSON];
        //NSLog(@"%s", dat);
        //NSData* o = [@"" dataUsingEncoding:NSUTF8StringEncoding];
        

    }
}

@end


