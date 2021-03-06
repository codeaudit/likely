option(LIKELY_HELLOWORLD "Build Hello World examples" ON)

if(LIKELY_HELLOWORLD)
  # Interpreted
  add_test(NAME hello_world_interpreted
           WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
           COMMAND likely ${PROJECT_SOURCE_DIR}/share/likely/hello_world/hello-world-interpreted.lisp -q)

  # JIT Compiled
  add_executable(hello_world_jit hello_world_jit.c)
  target_link_libraries(hello_world_jit likely_shared)
  add_test(NAME hello_world_jit
           COMMAND hello_world_jit ${PROJECT_SOURCE_DIR}/data/misc/lenna.tiff ${PROJECT_SOURCE_DIR}/share/likely/hello_world/hello-world-compiled.lisp dark_lenna.png)

  # Static Compiled
  add_custom_command(OUTPUT hello_world_compiled_lisp.o
                     COMMAND likely -ro ${CMAKE_CURRENT_SOURCE_DIR}/hello-world-compiled.lisp hello_world_compiled_lisp.o
                     DEPENDS likely hello-world-compiled.lisp)
  set_source_files_properties(hello_world_compiled_lisp.o PROPERTIES EXTERNAL_OBJECT true GENERATED true)
  add_definitions(-DLIKELY_LIBRARY)
  add_executable(hello_world_static hello_world_static.c hello_world_compiled_lisp.o)
  target_link_libraries(hello_world_static likely_shared)
  add_test(NAME hello_world_static
           COMMAND hello_world_static ${PROJECT_SOURCE_DIR}/data/misc/lenna.tiff dark_lenna.png)

  # Pre-compiled
  add_executable(hello_world_precompiled hello_world_precompiled.c)
  target_link_libraries(hello_world_precompiled likely_shared)
  add_test(NAME hello_world_precompile
           COMMAND likely -ro ${CMAKE_CURRENT_SOURCE_DIR}/hello-world-compiled.lisp ${PROJECT_BINARY_DIR}/hello_world_precompiled_lisp.bc)
  add_test(NAME hello_world_precompiled
           COMMAND hello_world_precompiled ${PROJECT_SOURCE_DIR}/data/misc/lenna.tiff ${PROJECT_BINARY_DIR}/hello_world_precompiled_lisp.bc hello_world dark_lenna.png)

  # Main
  add_custom_command(OUTPUT hello_world_main.o
                     COMMAND likely ${CMAKE_CURRENT_SOURCE_DIR}/hello-world-main.lisp hello_world_main.o
                     DEPENDS likely hello-world-main.lisp)
  likely_executable(hello_world_main)
  add_test(NAME hello_world_main
           COMMAND hello_world_main ${PROJECT_SOURCE_DIR}/data/misc/lenna.tiff dark_lenna.png)
endif()
