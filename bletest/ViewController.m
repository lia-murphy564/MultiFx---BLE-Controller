//
//  ViewController.m
//  bletest
//
//  Created by Amelia Murphy on 2/8/22.
//

#import "ViewController.h"
#import "ParameterEncoder.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UISlider *potSlider1;
@property (strong, nonatomic) IBOutlet UISlider *potSlider2;
@property (strong, nonatomic) IBOutlet UISlider *potSlider3;
@property (strong, nonatomic) IBOutlet UISlider *potSlider4;
@property (strong, nonatomic) IBOutlet UISwitch *toggleSwitch1;
@property (strong, nonatomic) IBOutlet UISwitch *toggleSwitch2;
@property (strong, nonatomic) IBOutlet UISwitch *bypassModeSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *bypassSwitch;
@property (strong, nonatomic) IBOutlet UIButton *effectSelectLeft;
@property (strong, nonatomic) IBOutlet UIButton *effectSelectRight;
@property (strong, nonatomic) IBOutlet UILabel *effectNameLabel;

@property int effectState;

@end

@implementation ViewController

@synthesize paramEncoder;
@synthesize ble;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.effectState = 0;

    paramEncoder = [[ParameterEncoder alloc] init];

    [paramEncoder addParameterWithLabel:@"Pot 1" andValue:0 andType:@"Pot"];
    [paramEncoder addParameterWithLabel:@"Pot 2" andValue:0 andType:@"Pot"];
    [paramEncoder addParameterWithLabel:@"Pot 3" andValue:0 andType:@"Pot"];
    [paramEncoder addParameterWithLabel:@"Pot 4" andValue:0 andType:@"Pot"];
    [paramEncoder addParameterWithLabel:@"Switch 1" andValue:0 andType:@"Switch"];
    [paramEncoder addParameterWithLabel:@"Switch 2" andValue:0 andType:@"Switch"];
    [paramEncoder addParameterWithLabel:@"Bypass Mode" andValue:0 andType:@"Switch"];
    [paramEncoder addParameterWithLabel:@"Bypass" andValue:0 andType:@"Switch"];
//    [paramEncoder addParameterWithLabel:@"Effect Select Left" andValue:0 andType:@"Select"];
//    [paramEncoder addParameterWithLabel:@"Effect Select Right" andValue:0 andType:@"Select"];
    [paramEncoder addParameterWithLabel:@"Effect State" andValue:0 andType:@"State"];
    
    [paramEncoder printParameterTree];
    
    ble = [[BluetoothController alloc] init];
    [ble initBLE];
    ble.data = [paramEncoder getParameterTree];
    //ble.dataBuffer = [paramEncoder]
    //[ble setData:[paramEncoder getParameterTree]];

}

- (IBAction)toggleSwitchValueChanged:(id)sender {

    NSInteger tag = [sender tag];
    bool state = false;
    
    if (tag == 5)
        state = self.toggleSwitch1.isOn;
    else if (tag == 6)
        state = self.toggleSwitch2.isOn;
    else if (tag == 7)
        state = self.bypassModeSwitch.isOn;
    else if (tag == 8)
        state = self.bypassSwitch.isOn;
        
    [paramEncoder setParameterValue:state withIndex:tag];
    [paramEncoder printParameterTree];
}

- (IBAction)sliderValueChanged:(id)sender {

    NSInteger tag = [sender tag];
    NSInteger val = 0;
    
    if (tag == 1)
        val = self.potSlider1.value;
    else if (tag == 2)
        val = self.potSlider2.value;
    else if (tag == 3)
        val = self.potSlider3.value;
    else if (tag == 4)
        val = self.potSlider4.value;
        
    [paramEncoder setParameterValue:val withIndex:tag];
    [paramEncoder printParameterTree];
}

- (IBAction)effectSelectOnClick:(id)sender {
    NSInteger tag = [sender tag];
    if (tag == 0) { // left button
        if (self.effectState != 0)
            self.effectState--;
    }
    else if (tag == 1) { // right button
        self.effectState++;
    }
    
    [paramEncoder setParameterValue:self.effectState withIndex:9];
    
    self.effectNameLabel.text = [NSString stringWithFormat:@"Effect %i", self.effectState];
    NSLog(@"%i", self.effectState);
    [paramEncoder printParameterTree];
}

@end



//- (void)centralManagerDidUpdateState:(CBCentralManager*)central {
//    [self beginSearching];
//}
//
//- (void)beginSearching {
//    switch ([myManager state]) {
//        case CBManagerStateUnknown:
//            NSLog(@"State Unknown");
//            break;
//        case CBManagerStateResetting:
//            NSLog(@"State Resetting");
//            break;
//        case CBManagerStateUnsupported:
//            NSLog(@"State Unsupported");
//            break;
//        case CBManagerStateUnauthorized:
//            NSLog(@"State Unauthorized");
//            break;
//        case CBManagerStatePoweredOff:
//            NSLog(@"State Powered Off");
//            break;
//        case CBManagerStatePoweredOn:
//            NSLog(@"State Powered On");
//            [myManager scanForPeripheralsWithServices:nil options:nil];
//            break;
//        default:
//            NSLog(@"Everything is sadly broken sad rip BOI");
//    }
//}
//
//- (void)centralManager:(CBCentralManager*)central
//didDiscoverPeripheral:(CBPeripheral *)peripheral
//     advertisementData:(NSDictionary*)advertisementData
//                  RSSI:(NSNumber*)RSSI {
//    NSLog(@"%@", peripheral.name);
//
//    if ([peripheral.name isEqualToString:@"hello"]){
//        self.myDevice = peripheral;
//        [myManager connectPeripheral:peripheral options:nil];
//    }
//}
//
//- (void)centralManager:(CBCentralManager*)central
//didConnectPeripheral:(CBPeripheral*)peripheral {
//    NSLog(@"%@", peripheral.name);
//    peripheral.delegate = self;
//    [peripheral discoverServices:nil];
//}
//
//-(void)peripheral:(CBPeripheral*)peripheral
//didDiscoverServices:(NSError *)error {
//    for (CBService *service in peripheral.services) {
//        if ([service.UUID.UUIDString isEqualToString:@"FFE0"]) {
//            [peripheral discoverCharacteristics:nil forService:service];
//            NSLog(@"connected to service");
//        }
//    }
//}
//
//-(void)peripheral:(CBPeripheral*)peripheral
//didDiscoverCharacteristicsForService:(CBService*) service
//            error:(NSError *)error {
//    for (CBCharacteristic *characteristic in service.characteristics) {
//        if ([characteristic.UUID.UUIDString containsString:@"FFE1"]) {
//            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
//
//            //NSData* data = [paramEncoder encodeValue:@"TEST"];
//
//            //NSData *data = [@"hello" dataUsingEncoding:NSUTF8StringEncoding];
//            //NSLog(@"connected to characteristic with data: %@", data);
//            //[peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
//            break;
//        }
//    }
//}
