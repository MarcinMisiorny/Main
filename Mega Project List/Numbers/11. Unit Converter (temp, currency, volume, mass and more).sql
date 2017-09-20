/*
* 
* Case: Unit Converter (temp, currency, volume, mass and more)
* Description: Converts various units between one another. The user enters the type of unit being entered, the type of unit they 
* want to convert to and then the value. The program will then make the conversion.
* 
* My comment:
* Simple, but laborious function returns numbers.
* 
*/
 
----------------------------------------------------------------------------------------------------------------------------------------------

/* My solution: */ 

SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION fn_converter (p_category VARCHAR2, p_converted_value NUMBER, p_source_unit VARCHAR2, p_target_unit VARCHAR2, p_approximation NUMBER DEFAULT NULL)
RETURN NUMBER
IS
    n_result NUMBER;
    
    -- First, I need to have table with units, indexed by string (names of units), so I'll create associative table
    TYPE t_table_of_units IS TABLE OF NUMBER INDEX BY VARCHAR2(100);
    t_units_table t_table_of_units;
    
    -- Extra table for temperature
    TYPE t_table_of_temperature IS TABLE OF NUMBER INDEX BY VARCHAR2(20);
    t_temperature_increment t_table_of_temperature;
    
    ex_wrong_category EXCEPTION;
    
    -- Second, I need to check correctness of parameters, there is no possibility to convert, for example, meters to degrees of celcius 
    PROCEDURE pr_check_parameters(p_category_check VARCHAR2, p_source_unit_check VARCHAR2, p_target_unit_check VARCHAR2)
    IS
        b_source_unit BOOLEAN;
        b_target_unit BOOLEAN;
        v_error_msg VARCHAR2(50);
        
        ex_wrong_unit EXCEPTION;
    BEGIN
        b_source_unit := t_units_table.EXISTS(p_source_unit_check);
        b_target_unit := t_units_table.EXISTS(p_target_unit_check);
        
        IF NOT b_source_unit THEN
            v_error_msg := p_source_unit_check;
            RAISE ex_wrong_unit;
        ELSIF NOT b_target_unit THEN
            v_error_msg := p_target_unit_check;
            RAISE ex_wrong_unit;
        END IF;
    EXCEPTION
        WHEN ex_wrong_unit THEN
            RAISE_APPLICATION_ERROR(-20001, 'There is no unit "' || v_error_msg || '" in category "' || p_category_check || '". For help compile and execute procedure pr_converter_help');
    END;
