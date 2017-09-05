/*
* 
* Case: Find Cost of Tile to Cover W x H Floor
* Description: Calculate the total cost of tile it would take to cover a floor plan of width and height, using a cost entered by the user.
* 
* My comment:
* As in case "Next Prime Number" I shoud use popup windows to ask User for all required informations, but in procedures I can't use bind 
* variables. I prefer functions/procedures than anonymous blocks, so I turned required popups into procedure parameters.
* 
*/
 
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE pr_flooring_calculator
(n_cost_per_unit IN NUMBER -- value of 1 pack of tiles/can of paint, etc.
,n_area_covered IN NUMBER -- square metres covered by the pack
,n_width IN NUMBER -- width of the room
,n_height IN NUMBER) -- height of the room
IS
	n_area NUMBER;
	n_calculations NUMBER;
	v_error_msg VARCHAR2(20);
	v_error_parameter_msg VARCHAR2(10);
	
	ex_negative_number EXCEPTION;
BEGIN
	IF n_cost_per_unit < 1 THEN
		v_error_msg := '"cost per unit"';
		v_error_parameter_msg := TO_CHAR(n_cost_per_unit);
		RAISE ex_negative_number;
	ELSIF n_area_covered < 1 THEN
		v_error_msg := '"area covered"';
		v_error_parameter_msg := TO_CHAR(n_area_covered);
		RAISE ex_negative_number;
	ELSIF n_width < 1 THEN
		v_error_msg := '"width"';
		v_error_parameter_msg := TO_CHAR(n_width);
		RAISE ex_negative_number;
	ELSIF n_height < 1 THEN
		v_error_msg := '"height"';
		v_error_parameter_msg := TO_CHAR(n_height);
		RAISE ex_negative_number;
	END IF;

	n_area := ROUND(n_width * n_height,2);
	n_calculations := ROUND(n_area / n_area_covered * n_cost_per_unit ,2);
	
	DBMS_OUTPUT.PUT_LINE('You need to cover a total of ' || n_area || ' square meters.' || CHR(13)
							     || 'The total cost will be: ' || n_calculations);
EXCEPTION
    WHEN ex_negative_number THEN
        RAISE_APPLICATION_ERROR(-20001,
        'Parameter ' || v_error_msg || ' cannot be less than 1. Value given by User: ' || v_error_parameter_msg);
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
END pr_flooring_calculator;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
EXECUTE pr_flooring_calculator(23.75, 4.5, 2.1, 4.3);

/* Script result: */
You need to cover a total of 9.03 square meters.
The total cost will be: 47.66

