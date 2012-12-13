--
-- Copyright (c) 2012 Hacohen Xie
-- See the file license.txt for copying permission.
--

classify=mLOS.classify

Point = {
   x=0,
   y=0,
   distSq
      = function(self)
	   local function sq(x) return x*x end
	   return sq(self.x) + sq(self.y)
	end,
   print
      = function(self)
	   print(self.x, self.y)
	end,
   constructor
      = function(self, x, y)
	   self.x = x or self.x
	   self.y = y or self.y
	end
}

Point3d = {
   ancestors = {Point},
   z=0,
   distSq
      = function(self)
	   local function sq(x) return x*x end
	   return sq(self.x) + sq(self.y) + sq(self.z)
	end,
   constructor
      = function(self, x, y, z)
	   self.x = x or self.x
	   self.y = y or self.y
	   self.z = z or self.z
	end
}

classify(Point)
classify(Point3d)

function dump_table(t) table.foreach(t, print) end

print("\nPoint:")
dump_table(Point)
print("\nPoint3d:")
dump_table(Point3d)

p1 = Point()
p2 = Point3d()

print("\np1:")
dump_table(p1)
print("\np2:")
dump_table(p2)

p1 = Point(2, 4)
p2 = Point3d(3, 4, 5)

print("\np1:")
dump_table(p1)
print("\np2:")
dump_table(p2)

print("\np1:distSq()")
print(p1:distSq())
print("\np2:distSq()")
print(p2:distSq())

print()
print(Point3d.is_instance(p1))
print(Point3d.is_instance(p2))

print()
print(Point.is_instance(p1))
print(Point.is_instance(p2))
