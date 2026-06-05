@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gender value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel : { resultSet.sizeCategory: #XS }
define view entity ZI_GENDER_VALUEHELP
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZD_GENDER_TP3' )
{

      @EndUserText.label: 'Gender'
      @UI.textArrangement: #TEXT_FIRST
  key value_low as value,

      @EndUserText.label: 'Description'
      @Semantics.text: true
      text

}
where
      domain_name = 'ZD_GENDER_TP3'
  and language    = $session.system_language
