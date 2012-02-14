library IEEE;
use IEEE.STD_LOGIC_1164.all;

package std_logic_1164_additional is
    -------------------------------------------------------------------
    -- overloaded shift operators
    -------------------------------------------------------------------
    function "sll" ( l : std_logic_vector;  r : integer ) RETURN std_logic_vector;
    function "sll" ( l : std_ulogic_vector; r : integer ) RETURN std_ulogic_vector; 

    function "srl" ( l : std_logic_vector;  r : integer ) RETURN std_logic_vector;
    function "srl" ( l : std_ulogic_vector; r : integer ) RETURN std_ulogic_vector;

    function "sla" ( l : std_logic_vector;  r : integer ) RETURN std_logic_vector;
    function "sla" ( l : std_ulogic_vector; r : integer ) RETURN std_ulogic_vector;

    function "sra" ( l : std_logic_vector;  r : integer ) RETURN std_logic_vector;
    function "sra" ( l : std_ulogic_vector; r : integer ) RETURN std_ulogic_vector;

end std_logic_1164_additional;


package body std_logic_1164_additional is
   -------------------------------------------------------------------
   -- sll
   -------------------------------------------------------------------
   FUNCTION "sll" ( l : std_logic_vector;  r : integer ) RETURN std_logic_vector IS
       ALIAS lv : std_logic_vector ( 1 TO l'LENGTH ) IS l;
       VARIABLE result : std_logic_vector ( l'RANGE ) := (OTHERS => '0');
       ALIAS resultv : std_logic_vector ( 1 TO l'LENGTH ) IS result;
   BEGIN
       IF r = 0 OR l'LENGTH = 0 THEN
           RETURN l;
       ELSIF r > 0 THEN
           IF r < l'LENGTH THEN
               resultv(1 TO l'LENGTH - r) := lv(r+1 TO l'LENGTH);
		   ELSE
		   	   resultv := (others=>'0');
           END IF;
           RETURN result;
       ELSE
           RETURN l;
       END IF;
   END "sll";
   -------------------------------------------------------------------
   FUNCTION "sll" ( l : std_ulogic_vector; r : integer ) RETURN std_ulogic_vector IS
       ALIAS lv : std_ulogic_vector ( 1 TO l'LENGTH ) IS l;
       VARIABLE result : std_ulogic_vector ( l'RANGE ) := (OTHERS => '0');
       ALIAS resultv : std_ulogic_vector ( 1 TO l'LENGTH ) IS result;
   BEGIN
       IF r = 0 OR l'LENGTH = 0 THEN
           RETURN l;
       ELSIF r > 0 THEN
           IF r < l'LENGTH THEN
               resultv(1 TO l'LENGTH - r) := lv(r+1 TO l'LENGTH);
		   ELSE
		   	   resultv := (others=>'0');
           END IF;
           RETURN result;
       ELSE
           RETURN l;
       END IF;
   END "sll";

   -------------------------------------------------------------------
   -- srl
   -------------------------------------------------------------------
   FUNCTION "srl" ( l : std_logic_vector;  r : integer ) RETURN std_logic_vector IS
       ALIAS lv : std_logic_vector ( 1 TO l'LENGTH ) IS l;
       VARIABLE result : std_logic_vector ( l'RANGE ) := (OTHERS => '0');
       ALIAS resultv : std_logic_vector ( 1 TO l'LENGTH ) IS result;
   BEGIN
       IF r = 0 OR l'LENGTH = 0 THEN
           RETURN l;
       ELSIF r > 0 THEN
           IF r < l'LENGTH THEN
               resultv(r+1 TO l'LENGTH) := lv(1 TO l'LENGTH - r);
		   ELSE
		   	   resultv := (others=>'0');
           END IF;
           RETURN result;
       ELSE
           RETURN l;
       END IF;
   END "srl";
   -------------------------------------------------------------------
   FUNCTION "srl" ( l : std_ulogic_vector; r : integer ) RETURN std_ulogic_vector IS
       ALIAS lv : std_ulogic_vector ( 1 TO l'LENGTH ) IS l;
       VARIABLE result : std_ulogic_vector ( l'RANGE ) := (OTHERS => '0');
       ALIAS resultv : std_ulogic_vector ( 1 TO l'LENGTH ) IS result;
   BEGIN
       IF r = 0 OR l'LENGTH = 0 THEN
           RETURN l;
       ELSIF r > 0 THEN
           IF r < l'LENGTH THEN
               resultv(r+1 TO l'LENGTH) := lv(1 TO l'LENGTH - r);
		   ELSE
		   	   resultv := (others=>'0');
           END IF;
           RETURN result;
       ELSE
           RETURN l;
       END IF;
   END "srl";

   -------------------------------------------------------------------
   -- sla
   -------------------------------------------------------------------
   FUNCTION "sla" ( l : std_logic_vector;  r : integer ) RETURN std_logic_vector IS
       ALIAS lv : std_logic_vector ( 1 TO l'LENGTH ) IS l;
       VARIABLE result : std_logic_vector ( l'RANGE ) := (OTHERS => l(l'RIGHT));
       ALIAS resultv : std_logic_vector ( 1 TO l'LENGTH ) IS result;
   BEGIN
       IF r = 0 OR l'LENGTH = 0 THEN
           RETURN l;
       ELSIF r > 0 THEN
           IF r < l'LENGTH THEN
               resultv(1 TO l'LENGTH - r) := lv(r+1 TO l'LENGTH);
           END IF;
           RETURN result;
       ELSE
           RETURN l;
       END IF;
   END "sla";
   -------------------------------------------------------------------
   FUNCTION "sla" ( l : std_ulogic_vector; r : integer ) RETURN std_ulogic_vector IS
       ALIAS lv : std_ulogic_vector ( 1 TO l'LENGTH ) IS l;
       VARIABLE result : std_ulogic_vector ( l'RANGE ) := (OTHERS => l(l'RIGHT));
       ALIAS resultv : std_ulogic_vector ( 1 TO l'LENGTH ) IS result;
   BEGIN
       IF r = 0 OR l'LENGTH = 0 THEN
           RETURN l;
       ELSIF r > 0 THEN
           IF r < l'LENGTH THEN
               resultv(1 TO l'LENGTH - r) := lv(r+1 TO l'LENGTH);
           END IF;
           RETURN result;
       ELSE
           RETURN l;
       END IF;
   END "sla";

   -------------------------------------------------------------------
   -- sra
   -------------------------------------------------------------------
   FUNCTION "sra" ( l : std_logic_vector;  r : integer ) RETURN std_logic_vector IS
       ALIAS lv : std_logic_vector ( 1 TO l'LENGTH ) IS l;
       VARIABLE result : std_logic_vector ( l'RANGE ) := (OTHERS => l(l'LEFT));
       ALIAS resultv : std_logic_vector ( 1 TO l'LENGTH ) IS result;
   BEGIN
       IF r = 0 OR l'LENGTH = 0 THEN
           RETURN l;
       ELSIF r > 0 THEN
           IF r < l'LENGTH THEN
               resultv(r+1 TO l'LENGTH) := lv(1 TO l'LENGTH - r);
           END IF;
           RETURN result;
       ELSE
           RETURN l;
       END IF;
   END "sra";
   -------------------------------------------------------------------
   FUNCTION "sra" ( l : std_ulogic_vector; r : integer ) RETURN std_ulogic_vector IS
       ALIAS lv : std_ulogic_vector ( 1 TO l'LENGTH ) IS l;
       VARIABLE result : std_ulogic_vector ( l'RANGE ) := (OTHERS => l(l'LEFT));
       ALIAS resultv : std_ulogic_vector ( 1 TO l'LENGTH ) IS result;
   BEGIN
       IF r = 0 OR l'LENGTH = 0 THEN
           RETURN l;
       ELSIF r > 0 THEN
           IF r < l'LENGTH THEN
               resultv(r+1 TO l'LENGTH) := lv(1 TO l'LENGTH - r);
           END IF;
           RETURN result;
       ELSE
           RETURN l;
       END IF;
   END "sra";

end std_logic_1164_additional;

