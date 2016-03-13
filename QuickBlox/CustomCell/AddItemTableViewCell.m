//
//  AddItemTableViewCell.m
//  QuickBlox
//
//  Created by Tamqn on 2/1/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "AddItemTableViewCell.h"

@implementation AddItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupDataForCell {
    self.nameTextField.text = self.modelItem.name;
    self.dateInputTextField.text = [CommonFeature convertDateToString:[CommonFeature convertLongtimeToDate:[self.modelItem.dateInput doubleValue]] withFormat:format_date_type_dd_mm_yyyy];
    self.dateOutputTextField.text = [CommonFeature convertDateToString:[CommonFeature convertLongtimeToDate:[self.modelItem.dateOutput doubleValue]] withFormat:format_date_type_dd_mm_yyyy];
    self.moneyInputTextField.text = self.modelItem.moneyInput;
    self.moneyOutputTextField.text = self.modelItem.moneyOutput;
    self.qrCodeTextField.text = self.modelItem.qrCode;
    self.infoTextView.text = self.modelItem.info;
}

- (BOOL)isNameTextField {
    return (self.nameTextField.text != nil && self.nameTextField.text.length > 0);
}

- (BOOL)isDateInputTextField {
    return (self.dateInputTextField.text != nil && self.dateInputTextField.text.length > 0);
}

- (BOOL)isDateOutputTextField {
    return (self.dateOutputTextField.text != nil && self.dateOutputTextField.text.length > 0);
}

- (BOOL)isMoneyInputTextField {
    return (self.moneyInputTextField.text != nil && self.moneyInputTextField.text.length > 0);
}

- (BOOL)isMoneyOutputTextField {
    return (self.moneyOutputTextField.text != nil && self.moneyOutputTextField.text.length > 0);
}

- (BOOL)isQrCodeTextField {
    return (self.qrCodeTextField.text != nil && self.qrCodeTextField.text.length > 0);
}

- (BOOL)isInfoTextView {
    return (self.infoTextView.text != nil && self.infoTextView.text.length > 0);
}

- (void)actionValidInput:(void(^)(BOOL isValid))success {
    BOOL isValidInput = YES;
    if (![self isNameTextField]) {
        self.nameTextField.backgroundColor = [UIColor redColor];
        isValidInput = NO;
    }else{
        self.nameTextField.backgroundColor = [UIColor whiteColor];
        self.modelItem.name = self.nameTextField.text;
    }
    
    if (![self isMoneyInputTextField]) {
        self.moneyInputTextField.backgroundColor = [UIColor redColor];
        isValidInput = NO;
    }else{
        self.moneyInputTextField.backgroundColor = [UIColor whiteColor];
        self.modelItem.moneyInput = self.moneyInputTextField.text;
    }
    
    if (![self isMoneyOutputTextField]) {
        self.moneyOutputTextField.backgroundColor = [UIColor redColor];
        isValidInput = NO;
    }else{
        self.moneyOutputTextField.backgroundColor = [UIColor whiteColor];
        self.modelItem.moneyOutput = self.moneyOutputTextField.text;
    }
    
    if (![self isQrCodeTextField]) {
        self.qrCodeTextField.backgroundColor = [UIColor redColor];
        isValidInput = NO;
    }else{
        self.qrCodeTextField.backgroundColor = [UIColor whiteColor];
        self.modelItem.qrCode = self.qrCodeTextField.text;
    }
    self.modelItem.info = self.infoTextView.text;
    
    if (success) {
        success(isValidInput);
    }
}
@end
