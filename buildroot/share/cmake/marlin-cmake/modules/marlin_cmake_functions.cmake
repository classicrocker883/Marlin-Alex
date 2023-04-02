#=============================================================================#
# Author: Tom Haraldseid (tohara)
# Home:   https://github.com/tohara/marlin-cmakeke
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.
#=============================================================================#

set(DIR_OF_MARLIN_CMAKE_FUNCTIONS_CMAKE ${CMAKE_CURRENT_LIST_DIR})

function(read_define_value_from_header PATH VARIABLE)
	
    if(EXISTS ${PATH})
	    file(STRINGS ${PATH} FILE_ENTRIES)  # Settings file split into lines
	
	    foreach(FILE_ENTRY ${FILE_ENTRIES})
	        if("${FILE_ENTRY}" MATCHES "^[ ]*#define[ ]+${VARIABLE}([ ]+([^/]*))?")
	        	
	        	set(FOUND 1)
	        	set(VALUE ${CMAKE_MATCH_1})
	        	
	        	if(VALUE)
	        		STRING(STRIP ${VALUE} VALUE)
	        	endif()
	        	
	        	message(STATUS "Variable ${VARIABLE} found in line: " ${FILE_ENTRY})
	        	message(STATUS "${VARIABLE}'s value is: " '${VALUE}')
	        	
	            break()
	       
	        endif()
	
		endforeach()
		
		if(NOT FOUND)
			message(STATUS "Variable ${VARIABLE} not found")
		endif()
		
	else()
		message(STATUS "Header path ${PATH} does not exist")
	endif()
  
  
  set(${VARIABLE}_FOUND ${FOUND} PARENT_SCOPE)
  set(${VARIABLE}_VALUE ${VALUE} PARENT_SCOPE)
  
  
endfunction()

function(LOAD_SETTINGS SETTINGS_PATH)

    if(EXISTS ${SETTINGS_PATH})
        file(STRINGS ${SETTINGS_PATH} FILE_ENTRIES)  # Settings file split into lines
    
        foreach(FILE_ENTRY ${FILE_ENTRIES})
            if("${FILE_ENTRY}" MATCHES "^[^#]+=.*")
                string(REGEX MATCH "^[^=]+" SETTING_NAME  ${FILE_ENTRY})
                string(REGEX MATCH "[^=]+$" SETTING_VALUE ${FILE_ENTRY})
                string(REPLACE "." ";" ENTRY_NAME_TOKENS ${SETTING_NAME})
                string(STRIP "${SETTING_VALUE}" SETTING_VALUE)
    
                list(LENGTH ENTRY_NAME_TOKENS ENTRY_NAME_TOKENS_LEN)
              
	            # Add entry to settings list if it does not exist
	            list(GET ENTRY_NAME_TOKENS 0 ENTRY_NAME)
	            
    
    	
                # Add entry setting to entry settings list if it does not exist
                set(ENTRY_SETTING_LIST ${ENTRY_NAME}.SETTINGS)
                list(GET ENTRY_NAME_TOKENS 1 ENTRY_SETTING)
                
    	        set(PARAMETERS 2)
    	    
    		    list(FIND ${ENTRY_SETTING_LIST} ${ENTRY_SETTING} ENTRY_SETTING_INDEX)
    		    if(ENTRY_SETTING_INDEX LESS 0)
    		        # Add setting to entry
    		        list(APPEND ${ENTRY_SETTING_LIST} ${ENTRY_SETTING})
    		        set(${ENTRY_SETTING_LIST} ${${ENTRY_SETTING_LIST}}
    		            CACHE INTERNAL "Marlin board settings")
    		    endif()
        	    
        	    set(FULL_SETTING_NAME ${ENTRY_NAME}.${ENTRY_SETTING})
        	    
                # Save setting value
                set(${FULL_SETTING_NAME} ${SETTING_VALUE}
                    CACHE INTERNAL "Marlin board settings")
                    
            endif()
        endforeach()
    endif()
endfunction()

function(get_motherboard SRCPATH)
	read_define_value_from_header(${SRCPATH}/Configuration.h MOTHERBOARD)
	set(MOTHERBOARD_FOUND ${MOTHERBOARD_FOUND} PARENT_SCOPE)
  	set(MOTHERBOARD ${MOTHERBOARD_VALUE} PARENT_SCOPE)
endfunction()

function(setup_motherboard TARGET SRCPATH)
    load_settings(${DIR_OF_MARLIN_CMAKE_FUNCTIONS_CMAKE}/../settings/marlin_boards.txt)
    get_motherboard(${SRCPATH})
    set(${TARGET}_BOARD ${${MOTHERBOARD}.board} PARENT_SCOPE)
    set(${TARGET}_CPU ${${MOTHERBOARD}.mcu} PARENT_SCOPE)
  
endfunction()

