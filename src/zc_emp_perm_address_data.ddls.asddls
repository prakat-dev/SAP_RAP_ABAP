@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Permanent Address'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_EMP_PERM_ADDRESS_DATA 
as projection on ZI_EMP_PERM_ADDRESS_DATA
{
    key Empid,
    key AddrType,
    @Semantics.address.number: true
    Name1,
    @Semantics.address.street: true
    Street,
    @Semantics.address.city: true
    City1,
    @Semantics.address.region: true
    State,
    @Semantics.address.country: true
    Country,
    @Semantics.address.zipCode: true
    PostalCode,
    CreateBy,
    CreatedAt,
    LastChangedBy,
    LastChagedAt,
    LocalLastChangeAt,
    /* Associations */
    _employee: redirected to parent ZC_EMPLOYEE_MASTER
}
