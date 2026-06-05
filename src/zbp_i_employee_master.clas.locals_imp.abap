CLASS lhc_zi_emp_perm_address_data DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR ZI_emp_perm_address_data RESULT result.

ENDCLASS.

CLASS lhc_zi_emp_perm_address_data IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_emp_address_data DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_emp_address_data RESULT result.

ENDCLASS.

CLASS lhc_zi_emp_address_data IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZI_EMPLOYEE_MASTER DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.


    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
    IMPORTING REQUEST requested_authorizations FOR zi_employee_master RESULT result.
    METHODS calculatefullname FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_employee_master~calculatefullname.
    METHODS calculateidno FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_employee_master~calculateidno.
    METHODS initcurrentaddress FOR MODIFY
      IMPORTING keys FOR ACTION zi_employee_master~initcurrentaddress.
    METHODS initpermanentaddress FOR MODIFY
      IMPORTING keys FOR ACTION zi_employee_master~initpermanentaddress.
    METHODS onboardemployee FOR MODIFY
      IMPORTING keys FOR ACTION zi_employee_master~onboardemployee.

    METHODS terminateemployee FOR MODIFY
      IMPORTING keys FOR ACTION zi_employee_master~terminateemployee.
    METHODS dateofbirthvalidate FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_employee_master~dateofbirthvalidate.
    METHODS checkdob FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_employee_master~CheckDoB.
    METHODS ForContactDetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_employee_master~ForContactDetails.

    METHODS ForPersonalDetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_employee_master~ForPersonalDetails.
    METHODS UpdateEmploymentStatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_employee_master~UpdateEmploymentStatus.
    METHODS OffboardEmployee FOR MODIFY
      IMPORTING keys FOR ACTION ZI_EMPLOYEE_MASTER~OffboardEmployee.

    METHODS ValidatePhoneNumber
      IMPORTING
                iv_phonenumber    TYPE char30
      RETURNING VALUE(ev_erromsg) TYPE string.

ENDCLASS.

