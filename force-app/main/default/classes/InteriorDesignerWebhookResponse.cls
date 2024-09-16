//THis method is covered by WebHookController_Test
public class InteriorDesignerWebhookResponse {

    public class Field {
        public String id {get;set;} 
        public String type_Z {get;set;} // in json: type
        public String ref {get;set;} 

        public Field(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'type') {
                            type_Z = parser.getText();
                        } else if (text == 'ref') {
                            ref = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Field consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    } 
    
    public class Fields {
        public String id {get;set;} 
        public String title {get;set;} 
        public String type_Z {get;set;}//  in json: type
        public String ref {get;set;} 
        public Properties properties {get;set;} 

        public Fields(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'title') {
                            title = parser.getText();
                        } else if (text == 'type') {
                            type_Z = parser.getText();
                        } else if (text == 'ref') {
                            ref = parser.getText();
                        } else if (text == 'properties') {
                            properties = new Properties(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Fields consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    } 
    
    public class Choice {
        public String label {get;set;} 

        public Choice(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'label') {
                            label = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Choice consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Answers {
        public String type_Z {get;set;} // in json: type
        public Choice choice {get;set;} 
        public Field field {get;set;}  
        public String customdate {get;set;} 
        public Answers(JSONParser parser) {
        customdate ='010101';
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'type') {
                            type_Z = parser.getText();
                        } if (text == 'choice') {
                            choice = new Choice(parser);
                        } else if (text == 'field') {
                            field = new Field(parser); 
                        } if (text == 'customdate') {
                            customdate= parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Answers consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public String event_id {get;set;} 
    public String event_type {get;set;}  
    public Form_response form_response {get;set;} 

    public InteriorDesignerWebhookResponse(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'event_id') {
                        event_id = parser.getText();
                    } else if (text == 'event_type') {
                        event_type = parser.getText();
                    } if (text == 'form_response') {
                        form_response = new Form_response(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class Definition {
        public String id {get;set;} 
        public String title {get;set;} 
        public List<Fields> fields {get;set;} 

        public Definition(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'title') {
                            title = parser.getText();
                        } else if (text == 'fields') {
                            fields = arrayOfFields(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Definition consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    } 
    
    public class Hidden {
        public String email {get;set;} 
        public String interiordesignerid {get;set;} 
        public String name {get;set;} 

        public Hidden(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'email') {
                            email = parser.getText();
                        }  if (text == 'interiordesignerid') {
                            interiordesignerid = parser.getText();
                        }  else if (text == 'name') {
                            name = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Hidden consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Properties {

        public Properties(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        {
                            System.debug(LoggingLevel.WARN, 'Properties consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    } 
    
    public class Form_response {
        public String form_id {get;set;} 
        public String token {get;set;} 
        public String landed_at {get;set;} 
        public String submitted_at {get;set;} 
        public Hidden hidden {get;set;} 
        public Definition definition {get;set;} 
        public List<Answers> answers {get;set;} 

        public Form_response(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'form_id') {
                            form_id = parser.getText();
                        } else if (text == 'token') {
                            token = parser.getText();
                        } else if (text == 'landed_at') {
                            landed_at = parser.getText();
                        } else if (text == 'submitted_at') {
                            submitted_at = parser.getText();
                        } if (text == 'hidden') {
                            hidden = new Hidden(parser);
                        } else if (text == 'definition') {
                            definition = new Definition(parser);
                        } else if (text == 'answers') {
                            answers = arrayOfAnswers(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Form_response consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public static InteriorDesignerWebhookResponse  parse(String json) {
        json = json.replace('"date":', '"customDate":');
        System.debug(json);
        
        System.JSONParser parser = System.JSON.createParser(json);
        return new InteriorDesignerWebhookResponse  (parser);
    }
    
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT ||
                curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }
    




    private static List<Fields> arrayOfFields(System.JSONParser p) {
        List<Fields> res = new List<Fields>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Fields(p));
        }
        return res;
    } 






    public static List<Answers> arrayOfAnswers(System.JSONParser p) {
        List<Answers> res = new List<Answers>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Answers(p));
        }
        return res;
    }
}