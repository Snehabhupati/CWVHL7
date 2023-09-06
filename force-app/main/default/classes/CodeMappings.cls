public class CodeMappings {
    
    
    
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
                            
    public static final String 	SendingApplication = 'Elixir'; 
    public static final String SendingFacility = 'Community Wellness'; 
    
    public static String getGenderCode(String genderCode) {
        return GENDER_CODES.containsKey(genderCode) ? GENDER_CODES.get(genderCode) : '';
    }
    
    
    public static String getCountryCode(String countryName) {
        return COUNTRY_CODES.containsKey(countryName) ? COUNTRY_CODES.get(countryName) : '';
    }
}