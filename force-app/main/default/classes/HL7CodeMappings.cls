public class HL7CodeMappings {
 
    public static final String 	SendingApplication = 'Elixir'; 
    public static final String SendingFacility = 'Community Wellness'; 
    
    public static String getGenderCode(String genderCode) {
        switch on (genderCode) {
            when 'Female' { return 'F'; }
            when 'Male' { return 'M'; }
            when 'Not applicable' { return 'N'; }
            when 'Other' { return 'O'; }
            when 'Unknown' { return 'U'; }
            when else { return ''; }
        }
    }
    public static String getCountryCode(String countryName) {
        switch on (countryName) {
            when 'United States', 'US','USA' { return 'US'; }
            when 'Canada', 'CA' { return 'CA'; }
            when 'United Kingdom', 'UK' { return 'UK'; }
            when else { return ''; }
        }
    }
    public static String getRaceCode(String race) {
        switch on (race) {
            when 'Black or African American' { return '2054-5'; }
            when 'Asian/Pacific Islander' { return '2028-9'; }
            when 'White' { return '2106-3'; }
            when 'Other Race' { return '2131-1'; }
            when else { return '2131-1'; }
        }
    }
    public static String getEthnicityCode(String ethnicity) {
        switch on (ethnicity) {
            when 'Hispanic', 'Latino' { return 'H'; }
            when 'Not Hispanic', 'Not Latino' { return 'N'; }
            when 'Unknown' { return 'U'; }
            when else { return 'U'; }
        }
    }
}