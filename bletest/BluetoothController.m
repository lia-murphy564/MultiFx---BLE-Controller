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
                                @"55593157-46a3-4a1d-bd4a-0695bcf09fbb",
                                @"10ca558b-3bc6-42dd-bc85-b1e19c1b5aec",
                                @"af1a3452-b7f5-4185-8ead-358c7cf7362d",
                                @"c0b576e2-baaa-45c6-8d47-ab4867287e0c",
                                @"79f10167-3cfa-462c-9533-7478df079223",
                                @"2c4ac74f-e62d-4eba-b4ff-7f2e6dc0271c",
                                @"f82b1800-b157-4597-bdf6-70df700acb75",
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
    NSLog(@"%@", peripheral.name);
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}



-(void)peripheral:(CBPeripheral*)peripheral
didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
        if ([service.UUID.UUIDString isEqualToString:@"FFE0"]) {
            [peripheral discoverCharacteristics:nil forService:service];
            NSLog(@"connected to service");
        }
    }
}

-(void)peripheral:(CBPeripheral*)peripheral
didDiscoverCharacteristicsForService:(CBService*) service
            error:(NSError *)error {
    for (CBCharacteristic *characteristic in service.characteristics) {
        
        NSData* dat = [[NSData alloc] init];
        NSString* str = [[NSString alloc] init];
        
        //NSMutableDictionary* paramTree = [paramEncoder getParamTreeAsDictionary];
        
        // characteristic 1
        if ([characteristic.UUID.UUIDString containsString:self.characteristicUUIDs[0]]) {
            dat = [self.paramEncoder getParameterAsJSON:0];
           // dat = [@"hello0" dataUsingEncoding:NSUTF8StringEncoding];
        }
        
        else if ([characteristic.UUID.UUIDString containsString:self.characteristicUUIDs[1]]) {
            dat = [self.paramEncoder getParameterAsJSON:1];
            //dat = [@"hello1" dataUsingEncoding:NSUTF8StringEncoding]; // 1st parameter
        }
        
        else if ([characteristic.UUID.UUIDString containsString:self.characteristicUUIDs[2]]) {
            dat = [self.paramEncoder getParameterAsJSON:2];
            //dat = [@"hello2" dataUsingEncoding:NSUTF8StringEncoding]; // 2nd parameter
        }
    
        else if ([characteristic.UUID.UUIDString containsString:self.characteristicUUIDs[3]]) {
            dat = [self.paramEncoder getParameterAsJSON:3];
           // dat = [@"hello3" dataUsingEncoding:NSUTF8StringEncoding]; // 3rd parameter
        }
    
        else if ([characteristic.UUID.UUIDString containsString:self.characteristicUUIDs[4]]) {
            dat = [self.paramEncoder getParameterAsJSON:4];
            //dat = [@"hello4" dataUsingEncoding:NSUTF8StringEncoding]; // 4th parameter
        }
    
        else if ([characteristic.UUID.UUIDString containsString:self.characteristicUUIDs[5]]) {
            dat = [self.paramEncoder getParameterAsJSON:5];
            //dat = [@"hello5" dataUsingEncoding:NSUTF8StringEncoding]; // 5th parameter
        }
        
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        [peripheral writeValue:dat forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
            
        break;
    }
}

@end


