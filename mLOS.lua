-- mLOS/mLOS.lua
--
-- This file tries to implement a simple class system in lua
--
-- This file is created by Haochen Xie on Dec. 12, 2012 and is a part
-- of Haochen's public project, mLOS, currently hosted at
-- <https://github.com/Haochen-Xie/mLOS>
--
-- For usage information, please refer to document.lua comes with the
-- package containing this file.

local _G = _G

-- Helper function <concat_table>
local function concat_table(a, b)
   for k, v in pairs(b) do
      a[k] = v
   end
end

mLOS = {}

function mLOS.classify(ct)
   local fields = {}
   local methods = {}

   -- Populate <fields> & <methods>
   for k, v in pairs(ct) do
      local ignore = {
	 ancestors=true,
	 constructor=true,
	 __ht=true
      }
      if not ignore[k] then
	 if type(v) == "function" then
	    methods[k] = v
	 else
	    fields[k] =v
	 end
      end
   end

   -- create a hidden table to keep helper
   ct.__ht = {
      fields=fields,
      methods=methods
   }
   local constructor_mt = {}
   local instance_mt = {
      __index = function(self, k) return ct.__ht.selectMethod(k) end
   }

   -- Helper function <selectMethod>
   function ct.__ht.selectMethod(k)
      -- Try to select method
      if ct.__ht.methods[k] then
	 return ct.__ht.methods[k]
      end

      -- Try ancestors' method
      if ct.ancestors then
	 for _, v in pairs(ct.ancestors) do
	    if v.__ht.methods[k] then
	       return v.__ht.methods[k]
	    end
	 end
      end
      return nil
   end

   function constructor_mt.__call(self,...)
      local new_instance = {}

      -- Load ancestors' initial fields
      if ct.ancestors then
	 for k, v in pairs(ct.ancestors) do
	    concat_table(new_instance, v.__ht.fields)
	 end
      end

      -- Load our own initial fields
      concat_table(new_instance, fields)

      if ct.constructor then
	 ct.constructor(new_instance,...)
      end

      setmetatable(new_instance, instance_mt)
      return new_instance
   end

   -- Check if <x> is instance according to matching of fields
   function ct.__ht.is_instance_fields(x)
      -- Check for itself
      for k in pairs(ct.__ht.fields) do
	 if not x[k] then return false end
      end
      -- Check for its ancesors
      if ct.ancestors then
	 for _, v in pairs(ct.ancestors) do
	    if not v.__ht.is_instance_fields(x) then return false end
	 end
      end
      return true
   end
   function ct.__ht.method_list()
      local method_list = {}
      for k in pairs(ct.__ht.methods) do
	 method_list[#method_list] = k
      end
      if ct.ancestors then
	 for _, v in pairs(ct.ancestors) do
	    concat_table(method_list, v.__ht.method_list())
	 end
      end
      return method_list
   end

   function ct.is_instance(x)
      -- Check field matching
      if not ct.__ht.is_instance_fields(x) then return false end

      -- Check method matching
      local method_list = ct.__ht.method_list()
      for i = 1, #method_list do
	 if ct.__ht.selectMethod(method_list[i]) ~= x.method_list[i] then
	    return false end
      end
      return true
   end

   setmetatable(ct, constructor_mt)
end
return mLOS
