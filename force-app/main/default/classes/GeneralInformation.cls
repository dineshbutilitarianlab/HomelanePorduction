public with sharing class GeneralInformation {
	public static GeneralInformation generalInfo {
    	set;
    	get {
    		if(generalInfo == null){
    			generalInfo = new GeneralInformation();
    		}
    		return generalInfo;
    	}
    }
	public String loginUserImg {
	get{
		if(loginUserImg == null){
			loginUserImg = getUserImageUrl(userInfo.getUserId());
		}
		return loginUserImg;
	} set;}
	 
	private static String getUserImageUrl(Id usrId){
		return [select SmallPhotoUrl from User where id = :usrId].SmallPhotoUrl;
	} 
	
    public String MapValuesDateFormate() {
        Map<String, String> locale_map = new Map<String, String>(); //holds the locale to timedate formats
        locale_map.put('ar', 'dd/MM/yyyy');
        locale_map.put('ar_AE', 'dd/MM/yyyy');
        locale_map.put('ar_BH', 'dd/MM/yyyy');
        locale_map.put('ar_JO', 'dd/MM/yyyy');
        locale_map.put('ar_KW', 'dd/MM/yyyy');
        locale_map.put('ar_LB', 'dd/MM/yyyy');
        locale_map.put('ar_SA', 'dd/MM/yyyy');
        locale_map.put('bg_BG', 'yyyy-M-d');
        locale_map.put('ca', 'dd/MM/yyyy');
        locale_map.put('ca_ES', 'dd/MM/yyyy');
        locale_map.put('ca_ES_EURO', 'dd/MM/yyyy');
        locale_map.put('cs', 'd.M.yyyy');
        locale_map.put('cs_CZ', 'd.M.yyyy');
        locale_map.put('da', 'dd-MM-yyyy'); 
        locale_map.put('da_DK', 'dd-MM-yyyy');
        locale_map.put('de', 'dd.MM.yyyy');
        locale_map.put('de_AT', 'dd.MM.yyyy');
        locale_map.put('de_AT_EURO', 'dd.MM.yyyy');
        locale_map.put('de_CH', 'dd.MM.yyyy');
        locale_map.put('de_DE', 'dd.MM.yyyy');
        locale_map.put('de_DE_EURO', 'dd.MM.yyyy');
        locale_map.put('de_LU', 'dd.MM.yyyy');
        locale_map.put('de_LU_EURO', 'dd.MM.yyyy');
        locale_map.put('el_GR', 'd/M/yyyy');
        locale_map.put('en_AU', 'd/MM/yyyy');
        locale_map.put('en_B', 'M/d/yyyy');
        locale_map.put('en_BM', 'M/d/yyyy');
        locale_map.put('en_CA', 'dd/MM/yyyy');
        locale_map.put('en_GB', 'dd/MM/yyyy');
        locale_map.put('en_GH', 'M/d/yyyy');
        locale_map.put('en_ID', 'M/d/yyyy');
        locale_map.put('en_IE', 'dd/MM/yyyy');
        locale_map.put('en_IE_EURO', 'dd/MM/yyyy');
        locale_map.put('en_NZ', 'd/MM/yyyy');
        locale_map.put('en_SG', 'M/d/yyyy');
        locale_map.put('en_US', 'M/d/yyyy');
        locale_map.put('en_ZA', 'yyyy/MM/dd');
        locale_map.put('es', 'd/MM/yyyy');
        locale_map.put('es_AR', 'dd/MM/yyyy');
        locale_map.put('es_BO', 'dd-MM-yyyy');
        locale_map.put('es_CL', 'dd-MM-yyyy');
        locale_map.put('es_CO', 'd/MM/yyyy');
        locale_map.put('es_CR', 'dd/MM/yyyy');
        locale_map.put('es_EC', 'dd/MM/yyyy');
        locale_map.put('es_ES', 'd/MM/yyyy');
        locale_map.put('es_ES_EURO', 'd/MM/yyyy');
        locale_map.put('es_GT', 'd/MM/yyyy');
        locale_map.put('es_HN', 'MM-dd-yyyy');
        locale_map.put('es_MX', 'd/MM/yyyy');
        locale_map.put('es_PE', 'dd/MM/yyyy');
        locale_map.put('es_PR', 'MM-dd-yyyy');
        locale_map.put('es_PY', 'dd/MM/yyyy');
        locale_map.put('es_SV', 'MM-dd-yyyy');
        locale_map.put('es_UY', 'dd/MM/yyyy');
        locale_map.put('es_VE', 'dd/MM/yyyy');
        locale_map.put('et_EE', 'd.MM.yyyy');
        locale_map.put('fi', 'd.M.yyyy');
        locale_map.put('fi_FI', 'd.M.yyyy');
        locale_map.put('fi_FI_EURO', 'd.M.yyyy');
        locale_map.put('fr', 'dd/MM/yyyy');
        locale_map.put('fr_BE', 'd/MM/yyyy');
        locale_map.put('fr_CA', 'yyyy-MM-dd');
        locale_map.put('fr_CH', 'dd.MM.yyyy');
        locale_map.put('fr_FR', 'dd/MM/yyyy');
        locale_map.put('fr_FR_EURO', 'dd/MM/yyyy');
        locale_map.put('fr_LU', 'dd/MM/yyyy');
        locale_map.put('fr_MC', 'dd/MM/yyyy');
        locale_map.put('hr_HR', 'yyyy.MM.dd');
        locale_map.put('hu', 'yyyy.MM.dd');
        locale_map.put('hy_AM', 'M/d/yyyy');
        locale_map.put('is_IS', 'd.M.yyyy');
        locale_map.put('it', 'dd/MM/yyyy');
        locale_map.put('it_CH', 'dd.MM.yyyy');
        locale_map.put('it_IT', 'dd/MM/yyyy');
        locale_map.put('iw', 'dd/MM/yyyy');
        locale_map.put('iw_IL', 'dd/MM/yyyy');
        locale_map.put('ja', 'yyyy/MM/dd');
        locale_map.put('ja_JP', 'yyyy/MM/dd');
        locale_map.put('kk_KZ', 'M/d/yyyy');
        locale_map.put('km_KH', 'M/d/yyyy');
        locale_map.put('ko', 'yyyy. M. d');
        locale_map.put('ko_KR', 'yyyy. M. d');
        locale_map.put('lt_LT', 'yyyy.M.d');
        locale_map.put('lv_LV', 'yyyy.d.M');
        locale_map.put('ms_MY', 'dd/MM/yyyy');
        locale_map.put('nl', 'd-M-yyyy');
        locale_map.put('nl_BE', 'd/MM/yyyy');
        locale_map.put('nl_NL', 'd-M-yyyy');
        locale_map.put('nl_SR', 'd-M-yyyy');
        locale_map.put('no', 'dd.MM.yyyy');
        locale_map.put('no_NO', 'dd.MM.yyyy');
        locale_map.put('pl', 'yyyy-MM-dd');
        locale_map.put('pt', 'dd-MM-yyyy');
        locale_map.put('pt_AO', 'dd-MM-yyyy');
        locale_map.put('pt_BR', 'dd/MM/yyyy');
        locale_map.put('pt_PT', 'dd-MM-yyyy');
        locale_map.put('ro_RO', 'dd.MM.yyyy');
        locale_map.put('ru', 'dd.MM.yyyy');
        locale_map.put('sk_SK', 'd.M.yyyy');
        locale_map.put('sl_SI', 'd.M.y');
        locale_map.put('sv', 'yyyy-MM-dd');
        locale_map.put('sv_SE', 'yyyy-MM-dd');
        locale_map.put('th', 'M/d/yyyy');
        locale_map.put('th_TH', 'd/M/yyyy');
        locale_map.put('tr', 'dd.MM.yyyy');
        locale_map.put('ur_PK', 'M/d/yyyy');
        locale_map.put('vi_VN', 'dd/MM/yyyy');
        locale_map.put('zh', 'yyyy-M-d');
        locale_map.put('zh_CN', 'yyyy-M-d');
        locale_map.put('zh_HK', 'yyyy-M-d');
        locale_map.put('zh_TW', 'yyyy/M/d');
        //locale_map.put('en_IN', 'dd/mm/yyyy h:mm a'); // manualy put
        locale_map.put('en_IN', 'd/M/yyyy'); // manually added for locale India
        
        String user_locale = UserInfo.getLocale();
        
       // If locale is not match with current mapping
        if(locale_map.get(user_locale) == null) {
            user_locale = 'en_US';
        }
        
        String customdate = locale_map.get(user_locale);
        return customdate;
    }
    
    //populate a map with locale values and corresponding datetime formats
    public String MapValuesDateTime() {
        Map<String, String> locale_map = new Map<String, String>(); //holds the locale to timedate formats
        locale_map.put('ar', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_AE', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_BH', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_JO', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_KW', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_LB', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_SA', 'dd/MM/yyyy hh:mm a');
        locale_map.put('bg_BG', 'yyyy-M-d H:mm');
        locale_map.put('ca', 'dd/MM/yyyy HH:mm');
        locale_map.put('ca_ES', 'dd/MM/yyyy HH:mm');
        locale_map.put('ca_ES_EURO', 'dd/MM/yyyy HH:mm');
        locale_map.put('cs', 'd.M.yyyy H:mm');
        locale_map.put('cs_CZ', 'd.M.yyyy H:mm');
        locale_map.put('da', 'dd-MM-yyyy HH:mm');
        locale_map.put('da_DK', 'dd-MM-yyyy HH:mm');
        locale_map.put('de', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_AT', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_AT_EURO', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_CH', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_DE', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_DE_EURO', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_LU', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_LU_EURO', 'dd.MM.yyyy HH:mm');
        locale_map.put('el_GR', 'd/M/yyyy h:mm a');
        locale_map.put('en_AU', 'd/MM/yyyy HH:mm');
        locale_map.put('en_B', 'M/d/yyyy h:mm a');
        locale_map.put('en_BM', 'M/d/yyyy h:mm a');
        locale_map.put('en_CA', 'dd/MM/yyyy h:mm a');
        locale_map.put('en_GB', 'dd/MM/yyyy HH:mm');
        locale_map.put('en_GH', 'M/d/yyyy h:mm a');
        locale_map.put('en_ID', 'M/d/yyyy h:mm a');
        locale_map.put('en_IE', 'dd/MM/yyyy HH:mm');
        locale_map.put('en_IE_EURO', 'dd/MM/yyyy HH:mm');
        locale_map.put('en_NZ', 'd/MM/yyyy HH:mm');
        locale_map.put('en_SG', 'M/d/yyyy h:mm a');
        locale_map.put('en_US', 'M/d/yyyy h:mm a');
        locale_map.put('en_ZA', 'yyyy/MM/dd hh:mm a');
        locale_map.put('es', 'd/MM/yyyy H:mm');
        locale_map.put('es_AR', 'dd/MM/yyyy HH:mm');
        locale_map.put('es_BO', 'dd-MM-yyyy hh:mm a');
        locale_map.put('es_CL', 'dd-MM-yyyy hh:mm a');
        locale_map.put('es_CO', 'd/MM/yyyy hh:mm a');
        locale_map.put('es_CR', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_EC', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_ES', 'd/MM/yyyy H:mm');
        locale_map.put('es_ES_EURO', 'd/MM/yyyy H:mm');
        locale_map.put('es_GT', 'd/MM/yyyy hh:mm a');
        locale_map.put('es_HN', 'MM-dd-yyyy hh:mm a');
        locale_map.put('es_MX', 'd/MM/yyyy hh:mm a');
        locale_map.put('es_PE', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_PR', 'MM-dd-yyyy hh:mm a');
        locale_map.put('es_PY', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_SV', 'MM-dd-yyyy hh:mm a');
        locale_map.put('es_UY', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_VE', 'dd/MM/yyyy hh:mm a');
        locale_map.put('et_EE', 'd.MM.yyyy H:mm');
        locale_map.put('fi', 'd.M.yyyy H:mm');
        locale_map.put('fi_FI', 'd.M.yyyy H:mm');
        locale_map.put('fi_FI_EURO', 'd.M.yyyy H:mm');
        locale_map.put('fr', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_BE', 'd/MM/yyyy H:mm');
        locale_map.put('fr_CA', 'yyyy-MM-dd HH:mm');
        locale_map.put('fr_CH', 'dd.MM.yyyy HH:mm');
        locale_map.put('fr_FR', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_FR_EURO', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_LU', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_MC', 'dd/MM/yyyy HH:mm');
        locale_map.put('hr_HR', 'yyyy.MM.dd HH:mm');
        locale_map.put('hu', 'yyyy.MM.dd. H:mm');
        locale_map.put('hy_AM', 'M/d/yyyy h:mm a');
        locale_map.put('is_IS', 'd.M.yyyy HH:mm');
        locale_map.put('it', 'dd/MM/yyyy H.mm');
        locale_map.put('it_CH', 'dd.MM.yyyy HH:mm');
        locale_map.put('it_IT', 'dd/MM/yyyy H.mm');
        locale_map.put('iw', 'HH:mm dd/MM/yyyy');
        locale_map.put('iw_IL', 'HH:mm dd/MM/yyyy');
        locale_map.put('ja', 'yyyy/MM/dd H:mm');
        locale_map.put('ja_JP', 'yyyy/MM/dd H:mm');
        locale_map.put('kk_KZ', 'M/d/yyyy h:mm a');
        locale_map.put('km_KH', 'M/d/yyyy h:mm a');
        locale_map.put('ko', 'yyyy. M. d a h:mm');
        locale_map.put('ko_KR', 'yyyy. M. d a h:mm');
        locale_map.put('lt_LT', 'yyyy.M.d HH.mm');
        locale_map.put('lv_LV', 'yyyy.d.M HH:mm');
        locale_map.put('ms_MY', 'dd/MM/yyyy h:mm a');
        locale_map.put('nl', 'd-M-yyyy H:mm');
        locale_map.put('nl_BE', 'd/MM/yyyy H:mm');
        locale_map.put('nl_NL', 'd-M-yyyy H:mm');
        locale_map.put('nl_SR', 'd-M-yyyy H:mm');
        locale_map.put('no', 'dd.MM.yyyy HH:mm');
        locale_map.put('no_NO', 'dd.MM.yyyy HH:mm');
        locale_map.put('pl', 'yyyy-MM-dd HH:mm');
        locale_map.put('pt', 'dd-MM-yyyy H:mm');
        locale_map.put('pt_AO', 'dd-MM-yyyy H:mm');
        locale_map.put('pt_BR', 'dd/MM/yyyy HH:mm');
        locale_map.put('pt_PT', 'dd-MM-yyyy H:mm');
        locale_map.put('ro_RO', 'dd.MM.yyyy HH:mm');
        locale_map.put('ru', 'dd.MM.yyyy H:mm');
        locale_map.put('sk_SK', 'd.M.yyyy H:mm');
        locale_map.put('sl_SI', 'd.M.y H:mm');
        locale_map.put('sv', 'yyyy-MM-dd HH:mm');
        locale_map.put('sv_SE', 'yyyy-MM-dd HH:mm');
        locale_map.put('th', 'M/d/yyyy h:mm a');
        locale_map.put('th_TH', 'd/M/yyyy, H:mm ?.');
        locale_map.put('tr', 'dd.MM.yyyy HH:mm');
        locale_map.put('ur_PK', 'M/d/yyyy h:mm a');
        locale_map.put('vi_VN', 'HH:mm dd/MM/yyyy');
        locale_map.put('zh', 'yyyy-M-d ah:mm');
        locale_map.put('zh_CN', 'yyyy-M-d ah:mm');
        locale_map.put('zh_HK', 'yyyy-M-d ah:mm');
        locale_map.put('zh_TW', 'yyyy/M/d a h:mm');
        //locale_map.put('en_IN', 'dd/mm/yyyy h:mm a'); // manualy put
        locale_map.put('en_IN', 'd/M/yyyy h:mm a'); // manually added for locale India
        locale_map.put('eu_ES', 'yyyy-mm-d HH:mm'); // manually added for locale Basque (Spain)
        String user_locale = UserInfo.getLocale();
        
        // If locale is not match with current mapping
        if(locale_map.get(user_locale) == null) {
            user_locale = 'en_US';
        }
        
        
        return locale_map.get(user_locale); //return the map
    }
}