/*
*
* Case: Closest pair problem
* Description: The closest pair of points problem or closest pair problem is a problem of computational geometry: given n points 
* in metric space, find a pair of points with the smallest distance between them.
* 
* My comment:
* Basic version, brute-force algorithm.
*
*/
  
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE pr_closest_pair
(p_points VARCHAR2 DEFAULT NULL)
IS
    n_random_counter NUMBER;
    b_is_random BOOLEAN DEFAULT TRUE;
    v_points_cleared VARCHAR2(4000);
    n_temp_tab_counter NUMBER;
    n_x_value_counter NUMBER;
    n_y_value_counter NUMBER;
    v_result_x_point VARCHAR2(50);
    v_result_y_point VARCHAR2(50);
    n_elements_count NUMBER;
    n_minimum NUMBER;
    n_distance NUMBER;
    v_random_points_list VARCHAR2(2000);
    
    CURSOR c_transform_string(p_input_string VARCHAR2) IS
    SELECT  regexp_substr(p_input_string, '[^,]+', 1, LEVEL) AS parsed_number
    FROM    dual
    CONNECT BY INSTR(p_input_string, ',', 1, LEVEL - 1) > 0;

    TYPE t_tab IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    t_temp_table t_tab;

    TYPE r_point IS RECORD(x_value NUMBER, y_value NUMBER);
    TYPE row_points IS TABLE OF r_point INDEX BY BINARY_INTEGER;
    t_table_of_points row_points;

    ex_odd_elements EXCEPTION;
    ex_not_enough_points EXCEPTION;

    FUNCTION fn_get_formated_number
    (p_input_number NUMBER)
    RETURN VARCHAR2
    IS
        v_number_as_string VARCHAR2(50);
    BEGIN
        IF p_input_number < 1 THEN
            v_number_as_string := TRIM(TO_CHAR(p_input_number, RPAD('0.', LENGTH(p_input_number) + 1, '9')));
        ELSE
            v_number_as_string := TRIM(REPLACE(TO_CHAR(p_input_number), ',','.'));
        END IF;

    RETURN v_number_as_string;
    END fn_get_formated_number;
BEGIN
    n_minimum := POWER(10, 20); -- initialize start distance with big number, to replace it while searching minimum distance
    
    IF p_points IS NULL THEN
        LOOP
            n_random_counter := ROUND(DBMS_RANDOM.VALUE(4,50));
            EXIT WHEN MOD(n_random_counter, 2) = 0;
        END LOOP;
        
        FOR i IN 1 .. n_random_counter LOOP
            t_table_of_points(i).x_value := ROUND(DBMS_RANDOM.VALUE, 6);
            t_table_of_points(i).y_value := ROUND(DBMS_RANDOM.VALUE, 6);
        END LOOP;
    ELSE
        b_is_random := FALSE;
        v_points_cleared := TRANSLATE(p_points, ';[]{}()<>', ','); -- replace ';' to ',' and clean out unnecessary signs
        n_temp_tab_counter := 1;

        FOR i IN c_transform_string(v_points_cleared) LOOP  -- transform numbers in string to regular numbers, put them into temp array
            t_temp_table(n_temp_tab_counter) := TO_NUMBER(REPLACE(i.parsed_number, '.', ','));
            n_temp_tab_counter := n_temp_tab_counter + 1;
        END LOOP;

        IF MOD(n_temp_tab_counter - 1, 2) != 0 THEN
            RAISE ex_odd_elements;
        ELSIF n_temp_tab_counter - 1 < 4 THEN
            RAISE ex_not_enough_points;
        END IF;

        n_x_value_counter := 1;
        n_y_value_counter := 1;
        
        FOR i IN t_temp_table.FIRST .. t_temp_table.LAST LOOP   -- first loop to add x values to table of points
            IF MOD(i, 2) != 0 THEN
                t_table_of_points(n_x_value_counter).x_value := t_temp_table(i);
                n_x_value_counter := n_x_value_counter + 1;
            END IF;
        END LOOP;

        FOR i IN t_temp_table.FIRST .. t_temp_table.LAST LOOP   -- second loop to add y values to table of points
            IF MOD(i, 2) = 0 THEN
                t_table_of_points(n_y_value_counter).y_value := t_temp_table(i);
                n_y_value_counter := n_y_value_counter + 1;
            END IF;
        END LOOP;   
    END IF;
    
    FOR i IN t_table_of_points.FIRST .. t_table_of_points.COUNT - 1 LOOP
        FOR j IN i + 1 .. t_table_of_points.COUNT LOOP
            n_distance := SQRT(POWER(t_table_of_points(j).x_value - t_table_of_points(i).x_value, 2) + POWER(t_table_of_points(j).y_value - t_table_of_points(i).y_value, 2));
            
            IF n_distance < n_minimum THEN
                n_minimum := ROUND(n_distance, 6);
                v_result_x_point := i || ' [' || fn_get_formated_number(t_table_of_points(i).x_value) || ', ' || fn_get_formated_number(t_table_of_points(i).y_value) || ']'; 
                v_result_y_point := j || ' [' || fn_get_formated_number(t_table_of_points(j).x_value) || ', ' || fn_get_formated_number(t_table_of_points(j).y_value) || ']';
            END IF;
        END LOOP;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('The closest pair of points is point ' || v_result_x_point || ' and point ' || v_result_y_point || '. Distance between them is ' || fn_get_formated_number(n_minimum));
    
    IF b_is_random THEN
        FOR i IN t_table_of_points.FIRST .. t_table_of_points.LAST LOOP
            IF v_random_points_list IS NOT NULL THEN
                v_random_points_list := v_random_points_list || ', ' || '[' || fn_get_formated_number(t_table_of_points(i).x_value) || ', ' || fn_get_formated_number(t_table_of_points(i).y_value) || ']';
            ELSE
                v_random_points_list := '[' || fn_get_formated_number(t_table_of_points(i).x_value) || ', ' || fn_get_formated_number(t_table_of_points(i).y_value) || ']';
            END IF;
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('List of ' || t_table_of_points.COUNT || ' randomly generated points: ' || v_random_points_list);
    END IF;
