//
//  ViewController.h
//  bletest
//
//  Created by Amelia Murphy on 2/8/22.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BluetoothController.h"
#include "ParameterEncoder.h"

@interface ViewController : UIViewController

//@property CBCentralManager *myManager;
//@property CBPeripheral *myDevice;
@property ParameterEncoder *paramEncoder;
@property BluetoothController *ble;


- (IBAction)toggleSwitchValueChanged:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;
- (IBAction)effectSelectOnClick:(id)sender;

    

@end

