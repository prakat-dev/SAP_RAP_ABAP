@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee Master Creation Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_EMPLOYEE_MASTER
  provider contract transactional_query
  as projection on ZI_EMPLOYEE_MASTER
{
          @Consumption.filter.hidden: true
  key     Empid,
          IdNo,
          FirstName,
          LastName,
          FullName,
          MiddleName,
          _gendervh.text                            as GenderText,
          _maritalstatusvh.MaritalStatusDescription as MaritalStatusText,
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_GENDER_VALUEHELP', element: 'value' } , useForValidation: true }]
          @ObjectModel.text.element: [ 'GenderText' ]
          Gender,
          DateOfBirth,
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MARITALSTATUS_VALUE_HELP', element: 'MaritalStatusValueHelp' }, useForValidation: true } ]
          @ObjectModel.text.element: [ 'MaritalStatusText' ]
          MaritalStatus,
          _nationalityvh.text                       as NationalityText,
          @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_NATIONALITY_VALUE_HELP', element: 'value' }, useForValidation: true  }]
          @ObjectModel.text.element: [ 'NationalityText' ]
          Nationality,
          @Semantics.eMail.address: true
          EmailId,
          @Semantics.telephone.type: [ #HOME ]
          PhoneNumberHom,
          @Semantics.telephone.type: [ #CELL ]
          PhoneNumberPer,
          EmergencyContactName,
          EmergencyContactRelation,
          @Semantics.telephone.type: [ #CELL ]
          EmergencyContactPhone,
          Designation,
          Organization,
          OfficeLocaiton,
          Branch,
          JoiningDate,
          ConfirmationDate,
          ExitDate,
          _employmentstatvh.text                    as EmploymentStatusText,
          @Consumption.valueHelpDefinition: [{ entity : { name:'ZI_EMPLOYMENT_STAT_VALUE_HELP', element: 'value'  }, useForValidation: true }]
          @ObjectModel.text.element: [ 'EmploymentStatusText' ]
          EmploymentStatus,
          Terminated,
          TerminationReason,
          TermiationDate,
          Department,
          Active,
          @Consumption.filter.hidden: true
          FileName,
          @Semantics.mimeType: true
          @Consumption.filter.hidden: true
          MimeType,
          @Semantics.largeObject: {
          mimeType: 'MimeType',
          fileName: 'FileName',
          contentDispositionPreference: #INLINE }
          @Consumption.filter.hidden: true
          ImageData,
          @Consumption.filter.hidden: true
          @Semantics.systemDateTime.createdAt: true
          CreatedAt,
          @Consumption.filter.hidden: true
          @Semantics.user.createdBy: true
          CreatedBy,
          @Consumption.filter.hidden: true
          @Semantics.systemDateTime.lastChangedAt: true
          LastChangedAt,
          @Consumption.filter.hidden: true
          @Semantics.user.localInstanceLastChangedBy: true
          LastChangedBy,
          @Consumption.filter.hidden: true
          @Semantics.systemDateTime.localInstanceLastChangedAt: true
          LocalLastChangedAt,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CHECK_DISPLAY_MODE'
  virtual GreenStatus    : abap.int1,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CHECK_DISPLAY_MODE'
  virtual RedStatus      : abap.int1,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CHECK_DISPLAY_MODE'
  virtual YellowStatus   : abap.int1,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CHECK_DISPLAY_MODE'
  virtual IsEditMode     : abap_boolean,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CHECK_DISPLAY_MODE'
  virtual HidePermButton : abap_boolean,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CHECK_DISPLAY_MODE'
  virtual HideCurrButton : abap_boolean,

          _caddress : redirected to composition child ZC_EMP_ADDRESS_DATA,
          _paddress : redirected to composition child ZC_EMP_PERM_ADDRESS_DATA,
          _gendervh,
          _maritalstatusvh,
          _nationalityvh,
          _employmentstatvh
}
