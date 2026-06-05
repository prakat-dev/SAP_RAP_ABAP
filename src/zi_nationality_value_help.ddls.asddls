@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Nationality Value Help Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_NATIONALITY_VALUE_HELP
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZD_NATIONALITY'  )
{

      @EndUserText.label: 'Nationality'
      @UI.textArrangement: #TEXT_FIRST
  key value_low as value,
      @EndUserText.label: 'Description'
      @Semantics.text: true
        text
}
where
      language    = $session.system_language
  and domain_name = 'ZD_NATIONALITY'
