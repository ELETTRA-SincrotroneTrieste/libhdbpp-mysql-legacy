LIBHDBPP_DIR = .libhdbpp
LIBHDBPP_INC = ./$(LIBHDBPP_DIR)/src

DBIMPL_INC = `mysql_config --include`
DBIMPL_LIB = `mysql_config --libs_r`

TANGO_INC := ${TANGO_DIR}/include/tango
OMNIORB_INC := ${OMNIORB_DIR}/include
ZMQ_INC :=  ${ZMQ_DIR}/include

INC_DIR = -I${TANGO_INC} -I${OMNIORB_INC} -I${ZMQ_INC}

CXXFLAGS += -std=gnu++0x -Wall -DRELEASE='"$HeadURL$ "' $(DBIMPL_INC) $(INC_DIR) -I$(LIBHDBPP_INC)

##############################################
# support for shared libray versioning
#
LFLAGS_SONAME = $(DBIMPL_LIB) -Wl,-soname,
SHLDFLAGS = -shared
BASELIBNAME       =  libhdbmysql
SHLIB_SUFFIX = so

#  release numbers for libraries
#
 LIBVERSION    = 6
 LIBRELEASE    = 0
 LIBSUBRELEASE = 0
#

LIBRARY       = $(BASELIBNAME).a
DT_SONAME     = $(BASELIBNAME).$(SHLIB_SUFFIX).$(LIBVERSION)
DT_SHLIB      = $(BASELIBNAME).$(SHLIB_SUFFIX).$(LIBVERSION).$(LIBRELEASE).$(LIBSUBRELEASE)
SHLIB         = $(BASELIBNAME).$(SHLIB_SUFFIX)



.PHONY : install clean

lib/LibHdbMySQL: lib obj obj/LibHdbMySQL.o
	$(CXX) obj/LibHdbMySQL.o $(SHLDFLAGS) $(LFLAGS_SONAME)$(DT_SONAME) -o lib/$(DT_SHLIB)
	ln -sf $(DT_SHLIB) lib/$(SHLIB)
	ln -sf $(SHLIB) lib/$(DT_SONAME)
	ar rcs lib/$(LIBRARY) obj/LibHdbMySQL.o

obj/LibHdbMySQL.o: src/LibHdbMySQL.cpp src/LibHdbMySQL.h $(LIBHDBPP_INC)/LibHdb++.h
	$(CXX) $(CXXFLAGS) -fPIC -c src/LibHdbMySQL.cpp -o $@

clean:
	rm -f obj/*.o lib/*.so* lib/*.a

lib obj:
	@mkdir $@
	
	
