//
//  BluetoothController.h
//  bletest
//
//  Created by Amelia Murphy on 2/14/22.
//

#ifndef BluetoothController_h
#define BluetoothController_h

#import <CoreBluetooth/CoreBluetooth.h>

@interface BluetoothController : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property CBCentralManager *myManager;
@property CBPeripheral *myDevice;
@property (nonatomic) NSData* data;
@property (nonatomic) NSData* dataBuffer;

- (void)initBLE;
- (void)setData:(NSData*)dataIn;

@end

#endif /* BluetoothController_h */
