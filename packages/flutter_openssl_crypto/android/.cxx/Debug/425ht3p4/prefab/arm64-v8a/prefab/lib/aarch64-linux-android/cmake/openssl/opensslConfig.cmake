if(NOT TARGET openssl::crypto)
add_library(openssl::crypto SHARED IMPORTED)
set_target_properties(openssl::crypto PROPERTIES
    IMPORTED_LOCATION "/home/rbarbe/.gradle/caches/transforms-3/dfad2c80377f483721e6c10edd671277/transformed/jetified-openssl-1.1.1q-beta-1/prefab/modules/crypto/libs/android.arm64-v8a/libcrypto.so"
    INTERFACE_INCLUDE_DIRECTORIES "/home/rbarbe/.gradle/caches/transforms-3/dfad2c80377f483721e6c10edd671277/transformed/jetified-openssl-1.1.1q-beta-1/prefab/modules/crypto/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

if(NOT TARGET openssl::ssl)
add_library(openssl::ssl SHARED IMPORTED)
set_target_properties(openssl::ssl PROPERTIES
    IMPORTED_LOCATION "/home/rbarbe/.gradle/caches/transforms-3/dfad2c80377f483721e6c10edd671277/transformed/jetified-openssl-1.1.1q-beta-1/prefab/modules/ssl/libs/android.arm64-v8a/libssl.so"
    INTERFACE_INCLUDE_DIRECTORIES "/home/rbarbe/.gradle/caches/transforms-3/dfad2c80377f483721e6c10edd671277/transformed/jetified-openssl-1.1.1q-beta-1/prefab/modules/ssl/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

