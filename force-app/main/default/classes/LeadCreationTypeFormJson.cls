public class LeadCreationTypeFormJson{
        public String event_type;
        public form_response form_response;
        public String event_id;
        
    public class hidden{
        public String email;
        public String interiordesigneremail;
        public String phone;
        public String city;
        public String testlead;
    }
    public class form_response{
        public String submitted_at;
        public hidden hidden;
        public String landed_at;
        public definition definition;
        public String token;
        public list<answers> answers;
        public String form_id;
    }
    public class fields{
        public String id;
        public properties properties;
        public String type;
        public String ref;
        public String title;
    }
    public class field{
        public String id;
        public String ref;
        public String type;
    }
    public class definition{
        public list<fields> fields;
        public String title;
        public String id;
    }
    public class answers{
        public String type;
        public field field;
        public String text;
    }
    public class properties{
    }
}