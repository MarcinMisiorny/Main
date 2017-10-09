/*
* 
* Case: Distance Between Two Cities
* Description: Calculates the distance between two cities and allows the user to specify a unit of distance. 
* This program may require finding coordinates for the cities like latitude and longitude.
* 
* My comment:
* This case have been resolved in two ways: classic procedure with latitude and longitude parameters for both cities and solution based 
* on UTL_HTTP package - type two cities and in return you will get the distance. Whole data will be get as XML SOAP from 
* the Internet (Google Maps Geolocation API, access by https), parsed and finally calculated.
* 
*/
 
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;
SET DEFINE OFF;

/* First: */ 

CREATE OR REPLACE PROCEDURE pr_distance
(p_first_city_name IN VARCHAR2 DEFAULT NULL
,p_first_latitude IN NUMBER
,p_first_longitude IN NUMBER
,p_second_city_name IN VARCHAR2 DEFAULT NULL
,p_second_latitude IN NUMBER
,p_second_longitude IN NUMBER
,p_unit IN VARCHAR2 DEFAULT 'KM')
IS
    n_radius NUMBER;
    n_result NUMBER;
    n_degrees_to_radians CONSTANT NUMBER := 57.29577951;
    v_error_msg VARCHAR2(100);

    ex_empty_parameter EXCEPTION;
    ex_wrong_unit EXCEPTION;
BEGIN
    IF p_first_latitude IS NULL THEN
        v_error_msg := '"p_first_latitude"';
        RAISE ex_empty_parameter;
    ELSIF p_first_longitude IS NULL THEN
        v_error_msg := '"p_first_longitude"';
        RAISE ex_empty_parameter;
    ELSIF p_second_latitude IS NULL THEN	
        v_error_msg := '"p_second_latitude"';
        RAISE ex_empty_parameter;
    ELSIF p_second_longitude IS NULL THEN		
        v_error_msg := '"p_second_longitude"';
        RAISE ex_empty_parameter;
    END IF;
	
    IF p_unit NOT IN ('KM', 'MI') THEN
        RAISE ex_wrong_unit;
    END IF;
   
    -- Earth radius (6373 km or 3961 miles)
    IF p_unit = 'KM' THEN
        n_radius := 6373;
    ELSE
        n_radius := 3961;
    END IF;
    
    -- All calculations are based on Haversine formula. This is the method recommended for calculating short distances by Bob Chamberlain of Caltech and NASA's Jet Propulsion Laboratory 
    -- as described on the U.S. Census Bureau Web site.
    n_result := ROUND(2 * n_radius * ASIN(SQRT(POWER((SIN(((p_second_latitude - p_first_latitude) / n_degrees_to_radians) / 2)), 2)
               + COS(p_first_latitude / n_degrees_to_radians) * COS(p_second_latitude / n_degrees_to_radians) * POWER((SIN(((p_second_longitude - p_first_longitude) / n_degrees_to_radians) / 2)), 2))) ,2);
    
    IF p_first_city_name IS NOT NULL AND p_second_city_name IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Distance between ' || p_first_city_name || ' and ' || p_second_city_name || ' is ' || n_result || ' ' || p_unit);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Calculated distance is ' || n_result || ' ' || p_unit);
    END IF;
EXCEPTION
    WHEN ex_empty_parameter THEN
        RAISE_APPLICATION_ERROR(-20001, 'Parameter ' || v_error_msg || ' cannot be a NULL value.');
    WHEN ex_wrong_unit THEN
        RAISE_APPLICATION_ERROR(-20002, 'Incorrect distance unit. Allowed: ''KM'', ''MI''');
END pr_distance;
/
----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
CALL pr_distance (p_first_latitude => 51.1078852
,p_first_longitude => 17.0385376
,p_second_latitude => 52.4063740
,p_second_longitude => 16.9251681);

/* Script result: */
Calculated distance is 144,64 KM

---

/* Test: */
CALL pr_distance ('San Francisco', 37.773972, -122.431297, 'New York', 40.730610, -73.935242, 'MI');

/* Script result: */
Distance between San Francisco and New York is 2571,16 MI

----------------------------------------------------------------------------------------------------------------------------------------------

/* Second: */ 

-- Second, more complicated but IMHO better solution, is based on UTL_HTTP package. Unfortunately, as opposed to HTTP, the HTTPS protocol needs additional steps to configure to use 
-- and I can't do this easily as in before cases. This solution needs only two parameters - names of two cities (third parameter, unit of distance, is not required - it's default kilometers).
-- Now, How I did it:

-- 1. I've created ACL (Access Control List) for user DEMO. It grants user DEMO privilege to connect to Internet, the Google Maps site.

BEGIN
    DBMS_NETWORK_ACL_ADMIN.create_acl (
        acl          => 'google_acl_file.xml',
        description  => 'Connection to Google APIs',
        principal    => 'DEMO',
        is_grant     => TRUE,
        privilege    => 'connect',
        start_date   => SYSTIMESTAMP,
        end_date     => NULL);
 
    DBMS_NETWORK_ACL_ADMIN.assign_acl (
        acl         => 'google_acl_file.xml',
        host        => 'https://developers.google.com/maps/',
        lower_port  => 80,
        upper_port  => null);
