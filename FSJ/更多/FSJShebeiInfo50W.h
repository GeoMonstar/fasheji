//
//  FSJShebeiInfo50W.h
//  FSJ
//
//  Created by Monstar on 2017/3/17.
//  Copyright © 2017年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSJJiankongBase.h"
@interface FSJShebeiInfo50W : FSJJiankongBase
/**
 *  @brief 设备纬度指示（0：北纬，1：南纬）
 */
@property (nonatomic, copy)NSString *latFlag;
/**
 *  @brief 高度
 */
@property (nonatomic, copy)NSString *altitude;
/**
 *  @brief 产品序列号
 */
@property (nonatomic, copy)NSString *serialNum;

/**
 *  @brief 地点台站编码
 */
@property (nonatomic, copy)NSString *addrNo;
/**
 *  @brief 产品型号
 */
@property (nonatomic, copy)NSString *modelNum;
/**
 *  @brief 生产厂家
 */
@property (nonatomic, copy)NSString *manuFactory;
/**
 *  @brief 设备名称
 */
@property (nonatomic, copy)NSString *devName;
/**
 *  @brief 设备类型
 */
@property (nonatomic, copy)NSString *type;
/**
 *  @brief 设备经度
 */
@property (nonatomic, copy)NSString *lonVal;
/**
 *  @brief 设备时间
 */
@property (nonatomic, copy)NSString *devTime;
/**
 *  @brief 设备经度指示  0：东经，1：西经
 */
@property (nonatomic, copy)NSString *lonFlag;
/**
 *  @brief cpu序列号
 */
@property (nonatomic, copy)NSString *cpuNo;
/**
 *  @brief 发射机功率等级
 */
@property (nonatomic, copy)NSString *transDev;

/**
 *  @brief 硬件版本号
 */
@property (nonatomic, copy)NSString *hardwareVersion;

/**
 *  @brief 设备纬度
 */
@property (nonatomic, copy)NSString *latVal;

/**
 *  @brief id
 */
@property (nonatomic, copy)NSString *idStr;

/**
 *  @brief 软件版本号
 */
@property (nonatomic, copy)NSString *softwareVersion;

/**
 *  @brief  冷却方式
 */
@property (nonatomic, copy)NSString *devCold;


@end
@interface FSJTongxinjiekou50W : FSJJiankongBase



@property (nonatomic, copy)NSString *ipAddr;

@property (nonatomic, copy)NSString *deviceId;

@property (nonatomic, copy)NSString *macAddr;

@property (nonatomic, copy)NSString *isDHCP;

@property (nonatomic, copy)NSString *ipMask;

@property (nonatomic, copy)NSString *ipGateway;

@property (nonatomic, copy)NSString *localIp;

@end
@interface FSJZhengjistatus50W : FSJJiankongBase
@property (nonatomic, copy)NSString *tProtectTemp;

@property (nonatomic, copy)NSString *tProtectreflect;

@property (nonatomic, copy)NSString *tWorkLate;

@property (nonatomic, copy)NSString *tEnviTemp;

@property (nonatomic, copy)NSString *tRfInputVal;

@property (nonatomic, copy)NSString *tSwr;

@property (nonatomic, copy)NSString *tInputPowThreHigh;

@property (nonatomic, copy)NSString *tWorkAuto;

@property (nonatomic, copy)NSString *tInputPowThreLow;

@property (nonatomic, copy)NSString *tAmpCuur;

@property (nonatomic, copy)NSString *tRfOutputVal;

@property (nonatomic, copy)NSString *tAGC;

@property (nonatomic, copy)NSString *tRefPowTop;

@property (nonatomic, copy)NSString *tTempThre;

@property (nonatomic, copy)NSString *tCpuNo;

@property (nonatomic, copy)NSString *tOutputPow;

@property (nonatomic, copy)NSString *tRefPow;

@property (nonatomic, copy)NSString *tProtectCurrent;

@property (nonatomic, copy)NSString *tOverloadVol;

@property (nonatomic, copy)NSString *tFrontCurr;

@property (nonatomic, copy)NSString *tCommStatus;

@property (nonatomic, copy)NSString *tProtect;

