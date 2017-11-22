/*
*
* Case: Sorting
* Description: Implement two types of sorting algorithms: Merge sort and bubble sort.
* 
* My comment:
* Merge sort, recursive implementation, little challenge.
* Bubble sort, easy to implement in different forms.
*
*/
  
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE sorting
IS
    TYPE t_tab IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;                  -- an array type, required for my solution

    FUNCTION fn_merge_sort(p_tab_input IN t_tab) RETURN t_tab; 
    
    -- if parameter p_input_numbers is null, there will be generated X random numbers instead (up to 50 randoms in between -1000 and 1000 )
    PROCEDURE pr_merge_sort(p_input_numbers VARCHAR2 DEFAULT NULL);         
    PROCEDURE pr_bubble_sort(p_input_numbers VARCHAR2 DEFAULT NULL);
END sorting;
/


CREATE OR REPLACE PACKAGE BODY sorting
IS
    FUNCTION fn_merge_sort                                                  -- main sorting and merging function 
    (p_tab_input IN t_tab)
    RETURN t_tab
    IS
        n_elements_count NUMBER;
        n_mid_point NUMBER;
        n_elements_left NUMBER;
        n_left_tab_counter NUMBER;
        n_right_tab_counter NUMBER;
        n_result_counter NUMBER;
        
        t_lefthalf t_tab;
        t_righthalf t_tab;
        t_result_tab t_tab;
    BEGIN
        IF p_tab_input.COUNT > 1 THEN                               -- if array has more than 1 element, split it 
            n_mid_point := FLOOR(p_tab_input.COUNT / 2);            -- finding point of splitting (number of elements divided by two and round down)
            n_elements_left := p_tab_input.COUNT - n_mid_point;     -- finding how many elements move to second temp array

            FOR i IN 1 .. n_mid_point LOOP                          -- put elements from 1 to point of splitting into first array from start array
                t_lefthalf(i) := p_tab_input(i);
            END LOOP;

            FOR j IN 1 .. n_elements_left LOOP                      -- put the rest (point of splitting + 1 to the end) of elements into second temp array
                t_righthalf(j) := p_tab_input(n_mid_point + j);
            END LOOP;

            t_lefthalf := fn_merge_sort(t_lefthalf);                -- recursive call of fn_merge sort for "left" and "right" array, until we receive one element arrays in result
            t_righthalf := fn_merge_sort(t_righthalf);

            n_left_tab_counter := 0;                                -- just initialize counters
            n_right_tab_counter := 0;
            n_result_counter := 0;
        
            WHILE n_left_tab_counter < t_lefthalf.COUNT AND n_right_tab_counter < t_righthalf.COUNT LOOP   -- merge mechanism, move elements from temp "left" array and "right" array to the result array
                n_result_counter := n_result_counter + 1;                                                  

                IF t_lefthalf(n_left_tab_counter + 1) <= t_righthalf(n_right_tab_counter + 1) THEN         -- if "left" array(i) element <= right array(i) element, move "left" array(i) element to result array
                    t_result_tab(n_result_counter) := t_lefthalf(n_left_tab_counter + 1);
                    n_left_tab_counter := n_left_tab_counter + 1;
                ELSE
                    t_result_tab(n_result_counter) := t_righthalf(n_right_tab_counter + 1);                -- else move "right" array(i) element to result array
                    n_right_tab_counter := n_right_tab_counter + 1;
                END IF;
            END LOOP;
     
            IF n_left_tab_counter < t_lefthalf.COUNT THEN                                                  -- move the remaining elements of "left" array to the result array, if there are any 
                WHILE n_left_tab_counter < t_lefthalf.COUNT LOOP
                    n_result_counter := n_result_counter + 1;
                    n_left_tab_counter := n_left_tab_counter + 1;
                    t_result_tab(n_result_counter) := t_lefthalf(n_left_tab_counter);
                END LOOP; 
            END IF; 
            
            IF n_right_tab_counter < t_righthalf.COUNT THEN                                                -- move the remaining elements of "right" array to the result array, if there are any 
                WHILE n_right_tab_counter < t_righthalf.COUNT LOOP
                    n_right_tab_counter := n_right_tab_counter + 1;
                    n_result_counter := n_result_counter + 1;
                    t_result_tab(n_result_counter) := t_righthalf(n_right_tab_counter);
                END LOOP; 
            END IF;
        ELSE
            RETURN p_tab_input;                                                                            -- if we finally have one element array in input, return it to next step - merge
        END IF;

    RETURN t_result_tab;   
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Fn_merge_sort error: ' || SQLCODE || ' ' || SQLERRM);
    END fn_merge_sort;


    PROCEDURE pr_merge_sort
    (p_input_numbers IN VARCHAR2)                                                           -- example procedure for show results 
    IS
        n_elements_count NUMBER;
        v_result VARCHAR2(4000);
        
        t_start_array t_tab;
        t_result_tab t_tab;
        
        ex_not_enough_numbers EXCEPTION;
    BEGIN
        IF p_input_numbers IS NOT NULL THEN
            n_elements_count := REGEXP_COUNT(p_input_numbers, '-?\d+');                     -- parse string to numbers (negatives too), check how many elements are there

            IF n_elements_count < 2 THEN
                RAISE ex_not_enough_numbers;
            END IF;
            
            FOR i IN 1 .. n_elements_count LOOP                                             -- put numbers into start array
                t_start_array(i) := REGEXP_SUBSTR(p_input_numbers, '-?\d+', 1, i);
            END LOOP;
        ELSE
            n_elements_count := ROUND(DBMS_RANDOM.VALUE(2, 50));                            -- if parameter is null, generate some randoms
                        
            FOR i IN 1 .. n_elements_count LOOP
                t_start_array(i) := ROUND(DBMS_RANDOM.VALUE(-1000, 1000));         
            END LOOP;
        END IF;
                    
        t_result_tab := fn_merge_sort(t_start_array);                                       -- call function, pass numbers and return sorted numbers to an array
                    
        FOR i IN t_result_tab.FIRST .. t_result_tab.LAST LOOP                               -- aggregate array elements to one string for show
            IF v_result IS NOT NULL THEN
                v_result := v_result || ', ' || t_result_tab(i);
            ELSE
                v_result := t_result_tab(i);
            END IF;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('[Merge sort] List of ' || n_elements_count || ' sorted numbers: ' || v_result);
    EXCEPTION
        WHEN ex_not_enough_numbers THEN
            RAISE_APPLICATION_ERROR(-20001, 'There should be at least two numbers to sort. Elements given by User: ' || n_elements_count);
    END pr_merge_sort;

    
    PROCEDURE pr_bubble_sort
        (p_input_numbers VARCHAR2 DEFAULT NULL)
        IS
        n_elements_count NUMBER;
        n_temp NUMBER;
        v_result VARCHAR2(4000);
        
        TYPE t_tab IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
        t_array_of_numbers t_tab;
        
        ex_not_enough_numbers EXCEPTION;
    BEGIN
        IF p_input_numbers IS NOT NULL THEN
            n_elements_count := REGEXP_COUNT(p_input_numbers, '-?\d+');                     

            IF n_elements_count < 2 THEN
                RAISE ex_not_enough_numbers;
            END IF;            
            
            FOR i IN 1 .. n_elements_count LOOP                                             
                t_array_of_numbers(i) := REGEXP_SUBSTR(p_input_numbers, '-?\d+', 1, i);
            END LOOP;
        ELSE
            n_elements_count := ROUND(DBMS_RANDOM.VALUE(2, 50));                            
                        
            FOR i IN 1 .. n_elements_count LOOP
                t_array_of_numbers(i) := ROUND(DBMS_RANDOM.VALUE(-1000, 1000));         
            END LOOP;
        END IF;

        FOR i IN t_array_of_numbers.FIRST .. t_array_of_numbers.COUNT LOOP                          -- traverse through all array elements
            FOR j IN t_array_of_numbers.FIRST .. t_array_of_numbers.COUNT - 1 LOOP                  -- last i elements are already in place
                IF t_array_of_numbers(j) > t_array_of_numbers(j + 1) THEN                           -- swap if the element found is greater than the next element
                    n_temp := t_array_of_numbers(j + 1);
                    t_array_of_numbers(j + 1) := t_array_of_numbers(j);
                    t_array_of_numbers(j) := n_temp;
                END IF;
            END LOOP;
        END LOOP;
        
        FOR i IN t_array_of_numbers.FIRST .. t_array_of_numbers.LAST LOOP                               
            IF v_result IS NOT NULL THEN
                v_result := v_result || ', ' || t_array_of_numbers(i);
            ELSE
                v_result := t_array_of_numbers(i);
            END IF;
        END LOOP;
            
        DBMS_OUTPUT.PUT_LINE('[Bubble sort] List of ' || n_elements_count || ' sorted numbers: ' || v_result);
    EXCEPTION
        WHEN ex_not_enough_numbers THEN
            RAISE_APPLICATION_ERROR(-20001, 'There should be at least two numbers to sort. Elements given by User: ' || n_elements_count);
    END pr_bubble_sort;
  
