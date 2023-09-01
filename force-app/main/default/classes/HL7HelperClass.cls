/*
Name: Manas Bharadwaj
Profile: Salesforce Developer
Company: Mirketa Inc
*/

public class HL7HelperClass {
    
    public static string getEncodingCharacters() {        
        return '^~\\&';        
    }
    
    //Deprecated
    public static String replaceSpecialCharacters(String fieldValue) {
        fieldValue = fieldValue.replace('\\', '\\E\\');
        fieldValue = fieldValue.replace('|', '\\F\\');
        fieldValue = fieldValue.replace('~', '\\R\\');
        fieldValue = fieldValue.replace('^', '\\S\\');
        fieldValue = fieldValue.replace('&', '\\T\\');
        return fieldValue;
    }
    //Deprecated
    public static String truncateString(String input, Integer maxLength) {
        if (input.length() > maxLength) {
            return input.substring(0, maxLength);
        }
        return input;
    }
    //Deprecated
    public static String encodeAndTruncateString(String fieldValue, Integer maxLength) {
        fieldValue = fieldValue.replace('\\', '\\E\\');
        fieldValue = fieldValue.replace('|', '\\F\\');
        fieldValue = fieldValue.replace('~', '\\R\\');
        fieldValue = fieldValue.replace('^', '\\S\\');
        fieldValue = fieldValue.replace('&', '\\T\\');
        
        // Truncating the encoded string
        if (fieldValue.length() > maxLength) {
            if(maxLength != 0 ) fieldValue = fieldValue.substring(0, maxLength);
        }
        return fieldValue;
    }
    
    //Deprecated
    public static String checkNull(String strValue) {
        return strValue != null ? strValue : '';
    }
    public static String analyze(String fieldValue, Integer maxLength) {
        
        //1. Null Check
        if((fieldValue != null ? fieldValue : '' ) == '' ){
            return '';
        }
        
        //2. Encode Replacement
        fieldValue = fieldValue.replace('\\', '\\E\\');
        fieldValue = fieldValue.replace('|', '\\F\\');
        fieldValue = fieldValue.replace('~', '\\R\\');
        fieldValue = fieldValue.replace('^', '\\S\\');
        fieldValue = fieldValue.replace('&', '\\T\\');
        
        // 3. Truncating the encoded string
        if (fieldValue.length() > maxLength) {
            if(maxLength != 0 ) fieldValue = fieldValue.substring(0, maxLength);
        }
        return fieldValue;
    }
}