@property (nonatomic, copy)NSString *tSetOutputPow;

@property (nonatomic, copy)NSString *tAmpVol;

@property (nonatomic, copy)NSString *tFrontVol;

@property (nonatomic, copy)NSString *tRfRefVal;

@end
@interface FSJZhengjicontrol50W : FSJJiankongBase

@property (nonatomic, copy)NSString *transOn;

@property (nonatomic, copy)NSString *maxOnOff;

@property (nonatomic, copy)NSString *isAutomation;

@property (nonatomic, copy)NSString *masterControl;

@property (nonatomic, copy)NSString *ipMask;

@property (nonatomic, copy)NSString *ipGateway;

@property (nonatomic, copy)NSString *localIp;

@end

@interface FSJShebeijiegoul50W : FSJJiankongBase

@property (nonatomic, copy)NSString *inputNum;

@property (nonatomic, copy)NSString *actuatorNum;

@property (nonatomic, copy)NSString *outputNum;

@property (nonatomic, copy)NSString *amplifierNum;

@property (nonatomic, copy)NSString *powerNum;


@end


@interface FSJDianyuan50W : FSJJiankongBase

@property (nonatomic, copy)NSString *powersDirectVol;

@property (nonatomic, copy)NSString *powersDirectCurr;



@end


//"ampPowVol": "",  ---功率管工作电压
//"ampTemperature": "",   --功放温度
//"ampOutputPow": 24.43,   --输出功率
//"ampCurr2": "",       --功率管电流2
//"ampInputPow": 0.47,   ---输入功率
//"ampCurr1": "",    --功率管电流1
//"ampFan1": "",    风扇转速1
//"ampFan2": "",   风扇转速2
//"ampFan3": "",   风扇转速3
//"ampDrivVol": "",   推动管工作电压
//"ampFan4": "",   风扇转速4
//"ampDrivCurr": ""    推动管工作电流

@interface FSJGongfang50W : FSJJiankongBase

@property (nonatomic, copy)NSString *ampPowVol;

@property (nonatomic, copy)NSString *ampTemperature;

@property (nonatomic, copy)NSString *ampOutputPow;

@property (nonatomic, copy)NSString *ampCurr2;

@property (nonatomic, copy)NSString *ampInputPow;

@property (nonatomic, copy)NSString *ampCurr1;

@property (nonatomic, copy)NSString *ampFan1;

@property (nonatomic, copy)NSString *ampFan2;

@property (nonatomic, copy)NSString *ampFan3;

@property (nonatomic, copy)NSString *ampDrivVol;

@property (nonatomic, copy)NSString *ampFan4;

@property (nonatomic, copy)NSString *ampDrivCurr;


@end
@interface FSJJiliqi50W : FSJJiankongBase


@property (nonatomic, copy)NSString *eInputCodeRate;

@property (nonatomic, copy)NSString *eRFOutputAtte;

@property (nonatomic, copy)NSString *eRFOutputSwitch;

@property (nonatomic, copy)NSString *eSingleFreNetAddr;

@property (nonatomic, copy)NSString *eType;

@property (nonatomic, copy)NSString *eTemper;

@property (nonatomic, copy)NSString *eCpuNum;

@property (nonatomic, copy)NSDictionary *eStatus;


@property (nonatomic, copy)NSString *str0;

@property (nonatomic, copy)NSString *str1;

@property (nonatomic, copy)NSString *str2;

@property (nonatomic, copy)NSString *str3;

@property (nonatomic, copy)NSString *str4;

@property (nonatomic, copy)NSString *str5;

@property (nonatomic, copy)NSString *str6;

@property (nonatomic, copy)NSString *str7;

@property (nonatomic, copy)NSString *str8;

@property (nonatomic, copy)NSString *str9;

@property (nonatomic, copy)NSString *str10;

@property (nonatomic, copy)NSString *str11;

@property (nonatomic, copy)NSString *str12;

@property (nonatomic, copy)NSString *str13;

@property (nonatomic, copy)NSString *str14;

@property (nonatomic, copy)NSString *str15;

@property (nonatomic, copy)NSString *str16;

@property (nonatomic, copy)NSString *str17;

@property (nonatomic, copy)NSString *str18;

@end