BEGIN
    -- Fulfill table of units with numbers (only for current category, given in p_category parameter)
    IF p_category = 'acceleration' THEN
        t_units_table('meter/sq.sec') := 1;
        t_units_table('foot/sq.se')   := .3048;
        t_units_table('g')            := 9.806650;
        t_units_table('galileo')      := .01;
        t_units_table('inch/sq.sec')  := 2.54E-02;
        
        pr_check_parameters(p_category, p_source_unit, p_target_unit);
    
    ELSIF p_category = 'area' THEN
        t_units_table('square_meter')      := 1;    
        t_units_table('acre')              := 4046.856;
        t_units_table('are')               := 100;    
        t_units_table('barn')              := 1E-28;    
        t_units_table('hectare')           := 10000;    
        t_units_table('rood')              := 1011.71413184285;
        t_units_table('square_centimeter') := .0001;    
        t_units_table('square_kilometer')  := 1000000;    
        t_units_table('circular_mil')      := 5.067075E-10;    
        t_units_table('square_foot')       := 9.290304E-02;    
        t_units_table('square_inch')       := 6.4516E-04;    
        t_units_table('square_mile')       := 2589988;    
        t_units_table('square_yard')       := .8361274;
    
        pr_check_parameters(p_category, p_source_unit, p_target_unit);
    
    ELSIF p_category = 'density_and_mass_capacity' THEN
        t_units_table('kilogram/cub.meter')    := 1;
        t_units_table('grain/galon')           := .01711806;
        t_units_table('grams/cm^3')            := 1000;
        t_units_table('pound_mass/cubic_foot') := 16.01846;
        t_units_table('pound_mass/cubic_inch') := 27679.91;
        t_units_table('ounces/gallon_uk')      := 6.236027;
        t_units_table('ounces/gallon_us')      := 7.489152;
        t_units_table('ounces_mass/inch')      := 1729.994;
        t_units_table('pound_mass/gal_uk')     := 99.77644;
        t_units_table('pound_mass/gal_us')     := 119.8264;
        t_units_table('slug/cubic_foot')       := 515.379;
        t_units_table('tons/cub.yard')         := 1328.939;
    
        pr_check_parameters(p_category, p_source_unit, p_target_unit);
    
    ELSIF p_category = 'electricity' THEN
        t_units_table('coulomb')      := 1;
        t_units_table('abcoulomb')    := 10;
        t_units_table('amperehour')   := 3600;
        t_units_table('faraday')      := 96521.8999999997;
        t_units_table('statcoulomb')  := .000000000333564;
        t_units_table('millifaraday') := 96.5219;
        t_units_table('microfaraday') := 9.65219E-02;
        t_units_table('picofaraday')  := 9.65219E-05;

        pr_check_parameters(p_category, p_source_unit, p_target_unit);
    
    ELSIF p_category = 'energy' THEN
        t_units_table('joule')              := 1;
        t_units_table('btu_mean')           := 1055.87;
        t_units_table('btu_thermochemical') := 1054.35;
        t_units_table('calorie_si')         := 4.1868;
        t_units_table('calorie_mean')       := 4.19002;
        t_units_table('calorie_thermo')     := 4.184;
        t_units_table('electron_volt')      := 1.6021E-19;
        t_units_table('erg')                := .0000001;
        t_units_table('foot_pound_force')   := 1.355818;
        t_units_table('foot_poundal')       := 4.214011E-02;
        t_units_table('horsepower_hour')    := 2684077.3;
        t_units_table('kilocalorie_si')     := 4186.8;
        t_units_table('kilocalorie_mean')   := 4190.02;
        t_units_table('kilowatt_hour')      := 3600000;
        t_units_table('ton_of_tnt')         := 4.2E9;
        t_units_table('volt_coulomb')       := 1;
        t_units_table('watt_hour')          := 3600;
        t_units_table('watt_second')        := 1;
        
        pr_check_parameters(p_category, p_source_unit, p_target_unit);
    
    ELSIF p_category = 'force' THEN
        t_units_table('newton')         := 1;
        t_units_table('dyney')          := .00001;
        t_units_table('kilogram_force') := 9.806650;
        t_units_table('kilopond_force') := 9.806650;
        t_units_table('kip')            := 4448.222;
        t_units_table('ounce_force')    := .2780139;
        t_units_table('pound_force')    := .4535924;
        t_units_table('poundal')        := .138255;
        
        pr_check_parameters(p_category, p_source_unit, p_target_unit);
    
    ELSIF p_category = 'force/length' THEN
        t_units_table('newton/meter')     := 1;
        t_units_table('pound_force/inch') := 175.1268;
        t_units_table('pound_force/foot') := 14.5939;     
        
        pr_check_parameters(p_category, p_source_unit, p_target_unit);
    
    ELSIF p_category = 'length' THEN
        t_units_table('meter')              := 1;
        t_units_table('angstrom')           := 1E-10;
        t_units_table('astronomical_unit')  := 1.49598E11;
        t_units_table('caliber')            := .000254;
        t_units_table('centimeter')         := .01;
        t_units_table('kilometer')          := 1000;
        t_units_table('ell')                := 1.143;
        t_units_table('em')                 := 4.2323E-03;
        t_units_table('fathom')             := 1.8288;
        t_units_table('furlong')            := 201.168;
        t_units_table('fermi')              := 1E-15;
        t_units_table('foot')               := .3048;
        t_units_table('inch')               := .0254;
        t_units_table('league_int')         := 5556;
        t_units_table('league_uk')          := 5556;
        t_units_table('lightyear')          := 9.46055E+15;
        t_units_table('micrometer')         := .000001;
        t_units_table('mil')                := .0000254;
        t_units_table('millimeter')         := .001;
        t_units_table('nanometer')          := 1E-9;
        t_units_table('mile_intl_nautical') := 1852;
        t_units_table('mile_uk_nautical')   := 1853.184;
        t_units_table('mile_us_nautical')   := 1852;
        t_units_table('mile_us_statute')    := 1609.344;
        t_units_table('parsec')             := 3.08374E+16;
        t_units_table('pica')               := 4.217518E-03;
        t_units_table('picometer')          := 1E-12;
        t_units_table('point')              := .0003514598;
        t_units_table('rod')                := 5.0292;
        t_units_table('yard')               := .9144;
        
        pr_check_parameters(p_category, p_source_unit, p_target_unit);
    
    ELSIF p_category = 'light' THEN
        t_units_table('lumen/sq.meter')        := 1;
        t_units_table('lumen/sq.centimeter')   := 10000;
        t_units_table('lumen/sq.foot')         := 10.76391;
        t_units_table('foot_candle')           := 10.76391;
        t_units_table('foot_lambert')          := 10.76391;
        t_units_table('candela/sq.meter')      := 3.14159250538575;
        t_units_table('candela/sq.centimeter') := 31415.9250538576;
        t_units_table('lux')                   := 1;
        t_units_table('phot')                  := 10000;
        
        pr_check_parameters(p_category, p_source_unit, p_target_unit);
    
    ELSIF p_category = 'mass' THEN
        t_units_table('kilogram')            := 1;
        t_units_table('gram')                := .001;
        t_units_table('milligram')           := 1E-6;
        t_units_table('microgram')           := .000000001;
        t_units_table('carat')               := .0002;
        t_units_table('hundredweight_long')  := 50.80235;
        t_units_table('hundredweight_short') := 45.35924;
        t_units_table('pound_mass_lbm')      := .4535924;
        t_units_table('pound_mass_troy')     := .3732417;
        t_units_table('ounce_mass_ozm')      := .02834952;
        t_units_table('ounce_mass_troy')     := .03110348;
        t_units_table('slug')                := 14.5939;
        t_units_table('ton_assay')           := .02916667;
        t_units_table('ton_long')            := 1016.047;
        t_units_table('ton_short')           := 907.1847;
        t_units_table('ton_metric')          := 1000;
        t_units_table('tonne')               := 1000;
        
        pr_check_parameters(p_category, p_source_unit, p_target_unit);
    
    ELSIF p_category = 'mass_flow' THEN
        t_units_table('kilogram/second') := 1;
        t_units_table('pound_mass/sec')  := .4535924;
        t_units_table('pound_mass/min')  := .007559873;
        
        pr_check_parameters(p_category, p_source_unit, p_target_unit);
    
    ELSIF p_category = 'power' THEN
        t_units_table('watt')                    := 1;
        t_units_table('kilowatt')                := 1000;
        t_units_table('megawatt')                := 1000000;
        t_units_table('milliwatt')               := .001;
        t_units_table('btu_si/hour')             := .2930667;
        t_units_table('btu_thermo/second')       := 1054.35;
        t_units_table('btu_thermo/minute')       := 17.5725;
        t_units_table('btu_thermo/hour')         := .2928751;
        t_units_table('calorie_thermo/second')   := 4.184;
        t_units_table('calorie_thermo/minute')   := 6.973333E-02;
        t_units_table('erg/second')              := .0000001;
        t_units_table('foot_pound_force/hour')   := .0003766161;
        t_units_table('foot_pound_force/minute') := .02259697;
        t_units_table('foot_pound_force/second') := 1.355818;
        t_units_table('horsepower_550_ft_lbf/s') := 745.7;
        t_units_table('horsepower_electric')     := 746;
        t_units_table('horsepower_boiler')       := 9809.5;
        t_units_table('horsepower_metric')       := 735.499;
        t_units_table('horsepower_uk')           := 745.7;
        t_units_table('kilocalorie_thermo/min')  := 69.7333;
        t_units_table('kilocalorie_thermo/sec')  := 4184;
    
        pr_check_parameters(p_category, p_source_unit, p_target_unit);
    
    ELSIF p_category = 'pressure_and_stress' THEN
        t_units_table('newton/sq.meter')         := 1;
        t_units_table('atmosphere_normal')       := 101325;
        t_units_table('atmosphere_techinical')   := 98066.5;
        t_units_table('bar')                     := 100000;
        t_units_table('centimeter_mercury')      := 1333.22;
        t_units_table('centimeter_water')        := 98.0638;
        t_units_table('decibar')                 := 10000;
        t_units_table('kgr_force/sq.centimeter') := 98066.5;
        t_units_table('kgr_force/sq.meter')      := 9.80665;
        t_units_table('kip/square_inch')         := 6894757;
        t_units_table('millibar')                := 100;
        t_units_table('millimeter_mercury')      := 133.3224;
        t_units_table('pascal')                  := 1;
        t_units_table('kilopascal')              := 1000;
        t_units_table('megapascal')              := 1000000;
        t_units_table('poundal/sq.foot')         := 47.88026;
        t_units_table('pound-force/sq.foot')     := 47.88026;
        t_units_table('pound-force/sq.inch')     := 6894.757;
        t_units_table('torr')                    := 133.322;
    
        pr_check_parameters(p_category, p_source_unit, p_target_unit);
    
    ELSIF p_category = 'temperature' THEN
        t_units_table('degrees_celsius')    := 1;
        t_units_table('degrees_fahrenheit') := 0.555555555555;
        t_units_table('degrees_kelvin')     := 1;
        t_units_table('degrees_rankine')    := 0.555555555555;

        t_temperature_increment('degrees_celsius')    := 0;
        t_temperature_increment('degrees_fahrenheit') := -32;
        t_temperature_increment('degrees_kelvin')     := -273.15;
        t_temperature_increment('degrees_rankine')    := -491.67;
    
        pr_check_parameters(p_category, p_source_unit, p_target_unit);
    
    ELSIF p_category = 'time' THEN
        t_units_table('second')              := 1;
        t_units_table('day_mean_solar')      := 8.640E4;
        t_units_table('day_sidereal')        := 86164.09;
        t_units_table('hour_mean_solar')     := 3600;
        t_units_table('hour_sidereal')       := 3590.17;
        t_units_table('minute_mean_solar')   := 60;
        t_units_table('minute_sidereal')     := 60;
        t_units_table('month_mean_calendar') := 2628000;
        t_units_table('second_sidereal')     := .9972696;
        t_units_table('year_calendar')       := 31536000;
        t_units_table('year_tropical')       := 31556930;
        t_units_table('year_sidereal')       := 31558150;
    
        pr_check_parameters(p_category, p_source_unit, p_target_unit);
    
    ELSIF p_category = 'torque' THEN
        t_units_table('newton_meter')    := 1;
        t_units_table('dyne_centimeter') := .0000001;
        t_units_table('kgrf_meter')      := 9.806650;
        t_units_table('lbf_inch')        := .1129848;
        t_units_table('lbf_foot')        := 1.355818;
    
        pr_check_parameters(p_category, p_source_unit, p_target_unit);
    
    ELSIF p_category = 'velocity_and_speed' THEN
        t_units_table('meter/second')       := 1;
        t_units_table('foot/minute')        := 5.08E-03;
        t_units_table('foot/second')        := .3048;
        t_units_table('kilometer/hour')     := .2777778;
        t_units_table('knot')               := .5144444;
        t_units_table('mile_us/hour')       := .44707;
        t_units_table('mile_nautical/hour') := .514444;
        t_units_table('mile_us/minute')     := 26.8224;
        t_units_table('mile_us/second')     := 1609.344;
        t_units_table('speed_of_light')     := 299792458;
        t_units_table('mach_stp')           := 340.0068750;
    
        pr_check_parameters(p_category, p_source_unit, p_target_unit);
    
    ELSIF p_category = 'viscosity' THEN
        t_units_table('newton_second/meter')        := 1;
        t_units_table('centipoise')                 := .001;
        t_units_table('centistoke')                 := .000001;
        t_units_table('sq.foot/second')             := 9.290304E-02;
        t_units_table('poise')                      := .1;
        t_units_table('poundal_second/sq.foot')     := 1.488164;
        t_units_table('pound_mass/foot_second')     := 1.488164;
        t_units_table('pound_force_second/sq.foot') := 47.88026;
        t_units_table('rhe')                        := 10;
        t_units_table('slug/foot_second')           := 47.88026;
        t_units_table('stoke')                      := .0001;
    
        pr_check_parameters(p_category, p_source_unit, p_target_unit);
    
    ELSIF p_category = 'volume_and_capacity' THEN
        t_units_table('cubic_meter')      := 1;
        t_units_table('cubic_centimeter') := .000001;
        t_units_table('cubic_millimeter') := .000000001;
        t_units_table('acre_foot')        := 1233.482;
        t_units_table('barrel_oil')       := .1589873;
        t_units_table('board_foot')       := .002359737;
        t_units_table('bushel_us')        := .03523907;
        t_units_table('cup')              := .0002365882;
        t_units_table('fluid_ounce_us')   := .00002957353;
        t_units_table('cubic_foot')       := .02831685;
        t_units_table('gallon_uk')        := .004546087;
        t_units_table('gallon_us_dry')    := .004404884;
        t_units_table('gallon_us_liq')    := .003785412;
        t_units_table('gill_uk')          := .0001420652;
        t_units_table('gill_us')          := .0001182941;
        t_units_table('cubic_inch')       := .00001638706;
        t_units_table('liter_new')        := .001;
        t_units_table('liter_old')        := .001000028;
        t_units_table('ounce_uk_fluid')   := .00002841305;
        t_units_table('ounce_us_fluid')   := .00002957353;
        t_units_table('peck_us')          := 8.8097680E-03;
        t_units_table('pint_us_dry')      := .0005506105;
        t_units_table('pint_us_liq')      := 4.7317650E-04;
        t_units_table('quart_us_dry')     := .001101221;
        t_units_table('quart_us_liq')     := 9.46353E-04;
        t_units_table('stere')            := 1;
        t_units_table('tablespoon')       := .00001478676;
        t_units_table('teaspoon')         := .000004928922;
        t_units_table('ton_register')     := 2.831685;
        t_units_table('cubic_yard')       := .7645549;
    
        pr_check_parameters(p_category, p_source_unit, p_target_unit);
    
    ELSIF p_category = 'volume_flow' THEN
        t_units_table('cubic_meter/second')    := 1;
        t_units_table('cubic_foot/second')     := .02831685;
        t_units_table('cubic_foot/minute')     := .0004719474;
        t_units_table('cubic_inches/minute')   := 2.731177E-7;
        t_units_table('gallons_US_liq/minute') := 6.309020E-05;
    
        pr_check_parameters(p_category, p_source_unit, p_target_unit);
    ELSE
        RAISE ex_wrong_category;
    END IF;

    IF p_category != 'temperature' THEN
        n_result := (p_converted_value * t_units_table(p_source_unit)) / t_units_table(p_target_unit);
    ELSE
        n_result := (p_converted_value + t_temperature_increment(p_source_unit) * t_units_table(p_source_unit)) / t_units_table(p_target_unit) - t_temperature_increment(p_target_unit);
    END IF;
        
    IF p_approximation IS NOT NULL THEN
        n_result := ROUND(n_result, p_approximation);
    END IF;

