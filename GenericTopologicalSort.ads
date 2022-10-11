generic
   type SortElement is (<>);
   NA: integer;
   with procedure get(Job:  out SortElement);
   with procedure put(Job:  in SortElement);

package GenericTopologicalSort is
   procedure TopologicalSort;
end GenericTopologicalSort;
