with Ada.Integer_Text_IO, Ada.Text_IO, Ada.Unchecked_Conversion;
use Ada.Integer_Text_IO, Ada.Text_IO;

package body GenericTopologicalSort is

   type Node;
   type NodePointer is access Node;
   type Node is tagged record
      Suc:   SortElement;
      Next:  NodePointer;
   end record;

   type JobElement is record
      Count:  Integer;
      Top:    NodePointer;
   end record;

   SortStructure:  Array(0..NA) of JobElement;

   function IntToNP is new Ada.Unchecked_Conversion(Integer, NodePointer);

   procedure TopologicalSort is
      KN: integer;
      NR: integer; --the number of total relations
      counter: integer;
      F: integer; --front
      R: integer; --rear
      K: integer;
      P: NodePointer; --pointer
      first: SortElement; --first element of relation
      last: SortElement; --second element of relation

   begin

      for K in 1..NA loop
         SortStructure(K).Count := 0;
         SortStructure(K).Top   := null;
      end loop;

      KN := NA;

      get(NR);
      get(first);
      get(last);
      counter := 1;

      loop --setup data structure
         P := new Node;
         SortStructure(SortElement'Pos(last)).Count := SortStructure(SortElement'Pos(last)).Count+1;
         P.Suc := last;
         P.Next := SortStructure(SortElement'Pos(first)).Top;
         SortStructure(SortElement'Pos(first)).Top := P;
         exit when counter = NR;

         counter := counter + 1;


         get(first);
         get(last);
      end loop;

      --initialize output queue
      R := 0;
      SortStructure(0).Count := 0;

      for K in 1..NA loop
         if SortStructure(K).Count = 0 then
            SortStructure(R).Count := K;
            R := K;
         end if;
      end loop;

      F := SortStructure(0).Count;

      --print
      Put_Line("Sorted items: ");
      While F /= 0 loop
         put(SortElement'Val(F));
         put(" ");

         KN := KN - 1;
         P := SortStructure(F).Top;
         SortStructure(F).Top := IntToNP(0);

         While P /= IntToNP(0) loop
            SortStructure(SortElement'Pos(P.Suc)).Count := SortStructure(SortElement'Pos(P.Suc)).Count - 1;

            if SortStructure(SortElement'Pos(P.Suc)).Count = 0 then
               SortStructure(R).Count := SortElement'Pos(P.Suc);
               R := SortElement'Pos(P.Suc);
            end if;

            P := P.Next;
         end loop;
         F := SortStructure(F).Count;
      end loop;

      if KN = 0 then
         New_Line;
         Put_Line("Topological Sort complete.");
         return;
      else
         New_Line;
         Put_Line("Topological sort failed.");
         for K in 1..NA loop
            SortStructure(K).Count := 0;
         end loop;
      end if;

      for K in 1..NA loop
         P := SortStructure(K).Top;
         SortStructure(K).Top := IntToNP(0);

         While P /= IntToNP(0) and then SortStructure(SortElement'Pos(P.Suc)).Count = 0 loop
            SortStructure(SortElement'Pos(P.Suc)).Count := K;
            if P /= IntToNP(0) then
               P := P.Next;
            end if;
         end loop;
      end loop;

      K := 1;
      While SortStructure(K).Count = 0 loop
         K := K + 1;
      end loop;

      loop
         SortStructure(K).Top := IntToNP(1);
         K := SortStructure(K).Count;
         exit when SortStructure(K).Top /= IntToNP(0);
      end loop;


      Put("loop with error: ");
      While SortStructure(K).Top /= IntToNP(0) loop
         Put(SortElement'Val(K)); put(" ");
         SortStructure(K).Top := IntToNP(0);
         K := SortStructure(K).Count;
      end loop;
      Put(SortElement'Val(K)); New_Line;

   end TopologicalSort;
end GenericTopologicalSort;
