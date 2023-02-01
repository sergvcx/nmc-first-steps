cmake_minimum_required(VERSION 3.16.0 FATAL_ERROR)

#SET(CMAKE_MAKE_PROGRAM d:/programs/GnuWin32/bin/make.exe FORCE )
#string(REGEX MATCH NM(d+). ARCH_VERSION ${ARCH})

#MESSAGE("######## ${ARCH} ARCH_VERSION ${ARCH_VERSION} ############")
#return()

if (CMAKE_HOST_WIN32 AND CMAKE_GENERATOR MATCHES "Ninja")
    file(
        WRITE "${CMAKE_BINARY_DIR}/GNUMakeRulesOverwrite.cmake" 
            "STRING(REPLACE \"-MD\" \"-MMD\" CMAKE_DEPFILE_FLAGS_C \"\${CMAKE_DEPFILE_FLAGS_C}\")\n"
            "STRING(REPLACE \"-MD\" \"-MMD\" CMAKE_DEPFILE_FLAGS_CXX \"\${CMAKE_DEPFILE_FLAGS_CXX}\")\n"
    )
    set(CMAKE_USER_MAKE_RULES_OVERRIDE "${CMAKE_BINARY_DIR}/GNUMakeRulesOverwrite.cmake" CACHE INTERNAL "")

	
	

endif()



if (CMAKE_HOST_WIN32)
	STRING(REPLACE " " "\\ " NMC_GCC_TOOLPATH_SPACED $ENV{NMC_GCC_TOOLPATH})
	set( SHELL "SHELL=cmd" )
	set( INCLUDE_MK "-include ${NMC_GCC_TOOLPATH_SPACED}\\nmc4-ide\\include\\nmc4vars_win.mk")
	set( OS_RM "del")
else()
 	set( OS_RM " rm -f -r")
endif()
	

include(./cmake-variables.cmake)
include(./nmc-gcc-compile.cmake)

#set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/nmc-gcc-compile.cmake")
#set(CMAKE_TOOLCHAIN_FILE "nmc-gcc-compile.cmake")



#add_custom_target(nmc4cmd	COMMAND )
#execute_process(
#    COMMAND bash "-c" $ENV{NMC_GCC_TOOLPATH}/nmc4cmd.bat
#    OUTPUT_VARIABLE FOO
#)
	
	
set(CMAKE_CONFIGURATION_TYPES "Release;Debug")

set(TEST_NAME step1)

#set(CMAKE_BUILD_TYPE "")
#set(CMAKE_TOOLCHAIN_FILE "nmc-gcc-compile.cmake")

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_C_EXTENSIONS OFF)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/lib)



list(APPEND nmc4i_s_files 	${s_files})


