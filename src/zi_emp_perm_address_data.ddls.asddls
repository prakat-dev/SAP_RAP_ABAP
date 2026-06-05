@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Permanent Address Child Entity'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_EMP_PERM_ADDRESS_DATA as select from zemp_address_tp3
association to parent ZI_EMPLOYEE_MASTER as _employee
    on $projection.Empid = _employee.Empid
{
    key empid as Empid,
    key addr_type as AddrType,
    name1 as Name1,
    street as Street,
    city1 as City1,
    state as State,
    country as Country,
    postal_code as PostalCode,
    create_by as CreateBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_chaged_at as LastChagedAt,
    local_last_change_at as LocalLastChangeAt,
    _employee
} 
where addr_type = 'P'