END;
/

COMMIT;

-- 2. I've downloaded trusted certificate in fromat "X.509 Certificate with chain (PKCS#7)" [name of my saved certificate: 'googleapis.p7b'] from https://developers.google.com/maps/ to my Virtual Machine, to /Desktop localization.

-- 3. I've opened terminal to create Oracle Wallet with trusted certificate:

-- 3a. Location choosed and created to hold the wallet:

$ mkdir -p /home/oracle/documents/oracle_trusted_cert_wallet

-- 3b. New wallet created:

$ orapki wallet create -wallet /home/oracle/documents/oracle_trusted_cert_wallet -pwd WalletPasswd123 -auto_login

-- 3c. With the wallet created, I've added the Google's certificate I've saved earlier:

$ orapki wallet add -wallet /home/oracle/documents/oracle_trusted_cert_wallet -trusted_cert -cert "/home/oracle/Desktop/googleapis.p7b" -pwd WalletPsswd123

-- 4. In SQL Developer, I've setted wallet to use: 

SET DEFINE OFF; 
 
EXECUTE UTL_HTTP.SET_WALLET('file:/home/oracle/documents/oracle_trusted_cert_wallet', 'WalletPsswd123');

-- 5. External setup is done. Now, the main procedure:

CREATE OR REPLACE PROCEDURE pr_distance_between_cities 
(p_first_city IN VARCHAR2
,p_second_city IN VARCHAR2
,p_unit IN VARCHAR2 DEFAULT 'KM')
IS
    html_parts_first_city UTL_HTTP.HTML_PIECES;
    html_parts_second_city UTL_HTTP.HTML_PIECES;	
    
    n_first_city_latitude NUMBER;
    n_first_city_longitude NUMBER;
    n_second_city_latitude NUMBER;
    n_second_city_longitude NUMBER;
    n_radius NUMBER;
    n_result NUMBER;
    n_degrees_to_radians CONSTANT NUMBER := 57.29577951;
	
    ex_wrong_unit EXCEPTION;
BEGIN
    IF p_unit NOT IN ('KM', 'MI') THEN
        RAISE ex_wrong_unit;
    END IF;
	
    -- request for first city
    html_parts_first_city := UTL_HTTP.REQUEST_PIECES('https://maps.googleapis.com/maps/api/geocode/xml?&address=' || p_first_city);
    
    -- extract data [longitude and latitude for first city] from response
    SELECT    EXTRACTVALUE(XMLTYPE(html_parts_first_city(1)), '//result/geometry/location/lat/text()')
              ,EXTRACTVALUE(XMLTYPE(html_parts_first_city(1)), '//result/geometry/location/lng/text()') 
    INTO      n_first_city_latitude
              ,n_first_city_longitude
    FROM      dual;
     
    -- request for second city
    html_parts_second_city := UTL_HTTP.REQUEST_PIECES('https://maps.googleapis.com/maps/api/geocode/xml?&address=' || p_second_city);

    -- extract data [longitude and latitude for second city] from response
    SELECT    EXTRACTVALUE(XMLTYPE(html_parts_second_city(1)), '//result/geometry/location/lat/text()')
              ,EXTRACTVALUE(XMLTYPE(html_parts_second_city(1)), '//result/geometry/location/lng/text()') 
    INTO      n_second_city_latitude
              ,n_second_city_longitude
    FROM      dual;
    
    -- calculating distance
    -- Earth radius (6373 km or 3961 miles)
    IF p_unit = 'KM' THEN
        n_radius := 6373;
    ELSE
        n_radius := 3961;
    END IF;
	
    -- All calculations are based on Haversine formula. This is the method recommended for calculating short distances by Bob Chamberlain of Caltech and NASA's Jet Propulsion Laboratory 
    -- as described on the U.S. Census Bureau Web site.
    n_result := ROUND(2 * n_radius * ASIN(SQRT(POWER((SIN(((n_second_city_latitude - n_first_city_latitude) / n_degrees_to_radians) / 2)), 2)
           + COS(n_first_city_latitude / n_degrees_to_radians) * COS(n_second_city_latitude / n_degrees_to_radians) * POWER((SIN(((n_second_city_longitude - n_first_city_longitude) / n_degrees_to_radians) / 2)), 2))) ,2);
    
    DBMS_OUTPUT.PUT_LINE('Distance between ' || p_first_city|| ' and ' || p_second_city || ' is ' || n_result || ' ' || p_unit);
	
EXCEPTION
    WHEN ex_wrong_unit THEN
        RAISE_APPLICATION_ERROR(-20001, 'Incorrect distance unit. Allowed: ''KM'', ''MI''');
END pr_distance_between_cities;
/
----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
-- Moscow and Hangzhou
CALL pr_distance_between_cities('Москва', '杭州市'); 

/* Script result: */
Distance between Москва and 杭州市 is 6821.04 KM

---

/* Test: */
CALL pr_distance_between_cities('Skarsvåg', 'Struisbaai');

/* Script result: */
Distance between Skarsvåg and Struisbaai is: 11790.42 KM

---

/* Test: */
CALL pr_distance_between_cities('Anchorage', 'Chartres', 'MI');

/* Script result: */
Distance between Anchorage and Chartres is 4697.33 MI

