cmake_minimum_required(VERSION 3.16.0 FATAL_ERROR)

enable_testing()
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



#list(APPEND nmc4i_s_files 	${s_files})



#message("#######dirs: ${dirs}")
#return ()
function(CONFIGURE_EXAMPLE TEMPL_DIR SRC_DIR BSP CORE LIBS LIBSD LDS RECIPE_RUN RECIPE_RUND RECIPE_TEST RECIPE_EXTRA)	

endfunction()

#
#function(CONFIGURE_EXAMPLE TEMPL_DIR SRC_DIR DST_DIR BSP CORE LIBS LIBSD LDS RECIPE_RUN RECIPE_RUND RECIPE_EXTRA)	
#
#endfunction()

function(CONFIGURE_TEST TEST_DIR BOARD CORE )	
	#set(ARCH NM6407)
	
	get_filename_component(STEP_NAME ${TEST_DIR} NAME)
	
	set(TEST_NAME test-${BOARD}${CORE}-${STEP_NAME}.abs)
	file(GLOB 	s_files 	${TEST_DIR}/*.S)
	file(GLOB 	cpp_files 	${TEST_DIR}/*.cpp)
	file(GLOB 	c_files 	${TEST_DIR}/*.c)
	
	set(SRC_DIRS ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/${TEST_DIR})
	
	list(APPEND SRC_LIST ${s_files})
	list(APPEND SRC_LIST ${cpp_files})
	list(APPEND SRC_LIST ${c_files})
	
	list(LENGTH SRC_LIST SRC_COUNT)
	
	#MESSAGE("=== ${SRC_LIST}")	
	list(JOIN SRC_LIST " " SRC_FILES)
	
	MESSAGE("### BOARD:${BOARD} core:${CORE} dir:${TEST_DIR} name:${STEP_NAME}") # src: ${SRC_FILES}")	

	if (NOT SRC_COUNT  )
		return()
	endif()	
	
	string(TOUPPER ${BOARD} BSP)
	set(TARGET test)
	
	#LIST(APPEND CMAKE_PROGRAM_PATH  $ENV{NMC_GCC_TOOLPATH} )
	#NMC_GCC_TOOLPATH
	
	set(GCC_EXEC_PREFIX "/cygdrive/$ENV{NMC_GCC_TOOLPATH}/nmc4-ide/lib/gcc/")
	STRING(REPLACE "\\" "/" GCC_EXEC_PREFIX ${GCC_EXEC_PREFIX})
	STRING(REPLACE ":" "" GCC_EXEC_PREFIX ${GCC_EXEC_PREFIX})
	
	configure_file ("./templates/Makefile.in"  			"${TEST_DIR}/${BOARD}${CORE}/Makefile" )
	configure_file ("./templates/${LDS}" 				"${TEST_DIR}/${BOARD}${CORE}/${LDS}" )
	if (CMAKE_HOST_WIN32)
		configure_file ("./templates/build.bat.in" 			"${TEST_DIR}/${BOARD}${CORE}/build.bat" )
		configure_file ("./templates/run.bat.in"   			"${TEST_DIR}/${BOARD}${CORE}/run.bat" )
	else()
		configure_file ("./templates/build.sh.in"  			"${TEST_DIR}/${BOARD}${CORE}/build.sh" )
		configure_file ("./templates/run.sh.in"   			"${TEST_DIR}/${BOARD}${CORE}/run.sh" )
	endif()
	
	
		#${LIBS}
	#add_test(NAME ${TEST_NAME} COMMAND mc12101run $<TARGET_FILE:${TEST_NAME}> -a${board_core} -p -v)
	
	#add_test(NAME ${TEST_NAME}
	#	COMMAND mc12101run $<TARGET_FILE:${TEST_NAME}> -a${board_core} -p -v)
	
	#GENERATE_TESTS_MC12101(${DIR}  "mc12101_" ${LDS} "nmpu${NMPU}" {} )
	
		
	#add_custom_target(run ${BOARD}run -p -v ${TEST_NAME}.abs -R -a${NMPU} )		

	#configure_file ("${CMAKE_CURRENT_SOURCE_DIR}/common/config.h.in"            "${CMAKE_CURRENT_SOURCE_DIR}/include/config.h" )
	#string(TOUPPER ${BOARD} BOARD_ENV)
	
	
	#list(APPEND dir_list ".")
	
	#set(TEST_NAME ${test_prefix}_${basename}_${board_core}_test)
	
	#set(test_lib "")
	#set(ld_script ./template/${BOARD}/${BOARD}${CORE}.lds)
	add_executable(${TEST_NAME}  ${SRC_LIST})
	#add_dependencies(${TEST_NAME} ${test_lib})
	
	#MESSAGE (============ ${BSP})
	#return()
	target_link_directories(${TEST_NAME} PUBLIC	$ENV{${BSP}}/lib)
		
	#${CMAKE_CURRENT_FUNCTION_LIST_DIR}/lib		
	#target_link_libraries(${TEST_NAME} ${test_lib} ${extra_args})
	string(REPLACE " " ";" LIBS_LIST ${LIBS})
	target_link_libraries(${TEST_NAME} c ${extra_args} ${LIBS_LIST} )
	target_include_directories(${TEST_NAME} PUBLIC $ENV{BSP}/include)
	
		#-T${CMAKE_CURRENT_SOURCE_DIR}/templates/${LDS} 
	target_link_options(${TEST_NAME} PUBLIC	-T${CMAKE_CURRENT_SOURCE_DIR}/templates/${LDS} )
	
	
	
	if ( BOARD STREQUAL "mc5103" OR BOARD STREQUAL "mb7707")
		target_compile_options(${TEST_NAME} PUBLIC $<$<COMPILE_LANGUAGE:C,CXX>:-mnmc3;-O2>)	
		target_compile_options(${TEST_NAME} PUBLIC $<$<COMPILE_LANGUAGE:ASM>:-mnmc3;-Werror>)	
	elseif ( BOARD STREQUAL "mc12101" AND CORE STREQUAL "-nmpu1")
		target_compile_options(${TEST_NAME} PUBLIC $<$<COMPILE_LANGUAGE:C,CXX>:-mnmc4-fixed;-O2>)	
		target_compile_options(${TEST_NAME} PUBLIC $<$<COMPILE_LANGUAGE:ASM>:-mnmc4-fixed;-Werror>)	
	elseif ( BOARD STREQUAL "mc12101" AND CORE STREQUAL "-nmpu0")
		target_compile_options(${TEST_NAME} PUBLIC $<$<COMPILE_LANGUAGE:C,CXX>:-mnmc4-float;-O2>)	
		target_compile_options(${TEST_NAME} PUBLIC $<$<COMPILE_LANGUAGE:ASM>:-mnmc4-float;-Werror>)	
	elseif ( BOARD STREQUAL "mc12705")
		target_compile_options(${TEST_NAME} PUBLIC $<$<COMPILE_LANGUAGE:C,CXX>:-mnmc4-float;-O2>)	
		target_compile_options(${TEST_NAME} PUBLIC $<$<COMPILE_LANGUAGE:ASM>:-mnmc4-float;-Werror>)
	elseif ( BOARD STREQUAL "qemu")
		target_compile_options(${TEST_NAME} PUBLIC $<$<COMPILE_LANGUAGE:C,CXX>:-mnmc4;-O2>)	
		target_compile_options(${TEST_NAME} PUBLIC $<$<COMPILE_LANGUAGE:ASM>:-mnmc4;-Werror>)
	endif()
	
	#set(OPTS  ${RUNOPT} )
	
	string(REPLACE "-v" "" CRUNOPT ${RUNOPT})
	string(REPLACE " " ";" OPTS ${CRUNOPT})
	
	#list(LENGTH SEXY_LIST len)
	#message (---------= ${SEXY_LIST}  ${len})
	
	#return()
	
	#message( "##############${OPTS}")
	#return()
	add_test(NAME ${TEST_NAME} COMMAND ${RUNNER} $<TARGET_FILE:${TEST_NAME}> ${OPTS})
	
	
	#target_include_directories(${TEST_NAME} PUBLIC include)
endfunction()



set(CMAKE_TOOLCHAIN_FILE "../nmc-gcc-compile.cmake")
project(${TEST_NAME} VERSION 0.1.0 LANGUAGES CXX C ASM)

#set(steps_risc steps_risc/step01 steps_risc/step02 steps_risc/step03 steps_risc/step03a steps_risc/step04 steps_risc/step04a) 
#set(stepis_fixed steps_fixed/stepi05 steps_fixed/stepi06 steps_fixed/stepi06a steps_fixed/stepi06b steps_fixed/stepi07 steps_fixed/stepi08 steps_fixed/stepi09 steps_fixed/stepi10 steps_fixed/stepi11 steps_fixed/stepi12 steps_fixed/stepi13 steps_fixed/stepi13a steps_fixed/stepi14) 
#set(steps_float steps-float/stepf01 steps-float/stepf02 steps-float/stepf02a steps-float/stepf02b) 
file(GLOB 	 steps_risc  steps-risc/*  )
file(GLOB 	 steps_fixed steps-fixed/* )
file(GLOB 	 steps_float steps-float/* )

#string(REPLACE )

#MESSAGE(---------${CMAKE_CURRENT_LIST_DIR})
#MESSAGE(---------${steps_risc})
STRING(REPLACE "${CMAKE_CURRENT_LIST_DIR}/" "" steps_risc "${steps_risc}")
STRING(REPLACE "${CMAKE_CURRENT_LIST_DIR}/" "" steps_fixed "${steps_fixed}")
STRING(REPLACE "${CMAKE_CURRENT_LIST_DIR}/" "" steps_float "${steps_float}")
#MESSAGE(---------${steps_risc})
#return ()



set(LDS 	"${BOARD}.lds")
set(EXTRA_TARGETS "")

if (NOT RUN)
	set( RUNNER "${BOARD}run")
endif()
		
if ( BOARD STREQUAL "mc5103")
	set(dir_list ${steps_fixed} )
	set(CXXFLAGS " -O2 -Wall -mnmc3 -g")
	set(LIBS  	"-Wl,--whole-archive -lmc5103lib -Wl,--no-whole-archive")
	set(LIBSD 	"-Wl,--whole-archive -lmc5103lib -Wl,--no-whole-archive")
	
	foreach(dir ${dir_list})
		CONFIGURE_TEST(${dir} ${BOARD} "")
    endforeach()
endif()	


if ( BOARD STREQUAL "mb7707")
	set(dir_list ${steps_fixed} )
	set(CXXFLAGS " -O2 -Wall -mnmc3 -g")
	set(LIBS  	"-Wl,--whole-archive -lmb7707lib -Wl,--no-whole-archive")
	set(LIBSD 	"-Wl,--whole-archive -lmb7707lib -Wl,--no-whole-archive")
	set(RUNOPT  "-a${MAC} ")
	set(RUNOPTD "-a${MAC} ")
	
	foreach(dir ${dir_list})
		CONFIGURE_TEST(${dir} ${BOARD} "")
    endforeach()
endif()	


if ( BOARD STREQUAL "mc12101" AND CORE STREQUAL "-nmpu1")
	set(dir_list ${steps_risc} ${steps_fixed} )
	set(CXXFLAGS " -O2 -Wall -mnmc4-fixed -g")
	set(LIBS  	" -lnm6407int -Wl,--whole-archive -lnm6407_io_nmc -lmc12101load_nm -Wl,--no-whole-archive")
	set(LIBSD 	" -Wl,--whole-archive -lnm6407_io_nmc -lmc12101_stub_nmc4_fixed -Wl,--no-whole-archive")
	set(LDS 	"${BOARD}-nmpu1.lds")
	set(RUNOPT  "-p -R -a1 -v" )
	set(RUNOPTD "-p -R -a1 -v" )
	set(MONITOR "nmc-monitor")
	
	foreach(dir ${dir_list})
		CONFIGURE_TEST(${dir} ${BOARD} "-nmpu1")
    endforeach()
endif()	

if ( BOARD STREQUAL "mc12101" AND CORE STREQUAL "-nmpu0")
	set(dir_list ${steps_risc} ${steps_float} )
	set(CXXFLAGS " -O2 -Wall -mnmc4-float -g")
	set(LIBS  	" -lnm6407int -Wl,--whole-archive -lnm6407_io_nmc -lmc12101load_nm -Wl,--no-whole-archive")
	set(LIBSD 	" -Wl,--whole-archive -lnm6407_io_nmc -lmc12101_stub_nmc4_float -Wl,--no-whole-archive")
	set(LDS 	"${BOARD}-nmpu0.lds")
	set(RUNOPT	"-p -R -a0 -v" )
	set(RUNOPTD "-p -R -a0 -v" )
	
	#set( SEXY_LIST ${RUNOPT} )
	#separate_arguments(SEXY_LIST)
	set(MONITOR "nmc-monitor")
	
	foreach(dir ${dir_list})
		CONFIGURE_TEST(${dir} ${BOARD} "-nmpu0")
    endforeach()
endif()	


if ( BOARD STREQUAL "mc12705")
	set(dir_list ${steps_risc} ${steps_float} )
	set(CXXFLAGS " -O2 -Wall -mnmc4-float -g")
	set(LIBS  	"-Wl,--whole-archive -lnm6408load_nmc -lnmc_io -Wl,--no-whole-archive")
	set(LIBSD 	"-Wl,--whole-archive -lnm6408load_nmc -lnmc_io -lnm6408_stub -Wl,--no-whole-archive")
	set(LDS 	"${BOARD}.lds")
	set(RUNOPT 	"-c0 -n0 -v")
	set(RUNOPTD "-c0 -n0 -v")
	set(MONITOR "nmc-monitor")
	
	foreach(dir ${dir_list})
		CONFIGURE_TEST(${dir} ${BOARD} "")
    endforeach()
endif()	

if ( BOARD STREQUAL "qemu" )
	set(dir_list ${steps_risc} ${steps_fixed} ${steps_float})
	set(CXXFlAGS " -O2 -Wall -mnmc4 -g")
	set(LIBS  	" -lc")
	set(LIBSD 	" -lc")
	set(LDS 	"qemu.lds")
	set(RUNNER 	"nmc-qemu")
	set(RUNOPT 	" ")
	set(RUNOPTD "-g 5555")
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