CLASS lhc_ZI_EMPLOYEE_MASTER IMPLEMENTATION.


  METHOD get_global_authorizations.


  ENDMETHOD.

  METHOD CalculateFullName.


    READ ENTITIES OF zi_employee_master IN LOCAL MODE
      ENTITY zi_employee_master
        FIELDS ( FirstName LastName ) WITH CORRESPONDING #( keys )
      RESULT DATA(employees).

    LOOP AT employees ASSIGNING FIELD-SYMBOL(<employee>).
      <employee>-FullName = condense( val = |{ <employee>-FirstName } { <employee>-LastName }| ).
    ENDLOOP.


    MODIFY ENTITIES OF zi_employee_master IN LOCAL MODE
      ENTITY zi_employee_master
        UPDATE
          FIELDS ( FullName )
          WITH VALUE #( FOR emp IN employees
                        ( %tky     = emp-%tky
                          FullName = emp-FullName ) )
      REPORTED DATA(update_reported).

  ENDMETHOD.

  METHOD CalculateIdNo.

    DATA lv_max_id TYPE numc4.

    SELECT MAX( CAST( substring( IDNo, 3, 4 ) AS INT4 ) )
    AS max_id
    FROM zemp_master_drft
    INTO @DATA(lv_draft_max_id).

    IF sy-subrc NE 0.
      lv_draft_max_id = 0.
    ENDIF.

    SELECT MAX( CAST( substring( id_no, 3, 4 ) AS INT4 ) )
    AS max_id
    FROM zemp_master_TP3
    INTO @DATA(lv_act_max_id).

    IF sy-subrc NE 0.
      lv_act_max_id = 0.
    ENDIF.

    IF lv_act_max_id = 0 AND lv_draft_max_id = 0.
      lv_max_id = '0001'.
    ELSEIF lv_act_max_id > lv_draft_max_id.
      lv_max_id = lv_act_max_id.
      lv_max_id = lv_max_id + 1.
    ELSE.
      lv_max_id = lv_draft_max_id.
      lv_max_id = lv_max_id + 1.
    ENDIF.

    READ ENTITIES OF zi_employee_master IN LOCAL MODE
     ENTITY zi_employee_master
      FIELDS ( Empid EmploymentStatus ) WITH CORRESPONDING #( keys )
      RESULT DATA(employees).

    LOOP AT employees ASSIGNING FIELD-SYMBOL(<employee>).

      IF <employee>-IdNo IS INITIAL.

        DATA(lv_year) = cl_abap_context_info=>get_system_date( ).
        <employee>-IdNo = |{ lv_year+2(2) }| && |{ lv_max_id }|.
        lv_max_id = lv_max_id + 1.

      ENDIF.

      IF <employee>-EmploymentStatus IS INITIAL.
        <employee>-EmploymentStatus = '01'.
      ENDIF.

    ENDLOOP.

    MODIFY ENTITIES OF zi_employee_master IN LOCAL MODE
      ENTITY zi_employee_master
        UPDATE
          FIELDS ( IdNo EmploymentStatus )
          WITH VALUE #( FOR emp IN employees
                        ( %tky     = emp-%tky
                          IdNo = emp-IdNo
                          EmploymentStatus = emp-EmploymentStatus ) )
      REPORTED DATA(update_reported).

  ENDMETHOD.


  METHOD InitCurrentAddress.

    MODIFY ENTITIES OF zi_employee_master IN LOCAL MODE
        ENTITY zi_employee_master
        CREATE BY \_caddress
        FIELDS ( AddrType ) WITH VALUE #( FOR key IN keys (
            %tky    = key-%tky  " This carries the %is_draft status
            %target = VALUE #( (
                %cid      = 'C1'
                AddrType  = 'C'
                %is_draft = key-%is_draft " CRITICAL: Explicitly match the caller's state
            ) )
        ) )
        MAPPED   DATA(ls_mapped)
        FAILED   DATA(ls_failed)
        REPORTED DATA(ls_reported).

  ENDMETHOD.

  METHOD InitPermanentAddress.

    MODIFY ENTITIES OF zi_employee_master IN LOCAL MODE
      ENTITY zi_employee_master
      CREATE BY \_paddress
      FIELDS ( AddrType ) WITH VALUE #( FOR key IN keys (
          %tky    = key-%tky  " This carries the %is_draft status
          %target = VALUE #( (
              %cid      = 'P1'
              AddrType  = 'P'
              %is_draft = key-%is_draft " CRITICAL: Explicitly match the caller's state
          ) )
      ) )
      MAPPED   DATA(ls_mapped)
      FAILED   DATA(ls_failed)
      REPORTED DATA(ls_reported).

  ENDMETHOD.

  METHOD OnboardEmployee.
  ENDMETHOD.

  METHOD TerminateEmployee.
  ENDMETHOD.

  METHOD DateOfBirthValidate.


    READ ENTITIES OF zi_employee_master IN LOCAL MODE
    ENTITY zi_employee_master
    FIELDS ( DateOfBirth ) WITH CORRESPONDING #(  keys )
    RESULT DATA(lt_employees).


    LOOP AT lt_employees INTO DATA(lw_employee).

      DATA(lv_current_date) = cl_abap_context_info=>get_system_date( ).

      DATA(lv_cutoff_year) = CONV i( lv_current_date(4) ) - 18.

      DATA(lv_cutoff_date) = CONV d( |{ lv_cutoff_year }{ lv_current_date+4(4) }| ).

      IF lv_current_date+4(4) = '0229'.
        lv_cutoff_date = |{ lv_cutoff_year }0228|.
      ENDIF.

      DATA(lv_error_message) = COND #(  WHEN  lw_employee-DateOfBirth > lv_current_date THEN 'Date of birth cannot be in the future date'
                                        WHEN  ( lw_employee-DateOfBirth > lv_cutoff_date ) THEN 'Employee Should be atleast 18 years old' ).

      IF lv_error_message IS NOT INITIAL.
        APPEND VALUE #(  %tky = lw_employee-%tky  ) TO failed-zi_employee_master.
        APPEND VALUE #(  %tky = lw_employee-%tky
                         %state_area = 'DOB_VALIDATION'
                         %msg = new_message_with_text(  severity = if_abap_behv_message=>severity-error
                                                        text     = lv_error_message )
                        %element-DateofBirth = if_abap_behv=>mk-on ) TO reported-zi_employee_master.
      ENDIF.

    ENDLOOP.


  ENDMETHOD.

  METHOD CheckDoB.

*   This method is used to just check the Date of birth in real time.
    READ ENTITIES OF zi_employee_master IN LOCAL MODE
    ENTITY zi_employee_master
    FIELDS ( DateOfBirth ) WITH CORRESPONDING #(  keys )
    RESULT DATA(lt_employees).


*   Loop through the employees
    LOOP AT lt_employees INTO DATA(lw_employee).

      DATA(lv_current_date) = cl_abap_context_info=>get_system_date( ).

      DATA(lv_cutoff_year) = CONV i( lv_current_date(4) ) - 18.

      DATA(lv_cutoff_date) = CONV d( |{ lv_cutoff_year }{ lv_current_date+4(4) }| ).

      IF lv_current_date+4(4) = '0229'.
        lv_cutoff_date = |{ lv_cutoff_year }0228|.
      ENDIF.

      DATA(lv_error_message) = COND #(  WHEN  lw_employee-DateOfBirth > lv_current_date THEN 'Date of birth cannot be in the future date'
                                        WHEN  ( lw_employee-DateOfBirth > lv_cutoff_date ) THEN 'Employee Should be atleast 18 years old' ).

      APPEND VALUE #(  %tky = lw_employee-%tky %state_area = 'DOB_VALIDATION' ) TO reported-zi_employee_master.

