@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.sapObjectNodeType.name: 'ZEMP_MASTER_TP3'
@EndUserText.label: 'Employee Master Creation Root Entity'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_EMPLOYEE_MASTER
  as select from zemp_master_tp3
  composition [0..1] of ZI_EMP_ADDRESS_DATA         as _caddress
  composition [0..1] of ZI_EMP_PERM_ADDRESS_DATA    as _paddress
  association [1..1] to ZI_GENDER_VALUEHELP         as _gendervh        on $projection.Gender = _gendervh.value
  association [1..1] to ZI_MARITALSTATUS_VALUE_HELP as _maritalstatusvh on $projection.MaritalStatus = _maritalstatusvh.MaritalStatusValueHelp
  association [1..1] to ZI_NATIONALITY_VALUE_HELP   as _nationalityvh   on $projection.Nationality = _nationalityvh.value
  association [1..1] to ZI_EMPLOYMENT_STAT_VALUE_HELP as _employmentstatvh on $projection.EmploymentStatus = _employmentstatvh.value
{
  key empid                      as Empid,
      id_no                      as IdNo,
      first_name                 as FirstName,
      last_name                  as LastName,
      full_name                  as FullName,
      department                 as Department,

      middle_name                as MiddleName,
      gender                     as Gender,

      date_of_birth              as DateOfBirth,
      marital_status             as MaritalStatus,
      nationality                as Nationality,

      @Semantics.eMail.address: true
      email_id                   as EmailId,
      @Semantics.telephone.type: [ #HOME ]
      phone_number_hom           as PhoneNumberHom,
      @Semantics.telephone.type: [ #CELL ]
      phone_number_per           as PhoneNumberPer,


      emergency_contact_name     as EmergencyContactName,
      emergency_contact_relation as EmergencyContactRelation,
      @Semantics.telephone.type: [ #CELL ]
      emergency_contact_phone    as EmergencyContactPhone,
      designation                as Designation,
      organization               as Organization,
      office_locaiton            as OfficeLocaiton,
      branch                     as Branch,
      joining_date               as JoiningDate,
      confirmation_date          as ConfirmationDate,
      exit_date                  as ExitDate,
      employment_status          as EmploymentStatus,
      terminated                 as Terminated,
      termination_reason         as TerminationReason,
      termiation_date            as TermiationDate,


      active                     as Active,
      file_name                  as FileName,
      @Semantics.mimeType: true
      mime_type                  as MimeType,
      @Semantics.largeObject: {
       mimeType: 'MimeType',
       fileName: 'FileName',
       contentDispositionPreference: #INLINE
      }
      image_data                 as ImageData,
      @Semantics.user.createdBy: true
      created_by                 as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                 as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by            as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at            as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at      as LocalLastChangedAt,
      //    _address
      _paddress,
      _caddress,
      _gendervh,
      _maritalstatusvh,
      _nationalityvh,
      _employmentstatvh
}
