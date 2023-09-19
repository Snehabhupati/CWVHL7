public class HL7CodeMappings {
 
    // Country Codes
    public static final Map<String, String> COUNTRY_CODES = new Map<String, String>{
        'United States' => 'US',
            'Canada' => 'CA',
            'United Kingdom' => 'UK'
            // Add more country mappings here
            };
     // Gender Codes
     public static final Map<String, String> GENDER_CODES = new Map<String, String>{
            'Female' => 'F',
            'Male' => 'M',
            'Not applicable' => 'N',   
            'Other' => 'O',
            'Unknown' => 'U'
      };
      //Race Codes
      public static final Map<String, String> RACE_CODES = new Map<String, String>{
            'Black or African American' => '2054-5',
            'Asian/Pacific Islander' => '2028-9',
            'White' => '2106-3',   
            'Other Race' => '2131-1'
      }; 
      //Ethnicity Codes
      public static final Map<String, String> ETHNICITY_CODES = new Map<String, String>{
            'Hispanic' => 'H',
            'Latino' => 'H',    
            'Not Hispanic' => 'N',
            'Not Latino' => 'N',
            'Unknown' => 'U' 
      };     
          
    public static final String 	SendingApplication = 'Elixir'; 
    public static final String SendingFacility = 'Community Wellness'; 
    
    public static String getGenderCode(String genderCode) {
        return GENDER_CODES.containsKey(genderCode) ? GENDER_CODES.get(genderCode) : '';
    }    
    
    public static String getCountryCode(String countryName) {
        return COUNTRY_CODES.containsKey(countryName) ? COUNTRY_CODES.get(countryName) : '';
    }
    
    public static String getRaceCode(String race) {
        return RACE_CODES.containsKey(race) ? RACE_CODES.get(race) : '2131-1';
    }
    public static String getEthnicityCode(String ethnicity) {
        return ETHNICITY_CODES.containsKey(ethnicity) ? ETHNICITY_CODES.get(ethnicity) : '';
    }
    
}