@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee Address Data CDS View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZI_EMP_ADDRESS_DATA
  as select from zemp_address_tp3 as addr
  association to parent ZI_EMPLOYEE_MASTER as _employee on $projection.Empid = _employee.Empid
{

  key addr.empid as Empid,
  key addr.addr_type as AddrType,
  addr.name1 as Name1,
  addr.street as Street,
  addr.city1 as City1,
  addr.state as State,
  addr.country as Country,
  addr.postal_code as PostalCode,
  addr.create_by as CreateBy,
  addr.created_at as CreatedAt,
  addr.last_changed_by as LastChangedBy,
  addr.last_chaged_at as LastChagedAt,
  addr.local_last_change_at as LocalLastChangeAt,
  _employee
}
where addr_type = 'C'