RETURN n_result;
EXCEPTION
    WHEN ex_wrong_category THEN
        RAISE_APPLICATION_ERROR(-20001, 'Category "' || p_category || '" does not exists for this function. For help compile and execute procedure pr_converter_help');
END fn_converter;
/

CREATE OR REPLACE PROCEDURE pr_converter_help
IS
BEGIN
	DBMS_OUTPUT.PUT_LINE('Function fn_converter is defined with 5 parameters: fn_converter(p_category VARCHAR2, p_converted_value NUMBER, p_source_unit VARCHAR2, p_target_unit VARCHAR2, p_approximation NUMBER DEFAULT NULL).
First parameter is category where converted unit belongs, for example mass, acceleration, speed, light, torque, etc.
Second parameter is the value (number), what we want to convert. 
Third parameter is unit for value from second parameter.
Fourth parameter is target unit what we want to receive.
Last parameter is additional parameter to round result - it''s number (integer) of decimal places in result.');
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE('Example, how to call function: SELECT fn_converter(''mass'', 15, ''kilogram'', ''gram'', 2) FROM DUAL;');
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE('Below are listed (in alphabetical order) categories, avaliable unit for conversion in each category and unit expressed as formal parameter of function.');
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE('Acceleration 
Formal parameter for "p_category": ''acceleration''
Unit => Formal parameter for "p_source_unit" and "p_target_unit":
- Meter/sq.sec (m/sec^2) => ''meter/sq.sec''
- Foot/sq.sec (ft/sec^2) => ''foot/sq.se''
- G (g) => ''g''
- Galileo (gal) => ''galileo''
- Inch/sq.sec (in/sec^2) => ''inch/sq.sec''');
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE('Area
Formal parameter for "p_category": ''area''
Unit => Formal parameter for "p_source_unit" and "p_target_unit":
- Square meter (m^2) => ''square_meter''
- Acre (acre) => ''acre''
- Are => ''are''
- Barn (barn) => ''barn''
- Hectare => ''hectare''
- Rood => ''rood''
- Square centimeter => ''square_centimeter''
- Square kilometer => ''square_kilometer''
- Circular mil => ''circular_mil''
- Square foot (ft^2) => ''square_foot''
- Square inch (in^2) => ''square_inch''
- Square mile (mi^2) => ''square_mile''
- Square yard (yd^2) => ''square_yard''');
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE('Density and Mass capacity
Formal parameter for "p_category": ''density_and_mass_capacity''
Unit => Formal parameter for "p_source_unit" and "p_target_unit":
Kilogram/cub.meter => ''kilogram/cub.meter''
- Grain/galon => ''grain/galon''
- Grams/cm^3 (gr/cc) => ''grams/cm^3''
- Pound mass/cubic foot => ''pound_mass/cubic_foot''
- Pound mass/cubic-inch => ''pound_mass/cubic_inch''
- Ounces/gallon (UK,liq) => ''ounces/gallon_uk''
- Ounces/gallon (US,liq) => ''ounces/gallon_us''
- Ounces (mass)/inch => ''ounces_mass/inch''
- Pound mass/gal (UK,liq) => ''pound_mass/gal_uk''
- Pound mass/gal (US,liq) => ''pound_mass/gal_us''
- Slug/cubic foot => ''slug/cubic_foot''
- Tons (long,mass)/cub.yard => ''tons/cub.yard''');
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE('Electricity
Formal parameter for "p_category": ''electricity''
Unit => Formal parameter for "p_source_unit" and "p_target_unit":
- Coulomb (Cb) => ''coulomb''
- Abcoulomb => ''abcoulomb''
- Ampere hour (A hr) => ''ampere hour''
- Faraday (F) => ''faraday''
- Statcoulomb => ''statcoulomb''
- Millifaraday (mF) => ''millifaraday''
- Microfaraday (mu-F) => ''microfaraday''
- Picofaraday (pF) => ''picofaraday''');
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE('Energy
Formal parameter for "p_category": ''energy''
Unit => Formal parameter for "p_source_unit" and "p_target_unit":
- Joule (J) => ''joule''
- BTU (mean) => ''btu_mean''
- BTU (thermochemical) => ''btu_thermochemical''
- Calorie (SI) (cal) => ''calorie_si''
- Calorie (mean)(cal) => ''calorie_mean''
- Calorie (thermo) => ''calorie_thermo''
- Electron volt (eV) => ''electron_volt''
- Erg (erg) => ''erg''
- Foot-pound force => ''foot_pound_force''
- Foot-poundal => ''foot_poundal''
- Horsepower-hour => ''horsepower_hour''
- Kilocalorie (SI)(kcal) => ''kilocalorie_si''
- Kilocalorie (mean)(kcal) => ''kilocalorie_mean''
- Kilowatt-hour (kW hr) => ''kilowatt_hour''
- Ton of TNT => ''ton_of_tnt''
- Volt-coulomb (V Cb) => ''volt_coulomb''
- Watt-hour (W hr) => ''watt_hour''
- Watt-second (W sec) => ''watt_second'''); 
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE('Force
Formal parameter for "p_category": ''force''
Unit => Formal parameter for "p_source_unit" and "p_target_unit":
- Newton (N) => ''newton''
- Dyne (dy) => ''dyney''
- Kilogram force (kgf) => ''kilogram_force''
- Kilopond force (kpf) => ''kilopond_force''
- Kip (k) => ''kip''
- Ounce force (ozf) => ''ounce_force''
- Pound force (lbf) => ''pound_force''
- Poundal => ''poundal''');
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE('Force/Length
Formal parameter for "p_category": ''force/length''
Unit => Formal parameter for "p_source_unit" and "p_target_unit":
- Newton/meter (N/m) => ''newton/meter''
- Pound force/inch (lbf/in) => ''pound_force/inch''
- Pound force/foot (lbf/ft) => ''pound_force/foot''');
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE('Length
Formal parameter for "p_category": ''length''
Unit => Formal parameter for "p_source_unit" and "p_target_unit":	
- Meter (m) => ''meter''
- Angstrom (A'') => ''angstrom''
- Astronomical unit (AU) => ''astronomical_unit''
- Caliber (cal) => ''caliber''
- Centimeter (cm) => ''centimeter''
- Kilometer (km) => ''kilometer''
- Ell => ''ell''
- Em => ''em''
- Fathom => ''fathom''
- Furlong => ''furlong''
- Fermi (fm) => ''fermi''
- Foot (ft) => ''foot''
- Inch (in) => ''inch''
- League (int''l) => ''league_int''
- League (UK) => ''league_uk''
- Light year (LY) => ''light year''
- Micrometer (mu-m) => ''micrometer''
- Mil => ''mil''
- Millimeter (mm) => ''millimeter''
- Nanometer (nm) => ''nanometer''
- Mile (int''l nautical) => ''mile_intl_nautical''
- Mile (UK nautical) => ''mile_uk_nautical''
- Mile (US nautical) => ''mile_us_nautical''
- Mile (US statute) => ''mile_us_statute''
- Parsec => ''parsec''
- Pica (printer) => ''pica''
- Picometer (pm) => ''picometer''
- Point (pt) => ''point''
- Rod => ''rod''
- Yard (yd) => ''yard''');
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE('Light
Formal parameter for "p_category": ''light''
Unit => Formal parameter for "p_source_unit" and "p_target_unit":
- Lumen/sq.meter (Lu/m^2) => ''lumen/sq.meter''
- Lumen/sq.centimeter => ''lumen/sq.centimeter''
- Lumen/sq.foot => ''lumen/sq.foot''
- Foot-candle (ft-cdl) => ''foot_candle''
- Foot-lambert => ''foot_lambert''
- Candela/sq.meter => ''candela/sq.meter''
- Candela/sq.centimeter => ''candela/sq.centimeter''
- Lux (lux) => ''lux''
- Phot => ''phot''');
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE('Mass 
Formal parameter for "p_category": ''mass''
Unit => Formal parameter for "p_source_unit" and "p_target_unit":
- Kilogram (kgr) => ''kilogram''
- Gram (gr) => ''gram''
- Milligram (mgr) => ''milligram''
- Microgram (mu-gr) => ''microgram''
- Carat (metric)(ct) => ''carat''
- Hundredweight (long) => ''hundredweight_long''
- Hundredweight (short) => ''hundredweight_short''
- Pound mass (lbm) => ''pound_mass_lbm''
- Pound mass (troy) => ''pound_mass_troy''
- Ounce mass (ozm) => ''ounce_mass_ozm''
- Ounce mass (troy) => ''ounce_mass_troy''
- Slug => ''slug''
- Ton (assay) => ''ton_assay''
- Ton (long) => ''ton_long''
- Ton (short) => ''ton_short''
- Ton (metric) => ''ton_metric''
- Tonne => tonne''');
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE('Mass Flow
Formal parameter for "p_category": ''mass_flow''
Unit => Formal parameter for "p_source_unit" and "p_target_unit":
- Kilogram/second (kgr/sec) => ''kilogram/second''
- Pound mass/sec (lbm/sec) => ''pound_mass/sec''
- Pound mass/min (lbm/min) => ''pound_mass/min''');
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE('Power
Formal parameter for "p_category": ''power''
Unit => Formal parameter for "p_source_unit" and "p_target_unit":
- Watt (W) => ''watt''
- Kilowatt (kW) => ''kilowatt''
- Megawatt (MW) => ''megawatt''
- Milliwatt (mW) => ''milliwatt''
- BTU (SI)/hour => ''btu_si/hour''
- BTU (thermo)/second => ''btu_thermo/second''
- BTU (thermo)/minute => ''btu_thermo/minute''
- BTU (thermo)/hour => ''btu_thermo/hour''
- Calorie (thermo)/second => ''calorie_thermo/second''
- Calorie (thermo)/minute => ''calorie_thermo/minute''
- Erg/second => ''erg/second''
- Foot-pound force/hour => ''foot_pound_force/hour''
- Foot-pound force/minute => ''foot_pound_force/minute''
- Foot-pound force/second => ''foot_pound_force/second''
- Horsepower(550 ft lbf/s) => ''horsepower_550_ft_lbf/s''
- Horsepower (electric) => ''horsepower_electric''
- Horsepower (boiler) => ''horsepower_boiler''
- Horsepower (metric) => ''horsepower_metric''
- Horsepower (UK) => ''horsepower_uk''
- Kilocalorie (thermo)/min => ''kilocalorie_thermo/min''
- Kilocalorie (thermo)/sec => ''kilocalorie_thermo/sec''');
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE('Pressure and Stress 
Formal parameter for "p_category": ''pressure_and_stress''
Unit => Formal parameter for "p_source_unit" and "p_target_unit":	
- Newton/sq.meter => ''newton/sq.meter''
- Atmosphere (normal) => ''atmosphere_normal''
- Atmosphere (techinical) => ''atmosphere_techinical''
- Bar => ''bar''
- Centimeter mercury(cmHg) => ''centimeter_mercury''
- Centimeter water (4''C) => ''centimeter_water''
- Decibar => ''decibar''
- Kgr force/sq.centimeter => ''kgr_force/sq.centimeter''
- Kgr force/sq.meter => ''kgr_force/sq.meter''
- Kip/square inch => ''kip/square_inch''
- Millibar => ''millibar''
- Millimeter mercury(mmHg) => ''millimeter_mercury''
- Pascal (Pa) => ''pascal''
- Kilopascal (kPa) => ''kilopascal''
- Megapascal (Mpa) => ''megapascal''
- Poundal/sq.foot => ''poundal/sq.foot''
- Pound-force/sq.foot => ''pound-force/sq.foot''
- Pound-force/sq.inch (psi) => ''pound-force/sq.inch''
- Torr (mmHg,0''C) => ''torr''');
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE('Temperature
Formal parameter for "p_category": ''temperature''
Unit => Formal parameter for "p_source_unit" and "p_target_unit":	
- Degrees Celsius (''C) => ''degrees_celsius''
- Degrees Fahrenheit (''F) => ''degrees_fahrenheit''
- Degrees Kelvin (''K) => ''degrees_kelvin''
- Degrees Rankine (''R) => ''degrees_rankine''');
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE('Time
Formal parameter for "p_category": ''time''
Unit => Formal parameter for "p_source_unit" and "p_target_unit":
- Second (sec) => ''second''
- Day (mean solar) => ''day_mean_solar''
- Day (sidereal) => ''day_sidereal''
- Hour (mean solar) => ''hour_mean_solar''
- Hour (sidereal) => ''hour_sidereal''
- Minute (mean solar) => ''minute_mean_solar''
- Minute (sidereal) => ''minute_sidereal''
- Month (mean calendar) => ''month_mean_calendar''
- Second (sidereal) => ''second_sidereal''
- Year (calendar) => ''year_calendar''
- Year (tropical) => ''year_tropical''
- Year (sidereal) => ''year_sidereal''');
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE('Torque
Formal parameter for "p_category": ''torque''
Unit => Formal parameter for "p_source_unit" and "p_target_unit":
- Newton-meter (N m) => ''newton_meter''
- Dyne-centimeter(dy cm) => ''dyne_centimeter''
- Kgrf-meter (kgf m) => ''kgrf_meter''
- lbf-inch (lbf in) => ''lbf_inch''
- lbf-foot (lbf ft) => ''lbf_foot''');
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE('Velocity and Speed
Formal parameter for "p_category": ''velocity_and_speed''
Unit => Formal parameter for "p_source_unit" and "p_target_unit":
- Meter/second (m/sec) => ''meter/second''
- Foot/minute (ft/min) => ''foot/minute''
- Foot/second (ft/sec) => ''foot/second''
- Kilometer/hour (kph) => ''kilometer/hour''
- Knot (int''l) => ''knot''
- Mile (US)/hour (mph) => ''mile_us/hour''
- Mile (nautical)/hour => ''mile_nautical/hour''
- Mile (US)/minute => ''mile_us/minute''
- Mile (US)/second => ''mile_us/second''
- Speed of light (c) => ''speed_of_light''
- Mach (STP)(a) => ''mach_stp''');
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE('Viscosity
Formal parameter for "p_category": ''viscosity''
Unit => Formal parameter for "p_source_unit" and "p_target_unit":
- Newton-second/meter => ''newton_second/meter''
- Centipoise => ''centipoise''
- Centistoke => ''centistoke''
- Sq.foot/second => ''sq.foot/second''
- Poise => ''poise''
- Poundal-second/sq.foot => ''poundal_second/sq.foot''
- Pound mass/foot-second => ''pound_mass/foot_second''
- Pound force-second/sq.foot => ''pound_force_second/sq.foot''
- Rhe => ''rhe''
- Slug/foot-second => ''slug/foot_second''
- Stoke => ''stoke''');
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE('Volume and Capacity
Formal parameter for "p_category": ''volume_and_capacity''
Unit => Formal parameter for "p_source_unit" and "p_target_unit":
- Cubic Meter (m^3) => ''cubic_meter''
- Cubic centimeter => ''cubic_centimeter''
- Cubic millimeter => ''cubic_millimeter''
- Acre-foot => ''acre_foot''
- Barrel (oil) => ''barrel_oil''
- Board foot => ''board_foot''
- Bushel (US) => ''bushel_us''
- Cup => ''cup''
- Fluid ounce (US) => ''fluid_ounce_us''
- Cubic foot => ''cubic_foot''
- Gallon (UK) => ''gallon_uk''
- Gallon (US,dry) => ''gallon_us_dry''
- Gallon (US,liq) => ''gallon_us_liq''
- Gill (UK) => ''gill_uk''
- Gill (US) => ''gill_us''
- Cubic inch (in^3) => ''cubic_inch''
- Liter (new) => ''liter_new''
- Liter (old) => ''liter_old''
- Ounce (UK,fluid) => ''ounce_uk_fluid''
- Ounce (US,fluid) => ''ounce_us_fluid''
- Peck (US) => ''peck_us''
- Pint (US,dry) => ''pint_us_dry''
- Pint (US,liq) => ''pint_us_liq''
- Quart (US,dry) => ''quart_us_dry''
- Quart (US,liq) => ''quart_us_liq''
- Stere => ''stere''
- Tablespoon => ''tablespoon''
- Teaspoon => ''teaspoon''
- Ton (register) => ''ton_register''
- Cubic yard => ''cubic_yard''');
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE('Volume Flow
Formal parameter for "p_category": ''volume_flow''
Unit => Formal parameter for "p_source_unit" and "p_target_unit":
- Cubic meter/second => ''cubic_meter/second''
- Cubic foot/second => ''cubic_foot/second''
- Cubic foot/minute => ''cubic_foot/minute''
- Cubic inches/minute => ''cubic_inches/minute''
- Gallons (US,liq)/minute) => ''gallons_US_liq/minute''');

END pr_converter_help;
/

----------------------------------------------------------------------------------------------------------------------------------------------

/* Test: */
SELECT  fn_converter('time',  1234567890, 'second', 'year_calendar') 
FROM    dual;

/* Script result: */
39,14789098173515981735159817351598173516

---
/* Test: */
SELECT  fn_converter('temperature',  26, 'degrees_celsius', 'degrees_rankine', 2)
FROM    dual;

/* Script result: */
538,47

---
/* Test: */
SELECT  fn_converter('mass',  26, 'carat', 'gram')
FROM    dual;

/* Script result: */
5,2