EXCEPTION
    WHEN ex_odd_elements THEN
        RAISE_APPLICATION_ERROR(-20001, 'Last point doesn''t have an Y value. Check list of points.');
    WHEN ex_not_enough_points THEN
        RAISE_APPLICATION_ERROR(-20002, 'There must be at least 2 points to find minimum distance between them.');
END pr_closest_pair;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
EXECUTE pr_closest_pair('0.654682, 0.925557, 0.409382, 0.619391, 0.891663, 0.888594, 0.716629, 0.996200, 0.477721, 0.946355, 0.925092, 0.818220, 
0.624291, 0.142924, 0.211332, 0.221507, 0.293786, 0.691701, 0.839186, 0.728260');


/* Script result: */
The closest pair of points is point 3 [0.891663, 0.888594] and point 6 [0.925092, 0.81822]. Distance between them is 0.07791

---

/* Test: */
EXECUTE pr_closest_pair('[0.519253, 0.765408], [0.318348, 0.920861], [0.945047, 0.841809], [0.318381, 0.960566], [0.083692, 0.436204], [0.701679, 0.727457]');

/* Script result: */
The closest pair of points is point 2 [0.318348, 0.920861] and point 4 [0.318381, 0.960566]. Distance between them is 0.039705

---

/* Test: */
EXECUTE pr_closest_pair;

/* Script result: */
The closest pair of points is point 2 [0.139504, 0.909923] and point 26 [0.177623, 0.920968]. Distance between them is 0.039687
List of 34 randomly generated points: [0.859393, 0.800744], [0.139504, 0.909923], [0.546134, 0.944649], [0.773604, 0.762186], [0.448109, 0.914566], 
[0.248538, 0.255187], [0.55765, 0.679207], [0.797886, 0.976043],[0.444165, 0.334934], [0.476848, 0.741418], [0.219289, 0.968772], [0.348165, 0.370349], 
[0.744121, 0.632744], [0.4426, 0.795082], [0.218322, 0.411252], [0.834869, 0.264354], [0.232236, 0.354233],[0.377656, 0.157416], [0.137128, 0.665727], 
[0.037555, 0.187144], [0.955122, 0.767791], [0.020594, 0.875998], [0.600068, 0.742933], [0.817852, 0.762547], [0.2955, 0.560541], [0.177623, 0.920968], 
[0.696228, 0.232091],[0.012163, 0.603514], [0.433488, 0.582104], [0.705005, 0.764456], [0.355901, 0.608473], [0.026539, 0.680344], [0.2688, 0.626194], 
[0.412602, 0.694778]

---

/* Test: */
EXECUTE pr_closest_pair;

/* Script result: */
The closest pair of points is point 4 [0.819356, 0.711705] and point 19 [0.795039, 0.740324]. Distance between them is 0.037555
List of 20 randomly generated points: [0.835441, 0.163187], [0.399288, 0.102724], [0.497443, 0.617416], [0.819356, 0.711705], [0.166018, 0.132896], 
[0.039621, 0.193285], [0.620223, 0.71605], [0.91455, 0.643342], [0.847032, 0.867868], [0.665724, 0.936337], [0.082661, 0.921871], [0.493029, 0.274201], 
[0.064095, 0.867489], [0.223922, 0.393984], [0.433196, 0.570776], [0.945002, 0.578374], [0.98104, 0.161834], [0.398224, 0.057984],[0.795039, 0.740324], 
[0.407933, 0.398108]