function(CONFIGURE_TEST TEST_DIR BOARD CORE )	
	set(ARCH NM6407)
	MESSAGE("######## BOARD ${BOARD} / ${TEST_DIR}")
	set(TEST_NAME ${TEST_DIR})
	file(GLOB 	s_files 	${TEST_DIR}/*.S)
	file(GLOB 	cpp_files 	${TEST_DIR}/*.cpp)
	
	MESSAGE("######## BOARD ${BOARD} / ${TEST_DIR} / ${s_files}")
	#add_executable(${TEST_NAME}  ${s_files})
	#list(APPEND dir_list ".")
	
	#set(TEST_NAME ${test_prefix}_${basename}_${board_core}_test)
	
	set(ld_script ./template/${BOARD}/${BOARD}${CORE}.lds)
    
	add_executable(${TEST_NAME} ${s_files})
	#add_dependencies(${TEST_NAME} ${test_lib})
	target_link_directories(${TEST_NAME} PUBLIC
		${CMAKE_CURRENT_FUNCTION_LIST_DIR}/lib
		${BOARD}/lib)
	#target_link_libraries(${TEST_NAME} ${test_lib} ${extra_args})
	target_include_directories(${TEST_NAME} PUBLIC            
		${CMAKE_CURRENT_FUNCTION_LIST_DIR}/include
		${BOARD}/include
		)
	
	target_link_options(${TEST_NAME} PUBLIC
		-T${ld_script}
		-Wl,--whole-archive -lmc12101load_nm -lnm6407_io_nmc -Wl,--no-whole-archive)
	
	#add_test(NAME ${TEST_NAME}
	#	COMMAND mc12101run $<TARGET_FILE:${TEST_NAME}> -a${board_core} -p -v)
	
	#GENERATE_TESTS_MC12101(${DIR}  "mc12101_" ${ld_script} "nmpu${NMPU}" {} )
	
		
	#add_custom_target(run ${BOARD}run -p -v ${TEST_NAME}.abs -R -a${NMPU} )		

	#configure_file ("${CMAKE_CURRENT_SOURCE_DIR}/common/config.h.in"            "${CMAKE_CURRENT_SOURCE_DIR}/include/config.h" )
	string(TOUPPER ${BOARD} BOARD_ENV)
	
	
	set(SRC_DIRS ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/${TEST_DIR})
	set(SRC_FILES "${s_files} ${cpp_files}") 
	set(TARGET test)
	#set(BOARD_ENV "{BOARD_UP})")

	set(BOARD_DIR ${BOARD}${CORE})
	
	#LIST(APPEND CMAKE_PROGRAM_PATH  $ENV{NMC_GCC_TOOLPATH} )
	#NMC_GCC_TOOLPATH

	set(GCC_EXEC_PREFIX "/cygdrive/$ENV{NMC_GCC_TOOLPATH}/nmc4-ide/lib/gcc/")
	STRING(REPLACE "\\" "/" GCC_EXEC_PREFIX ${GCC_EXEC_PREFIX})
	STRING(REPLACE ":" "" GCC_EXEC_PREFIX ${GCC_EXEC_PREFIX})
	
	configure_file ("./templates/Makefile.in"  			"${TEST_DIR}/${BOARD}${CORE}/Makefile" )
	configure_file ("./templates/build.bat.in" 			"${TEST_DIR}/${BOARD}${CORE}/build.bat" )
	configure_file ("./templates/run.bat.in"   			"${TEST_DIR}/${BOARD}${CORE}/run.bat" )
	configure_file ("./templates/build.sh.in"  			"${TEST_DIR}/${BOARD}${CORE}/build.sh" )
	configure_file ("./templates/${LDS}" 				"${TEST_DIR}/${BOARD}${CORE}/${LDS}" )
	
		
	
	target_compile_options(${TEST_NAME} PUBLIC $<$<COMPILE_LANGUAGE:C,CXX>:-mnmc4-fixed;-O2>)	
	target_compile_options(${TEST_NAME} PUBLIC $<$<COMPILE_LANGUAGE:ASM>:-mnmc4-fixed;-Werror>)	
	
	#target_include_directories(${TEST_NAME} PUBLIC include)
endfunction()



set(CMAKE_TOOLCHAIN_FILE "../nmc-gcc-compile.cmake")
project(${TEST_NAME} VERSION 0.1.0 LANGUAGES CXX C ASM)

if ( BOARD STREQUAL "mc5103")
	set(dir_list step01 step02 step03 step03a step04 step04a step05 step06 step06a step06b step07 step08 step09 step10 step11 step12 step13 step13a step14 )
	set(CXXFLAGS "-std=c++11 -O2 -Wall -mnmc3 -g")
	set(LIBS  	"-Wl,--whole-archive -lmc5103lib -Wl,--no-whole-archive")
	set(LIBSD 	"-Wl,--whole-archive -lmc5103lib -Wl,--no-whole-archive")
	set(LDS 	"${BOARD}.lds")
	set(RUN  	"${BOARD}run ")
	set(RUND 	"${BOARD}run ")
	set(MONITOR "")
	
	foreach(dir ${dir_list})
		CONFIGURE_TEST(${dir} ${BOARD} "")
    endforeach()
endif()	


if ( BOARD STREQUAL "mb7707")
	set(dir_list step01 step02 step03 step03a step04 step04a step05 step06 step06a step06b step07 step08 step09 step10 step11 step12 step13 step13a step14 )
	set(CXXFLAGS "-std=c++11 -O2 -Wall -mnmc3 -g")
	set(LIBS  	"-Wl,--whole-archive -lmb7707lib -Wl,--no-whole-archive")
	set(LIBSD 	"-Wl,--whole-archive -lmb7707lib -Wl,--no-whole-archive")
	set(LDS 	"${BOARD}.lds")
	set(RUN  	"${BOARD}run ")
	set(RUND 	"${BOARD}run ")
	set(MONITOR "")
	
	foreach(dir ${dir_list})
		CONFIGURE_TEST(${dir} ${BOARD} "")
    endforeach()
endif()	


if ( BOARD STREQUAL "mc12101")
	set(dir_list step01 step02 step03 step03a step04 step04a step05 step06 step06a step06b step07 step08 step09 step10 step11 step12 step13 step13a step14 )
	set(CXXFLAGS "-std=c++11 -O2 -Wall -mnmc4-fixed -g")
	set(LIBS  	"-Wl,--whole-archive -lnm6407_io_nmc -lmc12101load_nm -Wl,--no-whole-archive")
	set(LIBSD 	"-Wl,--whole-archive -lnm6407_io_nmc -lmc12101_stub_nmc4_fixed -Wl,--no-whole-archive")
	set(LDS 	"${BOARD}-nmpu1.lds")
	set(RUN  	"${BOARD}run -p -v -R -a1")
	set(RUND 	"${BOARD}run -p -v -R -a1")
	set(MONITOR "nmc-monitor")
	
	foreach(dir ${dir_list})
		CONFIGURE_TEST(${dir} ${BOARD} "-nmpu1")
    endforeach()
endif()	

if ( BOARD STREQUAL "mc12705")
	set(dir_list step01 step02 step03 step03a step04 step04a )
	set(CXXFLAGS "-std=c++11 -O2 -Wall -mnmc4-float -g")
	set(LIBS  	"-Wl,--whole-archive -lnm6408load_nmc -lnmc_io -Wl,--no-whole-archive")
	set(LIBSD 	"-Wl,--whole-archive -lnm6408load_nmc -lnmc_io -lnm6408_stub -Wl,--no-whole-archive")
	set(LDS 	"${BOARD}.lds")
	set(RUN  	"${BOARD}run -c0 -n0")
	set(RUND 	"${BOARD}run -c0 -n0")
	set(MONITOR "nmc-monitor")
	
	foreach(dir ${dir_list})
		CONFIGURE_TEST(${dir} ${BOARD} "")
    endforeach()
endif()	

if ( BOARD STREQUAL "qemu" )
	set(dir_list step01 step02 step03 step03a step04 step04a step05 step06 step06a step06b step07 step08 step09 step10 step11 step12 step13 step13a step14 )
	set(CXXFlAGS "-std=c++11 -O2 -Wall -mnmc4 -g")
	set(LIBS  	"")
	set(LIBSD 	"")
	set(LDS 	"qemu.lds")
	set(RUN 	"nmc-qemu test.abs")
	set(RUND 	"nmc-qemu -g 5555 $(TARGET)")
	set(MONITOR "")
	foreach(dir ${dir_list})
		CONFIGURE_TEST(${dir} qemu "")
    endforeach()
endif()	

	



#string(SUBSTRING ${ARCH} 2 4 NMC_CORE_VERSION )			 

set_source_files_properties( ${nmc4f_asm_files} ${nmc4i_asm_files} ${nmc4r_asm_files}
			 PROPERTY
			 COMPILE_FLAGS " -mmas -Wa,-split_sir -Wa,-W-111"
			 )

set_source_files_properties( ${s_files} 
			 PROPERTY
			 COMPILE_FLAGS "-mgas -DNMC_CORE_VERSION=${NMC_CORE_VERSION}"
			 )
	





#enable_testing()
#add_subdirectory(app/test)
					
#add_subdirectory(test/context)

#add_subdirectory(monitor)
#add_subdirectory(examples/2nmc-demo-gcc/make_mc12101)
