-- prosta funkcja usuwająca polskie znaki z tekstu - podmienia je na litery z alfabetu łacińskiego (ą -> a, ć -> c, etc)

CREATE OR REPLACE FUNCTION fn_usun_polskie_znaki
(p_tekst VARCHAR2)
RETURN VARCHAR2
IS
    v_tekst_bez_polskich_znakow VARCHAR2(4000);
BEGIN
    v_tekst_bez_polskich_znakow := TRANSLATE(p_tekst, 'Ą, Ć, Ę, Ł, Ń, Ó, Ś, Ź, Ż, ą, ć, ę, ł, ń, ó, ś, ź, ż', 'A, C, E, L, N, O, S, Z, Z, a, c, e, l, n, o, s, z, z');
	
RETURN v_tekst_bez_polskich_znakow;
END fn_usun_polskie_znaki;
/

