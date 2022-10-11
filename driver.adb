--driver.adb
--main

with topSort, Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure driver is

   --DUMMYVALUE is used to move the rest of the enums up a slot while still
   --allowing nameType'Pos(0) to not cause an error, making the same code
   --usable for integers and enumerations
   type nameType is (DUMMYVALUE, Acevedo, Henderson, Cleek, Leky, Mills, Pruett, Sanchez, Smith, Utsey);

   --create the Enumeration IO for nameType
   package NameTypeIO is new Ada.Text_IO.Enumeration_IO(nameType);
   use NameTypeIO;

   --create the get nameType method
   procedure NTGet(x: out nameType) is
   begin
      NameTypeIO.Get(x);
   end NTGet;

   --create the put nameType method
   procedure NTPut(x : nameType) is
   begin
      NameTypeIO.Put(x);
   end NTPut;

   --created a method to get an integer
   procedure intGet(x: out Integer) is
   begin
      Ada.Integer_Text_IO.Get(x, 0);
   end intGet;

   --create a method to put an integer
   procedure intPut(x : in Integer) is
   begin
      Ada.Integer_Text_IO.Put(x, 0);
   end intPut;

   --variables
   sortChoice, numItems : integer;

begin
   loop
      sortChoice := -1;
      numItems := -1;

      while sortChoice < 0 or sortChoice > 2 loop
         new_line;
         put_line("What type of data will you be sorting?");
         put_line("1. Integers");
         put_line("2. Enumerations");
         put_line("0. Exit");
         new_line;
         put("Your choice: ");
         get(sortChoice);
         new_line;

         if sortChoice = 0 then
            goto quit; --only way to quit in Ada
         end if;
      end loop;

      if sortChoice = 2 then
         declare
            --numItems for the enumeration type is the number of items in the
            --enum excluding the dummy value
            package namesort is new topsort(nameType, 9, NTGet, NTPut);
         begin
            namesort.TopologicalSort;
         end;

      elsif sortChoice = 1 then
         while numItems < 0 loop
            put("Enter the number of items: ");
            get(numItems);
         end loop;

         declare
           package intSort is new topsort(integer, numItems, intGet, intPut);
         begin
            intSort.TopologicalSort;
         end;
      end if;

   end loop;

   <<quit>>
   null;
end driver;
