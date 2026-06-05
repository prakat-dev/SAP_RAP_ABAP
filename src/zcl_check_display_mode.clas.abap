CLASS zcl_check_display_mode DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CHECK_DISPLAY_MODE IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.


    DATA: lt_curr_read_keys TYPE TABLE FOR READ IMPORT zi_employee_master\_caddress,
          lt_perm_read_keys TYPE TABLE FOR READ IMPORT zi_employee_master\_paddress,
          lv_active         TYPE abap_boolean.

    LOOP AT it_original_data ASSIGNING FIELD-SYMBOL(<ls_original_data>).

      ASSIGN COMPONENT 'EMPID' OF STRUCTURE <ls_original_data> TO FIELD-SYMBOL(<lv_empid>).
      ASSIGN COMPONENT 'ISACTIVEENTITY' OF STRUCTURE <ls_original_data> TO FIELD-SYMBOL(<lv_active>).

      IF sy-subrc = 0.
        " Populate the RAP key structure to read the association
        APPEND VALUE #(
          Empid     = <lv_empid>
          %is_draft = xsdbool( <lv_active> = abap_false ) " Crucial: Match the draft state!
        ) TO lt_curr_read_keys.

        APPEND VALUE #(
            Empid     = <lv_empid>
            %is_draft = xsdbool( <lv_active> = abap_false ) " Crucial: Match the draft state!
          ) TO lt_perm_read_keys.

      ENDIF.

    ENDLOOP.

    IF lt_curr_read_keys IS NOT INITIAL.

      " Step 2: The BULK Fetch (Read the association for ALL parents at once)
      " We use READ ENTITIES so it respects both the DB and the Draft Buffer
      READ ENTITIES OF zi_employee_master
        ENTITY zi_employee_master BY \_caddress
        FIELDS ( AddrType ) " Only fetch the fields you actually need
        WITH lt_curr_read_keys
        RESULT DATA(lt_addresses_current).

      READ ENTITIES OF zi_employee_master
        ENTITY zi_employee_master BY \_paddress
        FIELDS ( AddrType ) " Only fetch the fields you actually need
        WITH lt_perm_read_keys
        RESULT DATA(lt_addresses_permanent).

      " Step 3: Map the child data back to the UI output table
      LOOP AT it_original_data ASSIGNING <ls_original_data>.

        DATA(lv_tabix) = sy-tabix.

        READ TABLE ct_calculated_data ASSIGNING FIELD-SYMBOL(<ls_calculated_data>) INDEX lv_tabix.

        IF sy-subrc = 0.


          ASSIGN COMPONENT 'GREENSTATUS' OF STRUCTURE <ls_calculated_data> TO FIELD-SYMBOL(<lv_green>).

          IF sy-subrc EQ 0.

            <lv_green> = 3.

          ENDIF.

          ASSIGN COMPONENT 'REDSTATUS' OF STRUCTURE <ls_calculated_data> TO FIELD-SYMBOL(<lv_red>).

          IF sy-subrc EQ 0.

            <lv_red> = 1.

          ENDIF.

          ASSIGN COMPONENT 'YELLOWSTATUS' OF STRUCTURE <ls_calculated_data> TO FIELD-SYMBOL(<lv_yellow>).

          IF sy-subrc = 0.

            <lv_yellow> = 2.

          ENDIF.


          ASSIGN COMPONENT 'ISACTIVEENTITY' OF STRUCTURE <ls_original_data> TO <lv_active>.

          IF sy-subrc = 0.

            ASSIGN COMPONENT 'ISEDITMODE' OF STRUCTURE <ls_calculated_data> TO FIELD-SYMBOL(<lv_is_edit_mode>).

            IF sy-subrc = 0.

              IF <lv_active> = abap_true.
                <lv_is_edit_mode> = abap_false.
              ELSE.
                <lv_is_edit_mode> = abap_true.
              ENDIF.

            ENDIF.

            ASSIGN COMPONENT 'HIDEPERMBUTTON' OF STRUCTURE <ls_calculated_data> TO FIELD-SYMBOL(<lv_hide_perm>).

            IF sy-subrc = 0.

              IF <lv_active> = abap_true.
                <lv_hide_perm> = abap_true.
              ELSE.

                IF line_exists( lt_addresses_permanent[  Empid = <lv_empid> AddrType = 'P'
                                %is_draft = xsdbool( <lv_active> = abap_false ) ] ).
                  <lv_hide_perm> = abap_true.
                ELSE.
                  <lv_hide_perm> = abap_false.
                ENDIF.

              ENDIF.
            ENDIF.

            ASSIGN COMPONENT 'HIDECURRBUTTON' OF STRUCTURE <ls_calculated_data> TO FIELD-SYMBOL(<lv_hide_curr>).

            IF sy-subrc = 0.

              IF <lv_active> = abap_true.
                <lv_hide_curr> = abap_true.
              ELSE.

                IF line_exists( lt_addresses_current[  Empid = <lv_empid> AddrType = 'C'
                                %is_draft = xsdbool( <lv_active> = abap_false ) ] ).
                  <lv_hide_curr> = abap_true.
                ELSE.
                  <lv_hide_curr> = abap_false.
                ENDIF.

              ENDIF.
            ENDIF.


          ENDIF.

        ENDIF.

      ENDLOOP.

    ENDIF.



  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.


    IF iv_entity = 'ZC_EMPLOYEE_MASTER'.

      " Tell the framework to fetch the standard Draft state field
      APPEND 'ISACTIVEENTITY' TO et_requested_orig_elements.
*       APPEND 'ISEDITMODE' TO et_requested_orig_elements.
*     APPEND '_CADDRESS' TO et_requested_orig_elements.
*      APPEND '_PADDRESS' TO et_requested_orig_elements.

    ENDIF.



  ENDMETHOD.
ENDCLASS.
