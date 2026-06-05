@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Address Data projection view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_EMP_ADDRESS_DATA 
as projection on ZI_EMP_ADDRESS_DATA
{
    key Empid,
    @Semantics.address.label: true
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
    _employee : redirected to parent ZC_EMPLOYEE_MASTER
}
