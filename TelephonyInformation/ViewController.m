//
//  ViewController.m
//  TelephonyInformation
//
//  Created by William LaFrance on 11/28/12.
//  Copyright (c) 2012 William LaFrance. All rights reserved.
//

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTElephony/CTCarrier.h>

#import "ViewController.h"

@interface ViewController ()

@property (weak) IBOutlet UILabel *carrierNameLabel;
@property (weak) IBOutlet UILabel *countryCodeLabel;
@property (weak) IBOutlet UILabel *allowsVoipLabel;
@property (weak) IBOutlet UILabel *mobileCountryCodeLabel;
@property (weak) IBOutlet UILabel *mobileNetworkCodeLabel;

@property (strong) CTTelephonyNetworkInfo *networkInfo;

@end

@implementation ViewController

- (void)awakeFromNib
{
    self.networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    
    __weak id selff = self;
    self.networkInfo.subscriberCellularProviderDidUpdateNotifier = ^(CTCarrier *carrier) {
        [selff didChangeCellularProvider:carrier];
    };
    
    // Update with current cellular provider
    [self didChangeCellularProvider:self.networkInfo.subscriberCellularProvider];
}

/**
 * This method is thread safe.
 */
- (void)didChangeCellularProvider:(CTCarrier *)newProvider
{
    NSLog(@"Carrier: %@", newProvider);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.carrierNameLabel.text = newProvider.carrierName;
        self.countryCodeLabel.text = newProvider.isoCountryCode;
        self.allowsVoipLabel.text = newProvider.allowsVOIP ? @"Yes" : @"No";
        self.mobileCountryCodeLabel.text = newProvider.mobileCountryCode;
        self.mobileNetworkCodeLabel.text = newProvider.mobileNetworkCode;
    });
    
}

@end
