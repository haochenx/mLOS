-- mLOS/document.lua
--
-- Copyright (c) 2012 Hacohen Xie
-- See the file license.txt for copying permission.
--
-- This file tries to show how to work with mLOS, a Micro Lua Object
-- System
--
-- This file is created by Haochen Xie on Dec. 13, 2012 and is a part
-- of Haochen's public project, mLOS, currently hosted at
-- <https://github.com/Haochen-Xie/mLOS>
--
-- Usage:
--
-- First load this file anyway. You use require to do so:
-- > require ("mLOS")
--
-- This library will register a global table <mLOS> which holds only
-- one function called <classify> To define a class, populate a table
-- including important information first, as shown below (We are going
-- to declare a class <Point>):
Point = {
   -- Initial fields
   x = 0,
   y = 0,
   -- Class methods
   distSq	-- Distance squared to the origin point
      = function(p)
	   local function sq(x) return x*x end
	   return sq(p.x) + sq(p.y)
	end,
   print
      = function(p)
	   print(string.format("(%g,%g)", p.x, p.y))
	end,
   -- Constructor
   constructor
      = function(self, x, y)
	   self.x = x or self.x
	   self.y = y or self.y
	end,
}

-- Once you have your class prototype done, you can call global
-- function <classify> to make the prototype a usable class:
mLOS.classify(Point)

-- After you classify your prototype, as shown above, you get a new
-- class, in this case, <Point>.
-- To create a new instance, call Point() to return a new instance:
p1 = Point()

-- This will invoke constructor, but, since we didn't pass any
-- argument, p1 will be initialized using default value. To check it,
-- we can use Point.print:
p1:print()

-- The previous instruct calls Point.print(p1), so the output should
-- be:
-- (0,0)

-- To use the constructor, just pass your arguments:
p2 = Point(2,4)

-- As the same with method <print>, you can call another method
-- <distSq>:
p2:print()
print("distSq: "..p2:distSq())


-- That's all about a simple class. Now we are going to go through
-- inheritance, the real power of OOP
-- We will start it from a new class, <Point3d>. As I mentioned, to
-- create a class, the first step is to declare the prototype:
Point3d = {
   -- Here we put the superclass(es) in the <ancestors> table
   ancestors = {Point},
   -- New fields
   z = 0,
   -- New or overwritten methods
   ---- We want to provide a new version of distSq, since we introduced
   ---- a new field <z>
   distSq	-- Distance squared to the origin point
      = function(p)
	   local function sq(x) return x*x end
	   return sq(p.x) + sq(p.y) + sq(p.z)
	end,
   ---- We leave print untouch and see what will happen
   -- New constructor
   constructor
      = function(self, x, y, z)
	   self.x = x or self.x
	   self.y = y or self.y
	   self.z = z or self.z
	end,
}
-- We classify it anyway.
mLOS.classify(Point3d)

-- So we now have the new inherited class, <Point3d>. Pretty easy and
-- straightforward, isn't it?

-- Now let's try <Point3d>:
p3 = Point3d()
p4 = Point3d(2,3,4)

p3:print()
p4:print()

-- Yeah, the z's didn't show up. That's because we haven't provide a
-- proper version of <print> for Point3d, so it use its
-- ancestor's. We can check the <z> field this way:
print("p3.z: "..p3.z)
print("p4.z: "..p4.z)

-- As you see, they work fine. So let's try <distSq> here, it should
-- works well.
print("distSq: "..p4:distSq())

-- Yeah, it's 29 but not 13: it works!
-- And you can check whether an object is an instance of a class, by
-- using Classname.is_instance(Obj) boolean function:
print("p1 is an instance of class Point? ", Point.is_instance(p1));
print("p1 is an instance of class Point3d? ", Point3d.is_instance(p1));
print("p3 is an instance of class Point? ", Point.is_instance(p1));

-- Notably, the <is_instance> follows the duck theory, that is, if an
-- object behaves LIKE a class, it is said to be an instance of that
-- class. More specifically, if, and only if an object has all the
-- fields a class should have and has all the exactly same methods the
-- class should have, the object is said to be an instance of the
-- class. So you may get an instance of a class but you just made that
-- up, or however you make the object, once it behaves like the class.
--
-- And, as the last note, You should know what will happen if you have
-- conflict on field name while inheriting. First, you should know
-- that it would not arise an error of any kind. The field will still
-- exist, but if you don't have its new initial value defined, you
-- can't tell what will be the initial value for that field. That will
-- only happen when multiple inheriting, and the safest way is to
-- specify the initial value you want in the child class. So, be safe,
-- and never try to dig into lib codes to figure out what's the
-- overwrite order might be. It's much more easier and safer to
-- declare those fields again.
--
-- So, I hope you enjoy the mLOS!
-- Haochen Xie. Dec. 13, 2012
