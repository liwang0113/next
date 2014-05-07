#import "SoapHelper.h"
@implementation SoapHelper
+(NSString*)defaultSoapMesage
{
   NSString *soapBody=@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>%@</soap:Body></soap:Envelope>";
    
    return soapBody;
}

+(NSString*)methodSoapMessage:(NSString*)methodName
{
    NSMutableString *soap=[NSMutableString stringWithFormat:@"<%@ xmlns=\"%@\">",methodName,kDefaultWebServiceNameSpace];
    [soap appendString:@"%@"];
    [soap appendFormat:@"</%@>",methodName];
    return [NSString stringWithFormat:[self defaultSoapMesage],soap];
}

+(NSString*)nameSpaceSoapMessage:(NSString*)space
                      methodName:(NSString*)methodName
{
    NSMutableString *soap=[NSMutableString stringWithFormat:@"<%@ xmlns=\"%@\">",methodName,space];
    [soap appendString:@"%@"];
    [soap appendFormat:@"</%@>",methodName];
    return [NSString stringWithFormat:[self defaultSoapMesage],soap];
}

+(NSString *)arrayToDefaultSoapMessage:(NSArray*)arr
                           methodName:(NSString*)methodName
{
    if ([arr count]==0||arr==nil) {
        return [NSString stringWithFormat:[self methodSoapMessage:methodName],@""];
    }
    NSMutableString *msg=[NSMutableString stringWithFormat:@""];
    for (NSDictionary *item in arr) {
        NSString *key=[[item allKeys] objectAtIndex:0];
        [msg appendFormat:@"<%@>",key];
        [msg appendString:[item objectForKey:key]];
        [msg appendFormat:@"</%@>",key];
    }
    
    return [NSString stringWithFormat:[self methodSoapMessage:methodName],msg];
}

+ (NSString *)getSoapMessageWith:(NSDictionary *)dic
                   andMethodName:(NSString *)methodName
{
    if (dic==nil || dic.count==0) {
        return [NSString stringWithFormat:[self methodSoapMessage:methodName],@""];
    }
    
    NSMutableString *msg = [NSMutableString stringWithFormat:@""];
    NSArray *allKeys = [dic allKeys];
    NSArray *allValues = [dic allValues];
    
    for (int i =0 ; i < allKeys.count; i++) {
        NSString *key = [allKeys objectAtIndex:i];
        NSString *value = [allValues objectAtIndex:i];
        [msg appendFormat:@"<%@>",key];
        [msg appendString:value];
        [msg appendFormat:@"</%@>",key];
    }
    
    return [NSString stringWithFormat:[self methodSoapMessage:methodName],msg];
}

+(NSString*)arrayToNameSpaceSoapMessage:(NSString*)space
                                 params:(NSArray*)arr
                             methodName:(NSString*)methodName
{
    if ([arr count]==0||arr==nil) {
        return [NSString stringWithFormat:[self nameSpaceSoapMessage:space methodName:methodName],@""];
    }
    NSMutableString *msg=[NSMutableString stringWithFormat:@""];
    for (NSDictionary *item in arr) {
        NSString *key=[[item allKeys] objectAtIndex:0];
        [msg appendFormat:@"<%@>",key];
        [msg appendString:[item objectForKey:key]];
        [msg appendFormat:@"</%@>",key];
    }
    
    return [NSString stringWithFormat:[self nameSpaceSoapMessage:space methodName:methodName],msg];
}
@end
