package com.group2.banking.service;

import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;
//import com.google.gson.Gson;
/**
 *
 * @author Jing
 */
public class CaptchaValidation {
    private String sss ="";
    public static boolean verify(String response)
    {
        try
        {
            if(response == null || response.equals("")) return false;
            RestTemplate restTemplate = new RestTemplate();
            String apiUrl = "https://www.google.com/recaptcha/api/siteverify?" + "secret=6LeGATUUAAAAAE_crQpPNlyb4-hI1TqainQ-3eZ9&response=" + response;
            ResponseEntity<String> result = restTemplate.getForEntity(apiUrl, String.class);
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(result.getBody());
            JsonNode name = root.path("success");
            return name.asBoolean();
        }
        catch(Exception e)
        {
            return false;
        }
    }
}
