@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value help for marital status'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_MARITALSTATUS_VALUE_HELP
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZD_MARITAL_STATUS'  )
{

      @EndUserText.label: 'Marital Status'
      @UI.textArrangement: #TEXT_FIRST
  key value_low as MaritalStatusValueHelp,
      @EndUserText.label: 'Description'
      @Semantics.text: true
      text      as MaritalStatusDescription
}

where
      domain_name = 'ZD_MARITAL_STATUS'
  and language    = $session.system_language