END sorting;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
EXECUTE sorting.pr_merge_sort('9,5,8,1,6,3,10,4,2,7,');

/* Script result: */
[Merge sort] List of 10 sorted numbers: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

---

/* Test: */
EXECUTE sorting.pr_merge_sort;

/* Script result: */
[Merge sort] List of 46 sorted numbers: -966, -943, -868, -818, -813, -777, -765, -759, -704, -651, -590, -471, -416, -352, -306, -289, -275, 
-102, -95, -86, -73, -56, -43, -37, -22, -2, 51, 88, 183, 215, 229, 244, 295, 306, 346, 439, 459, 483, 540, 606, 720, 838, 859, 884, 911, 955

---

/* Test: */
EXECUTE sorting.pr_merge_sort;

/* Script result: */
[Merge sort] List of 23 sorted numbers: -958, -727, -697, -672, -612, -584, -582, -556, -534, -531, -465, -427, -379, -360, -338, -336, -293, 
67, 164, 543, 695, 713, 989

--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

/* Test: */
EXECUTE sorting.pr_bubble_sort('4,1,10,3,5,8,6,9,7,2');

/* Script result: */
[Bubble sort] List of 10 sorted numbers: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

---

/* Test: */
EXECUTE sorting.pr_bubble_sort;

/* Script result: */
[Bubble sort] List of 36 sorted numbers: -950, -944, -881, -772, -762, -683, -601, -578, -543, -487, -440, -402, -342, -267, -179, -117, -61,
 1, 3, 131, 143, 164, 188, 258, 378, 407, 470, 473, 513, 516, 575, 615, 706, 770, 797, 856

---

/* Test: */
EXECUTE sorting.pr_bubble_sort;

/* Script result: */
[Bubble sort] List of 41 sorted numbers: -971, -902, -864, -829, -754, -688, -542, -540, -488, -456, -456, -421, -413, -407, -373, -344, -248,
 -133, -109, -80, -36, -28, 33, 157, 304, 317, 367, 421, 444, 460, 494, 636, 734, 779, 819, 850, 873, 880, 939, 969, 983

