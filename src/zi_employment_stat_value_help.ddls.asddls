@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employment Status value Help'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_EMPLOYMENT_STAT_VALUE_HELP
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZD_EMPLOYMENT_STATUS' )
{

      @EndUserText.label : 'Employment Status'
      @UI.textArrangement: #TEXT_FIRST
  key value_low as value,
      @EndUserText.label: 'Description'
      @Semantics.text: true
      text
}
where
      language    = $session.system_language
  and domain_name = 'ZD_EMPLOYMENT_STATUS'
