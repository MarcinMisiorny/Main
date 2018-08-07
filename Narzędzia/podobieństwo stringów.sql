-- prosta funkcja zwracająca procent podobienstwa ciągów znaków

CREATE OR REPLACE FUNCTION fn_podobienstwo_ciagow_znakow
(p_pierwszy_ciag_znakow IN VARCHAR2
,p_drugi_ciag_znakow IN VARCHAR2)
RETURN NUMBER
IS
    n_podobienstwo NUMBER;
BEGIN
    n_podobienstwo := UTL_MATCH.EDIT_DISTANCE_SIMILARITY(p_pierwszy_ciag_znakow, p_drugi_ciag_znakow);
RETURN n_podobienstwo;
END fn_podobienstwo_ciagow_znakow;
/