*     Add the error message to State area so that the field is shown in red color if required.
      IF lv_error_message IS NOT INITIAL.
        APPEND VALUE #(  %tky = lw_employee-%tky
                         %state_area = 'DOB_VALIDATION'
                         %msg = new_message_with_text(  severity = if_abap_behv_message=>severity-error
                                                        text     = lv_error_message )
                        %element-DateofBirth = if_abap_behv=>mk-on ) TO reported-zi_employee_master.
      ELSE.

*     If the validation is correct then reset state area so that it is again greyed out.
        APPEND VALUE #( %tky        = lw_employee-%tky
                        %state_area = 'DOB_VALIDATION' )
          TO reported-zi_employee_master.

      ENDIF.

    ENDLOOP.


  ENDMETHOD.

  METHOD validatephonenumber.

    CLEAR ev_erromsg.

    IF iv_phonenumber IS NOT INITIAL.

      DATA(lv_firstchar) = substring( val = iv_phonenumber off = 0 len = 1 ).

      IF lv_firstchar <> '+'.
        DATA(lv_error) = abap_true.
      ELSE.

        IF strlen( iv_phonenumber ) <> 14.

          lv_error = abap_true.

        ELSE.

          DATA(lv_phone_number) = iv_phonenumber.

          CONDENSE lv_phone_number NO-GAPS.

          IF find_any_not_of( val = lv_phone_number sub = '+0123456789' ) > 0.

            lv_error = abap_true.

          ENDIF.

        ENDIF.


      ENDIF.

      IF lv_error = abap_true.
        ev_erromsg = 'Format must be: +91 followed by 10 digits'.
        RETURN.
      ELSE.
        CLEAR ev_erromsg.
      ENDIF.


    ENDIF.


  ENDMETHOD.

  METHOD ForContactDetails.

*   Read the entity in local mode to fetch the details for the contact details related validations
    READ ENTITIES OF zi_employee_master IN LOCAL MODE
    ENTITY zi_employee_master
    FIELDS ( PhoneNumberHom PhoneNumberPer EmailId  )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_contactdetails).

    IF lt_contactdetails IS NOT INITIAL.

*     Loop through the data and then check each field we want to validate.
      LOOP AT lt_contactdetails INTO DATA(lw_contact_details).


*
        APPEND VALUE #(  %tky = lw_contact_details-%tky %state_area = 'HOME_PHONE_NUMBER'  %element-PhoneNumberHom = if_abap_behv=>mk-on ) TO reported-zi_employee_master.

        IF lw_contact_details-PhoneNumberHom IS NOT INITIAL.

          DATA(lv_error_msg) = me->validatephonenumber( lw_contact_details-PhoneNumberHom ).

          IF lv_error_msg IS NOT INITIAL.

            APPEND VALUE #(   %tky        = lw_contact_details-%tky
                              %state_area = 'HOME_PHONE_NUMBER'
                              %msg = new_message_with_text( text = lv_error_msg severity = if_abap_behv_message=>severity-error )
                              %element-PhoneNumberHom = if_abap_behv=>mk-on ) TO reported-zi_employee_master.

          ENDIF.

        ENDIF.


        APPEND VALUE #(  %tky = lw_contact_details-%tky %state_area = 'PERSONAL_PHONE_NUMBER' %element-PhoneNumberper = if_abap_behv=>mk-on  ) TO reported-zi_employee_master.
        IF lw_contact_details-PhoneNumberPer IS NOT INITIAL.

          CLEAR lv_error_msg.

          lv_error_msg = me->validatephonenumber( lw_contact_details-PhoneNumberPer ).

          IF lv_error_msg IS NOT INITIAL.

            APPEND VALUE #(   %tky        = lw_contact_details-%tky
                              %state_area = 'PERSONAL_PHONE_NUMBER'
                              %msg = new_message_with_text( text = lv_error_msg severity = if_abap_behv_message=>severity-error )
                              %element-PhoneNumberper = if_abap_behv=>mk-on ) TO reported-zi_employee_master.

          ENDIF.


        ENDIF.


        APPEND VALUE #( %tky = lw_contact_details-%tky %state_area = 'EMAIL_ID' %element-emailid = if_abap_behv=>mk-on ) TO reported-zi_employee_master.

        IF lw_contact_details-EmailId IS NOT INITIAL.

          IF find(  val = lw_contact_details-EmailID sub = '@' ) <> -1.

            IF NOT contains( val = lw_contact_details-EmailId pcre = '\.com$' ).
              DATA(lv_error) = abap_true.
            ENDIF.

          ELSE.
            lv_error = abap_true.

          ENDIF.


        ENDIF.

        IF lv_error = abap_true.

          APPEND VALUE #(  %tky = lw_contact_details-%tky %state_area = 'EMAIL_ID' %msg = new_message_with_text(  text = 'Please enter a valid email id' severity = if_abap_behv_message=>severity-error )
                           %element-emailid = if_abap_behv=>mk-on ) TO reported-zi_employee_master.


        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.

  METHOD ForPersonalDetails.
  ENDMETHOD.

  METHOD UpdateEmploymentStatus.


  ENDMETHOD.

  METHOD OffboardEmployee.
  ENDMETHOD.

ENDCLASS.
